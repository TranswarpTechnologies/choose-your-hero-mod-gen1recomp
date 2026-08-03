------------------------------------------------------------
-- Choose Your Hero Mod for Gen1Recomp
------------------------------------------------------------

------------------------------------------------------------
-- Local Sprites
------------------------------------------------------------

local WALK  = "assets/sprites/green.png"
local BIKE  = "assets/sprites/green_bike.png"
local FRONT = "assets/title/green.png"
local BACK  = "assets/battle/greenb.png"
local YELLOW_FRONT = "assets/battle/trainers/yellow0.png"
local YELLOW_BATTLE = "assets/battle/trainers/yellow1.png"

return function(mod)

local game
local vanilla = {}

local function asset(path)
return mod.assets:path(path)
end


------------------------------------------------------------
-- Register Alternate Sprite Definitions for Green
------------------------------------------------------------

mod.content.sprites:register("SPRITE_GREEN", {
    image = asset(WALK),
                             frames = 6,
                             walker = true,
})

mod.content.sprites:register("SPRITE_GREEN_BIKE", {
    image = asset(BIKE),
                             frames = 6,
                             walker = true,
})

------------------------------------------------------------
-- Save Flags
------------------------------------------------------------

local function isGreen()
return mod.save:get("player", "red") == "green"
end


local function isYellow()
return mod.save:get("rival", "blue") == "yellow"
end

------------------------------------------------------------
-- Replace Overworld Sprites
------------------------------------------------------------

local function applyPlayerSprites()

if not game then
    return
    end

if not game.data or not game.data.sprites then
   return
   end


local sprites = game.data.sprites


if sprites.SPRITE_RED then

if not vanilla.walk then
   vanilla.walk = sprites.SPRITE_RED.image
end


if isGreen() then
   sprites.SPRITE_RED.image = asset(WALK)
else
   sprites.SPRITE_RED.image = vanilla.walk
end

end

if sprites.SPRITE_RED_BIKE then

if not vanilla.bike then
   vanilla.bike = sprites.SPRITE_RED_BIKE.image
end


if isGreen() then
   sprites.SPRITE_RED_BIKE.image = asset(BIKE)
else
   sprites.SPRITE_RED_BIKE.image = vanilla.bike
end

end

if sprites.SPRITE_BLUE then

if not vanilla.rivalWalk then
   vanilla.rivalWalk = sprites.SPRITE_BLUE.image
end

if isYellow() then
   sprites.SPRITE_BLUE.image = asset("assets/sprites/yellow.png")
else
   sprites.SPRITE_BLUE.image = vanilla.rivalWalk
end

end

end

------------------------------------------------------------
-- Oak's Speech
------------------------------------------------------------

mod.hooks:wrap(
"intro.oak_speech.build",
function(next, steps, speech)

steps = next(steps, speech)

----------------------------------------------------
-- Choose Hero
----------------------------------------------------

mod.ui.insertStepBefore(
    steps,
    "ask_player_name",
    {
    id = "choose_player",
    kind = "choice",
    text = "Choose Your Hero:",
    saveKey = "player",
    choices = {
    "RED",
    "GREEN"
    },
    values = {
    "red",
    "green"
    },
    tx = 5,
    ty = 5,
    tw = 10
    }
    )



----------------------------------------------------
-- Choose Rival
----------------------------------------------------

mod.ui.insertStepBefore(
   steps,
   "ask_rival_name",
   {
   id = "choose_rival",
   kind = "choice",
   text = "Choose Your Rival:",
   saveKey = "rival",
   choices = {
   "BLUE",
   "YELLOW"
   },
   values = {
   "blue",
   "yellow"
   },
   tx = 5,
   ty = 4,
   tw = 10,
   th = 7
   }
   )

----------------------------------------------------
-- Apply fallback names
----------------------------------------------------

mod.ui.insertStepAfter(
    steps,
    "choose_player",
    {
    id = "update_player",
    kind = "fn",

    run = function(speech, done)

    local choice =
    mod.save:get("player", "red")


    for _, step in ipairs(speech.steps) do

    if step.id == "name_player" then

    if choice == "green" then

       step.presets =
       {
       "GREEN",
       "LEAF",
       "YELLOW"
       }

    else

       step.presets =
       {
       "RED",
       "ASH",
       "BLUE"
      }

    end

    break
    end
    end


    done()

    end
    }
)

----------------------------------------------------
-- Apply rival fallback names
----------------------------------------------------

mod.ui.insertStepAfter(
    steps,
    "choose_rival",
    {
    id = "update_rival",
    kind = "fn",

    run = function(speech, done)

    local choice =
    mod.save:get("rival", "blue")



    for _, step in ipairs(speech.steps) do

    if step.id == "name_rival" then

    if choice == "yellow" then

    step.presets =
    {
     "YELLOW",
     "DAISY",
     "GREEN"
    }

    else

    step.presets =
    {
     "BLUE",
     "GARY",
     "RED"
    }

    end

    break

    end

    end



    if choice == "yellow" then

    speech.rivalPic =
    mod.assets:image(YELLOW_FRONT)

    speech.rivalTrueColor =
        false


    for _, step in ipairs(speech.steps) do

    if step.id == "ask_rival_name" then

    step.text =
    "This is my grand-\ndaughter.\vShe's been\nyour rival since\nyou were a baby.\f...Erm, what was\nher name again?"


    elseif step.id == "confirm_rival_name" then

    step.text =
    "That's right!\nI remember now!\vHer name is {RIVAL}!"

    end

    end

    end


    done()

    end
    }
    )


    return steps

    end
    )

------------------------------------------------------------
-- Player portrait + save application
------------------------------------------------------------

mod.events:on(
   "intro.oak_speech.answered",
   function(ev)

   if ev.saveKey == "player" then

      mod.save:set("player", ev.value)


   if ev.value == "green" then

      ev.speech.playerPic =
      mod.assets:image(FRONT)

      ev.speech.playerTrueColor =
      false

   end

   end


   if ev.saveKey == "rival" then

      mod.save:set("rival", ev.value)

   end


   applyPlayerSprites()

   end
   )

------------------------------------------------------------
-- Battle sprites
------------------------------------------------------------

mod.hooks:wrap(
   "player.sprite",
   function(next, path, ctx)

   path = next(path, ctx)


   if not isGreen() then
   return path
   end


   if ctx.side == "back" then
   return asset(BACK)
   end


   return asset(FRONT)

   end
   )

------------------------------------------------------------
-- Yellow Rival Battle Sprite
------------------------------------------------------------

local RIVAL_OPP_CLASSES = {
      OPP_RIVAL1 = true,
      OPP_RIVAL2 = true,
      OPP_RIVAL3 = true,
      }


mod.events:on(
   "battle.started",
   function(ev)

   if not isYellow() then
   return
   end

   local battle = ev and ev.battle

   if not battle then
   return
   end

   if battle.kind ~= "trainer" then
   return
   end

   if not RIVAL_OPP_CLASSES[battle.oppClass] then
   return
   end


local ok, img = pcall(
      love.graphics.newImage,
      asset(YELLOW_BATTLE)
      )

      if ok and img then
      battle.trainerPic = img
      end

      end
      )


------------------------------------------------------------
-- Runtime initialization
------------------------------------------------------------

mod.events:on(
   "game.ready",
    function(ev)

    game = ev.game

    applyPlayerSprites()

    end
    )


mod.events:on(
   "save.loaded",
   function()

   applyPlayerSprites()

   end
   )


mod.events:on(
   "save.created",
   function()

   applyPlayerSprites()

   end
   )


end
