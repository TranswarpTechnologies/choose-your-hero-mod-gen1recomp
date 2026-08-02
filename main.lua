return function(mod)

    local player = mod.save:get("player", "red")
    local rival = mod.save:get("rival", "blue")

    mod.log:info("Player: " .. player)
    mod.log:info("Rival " .. rival)

    local Green_Front = "assets/title/green.png"
    local Green_Back = mod.assets:path("assets/battle/greenb.png")
    local Green_Walk  = "assets/sprites/green.png"
    local Green_Bike  = "assets/sprites/green_bike.png"
    local Yellow_Front = "assets/battle/trainers/yellow1.png"
    local vanilla = {}

    local function remember(def)

        if def and vanilla[def] == nil then
            vanilla[def] = {
                image = def.image,
                paletteSource = def.paletteSource
            }
        end

    end


    local function setPlayer(choice)
        mod.save:set("player", choice)
    end

    local function setRival(choice)
        mod.save:set("rival", choice)
    end


-- Hero & Rival Choice
    mod.hooks:wrap("intro.oak_speech.build",
    function(next, steps, speech)

        steps = next(steps, speech)


        mod.ui.insertStepBefore(steps, "ask_player_name", {
            id = "choose_hero",
            kind = "choice",
            text = "Choose Your Hero:",
            saveKey = "player",
            choices = { "RED", "GREEN" },
            values = { "red", "green" },
            tx = 5,
            ty = 5,
            tw = 10,
        })

        mod.ui.insertStepBefore(steps, "ask_player_name", {
            id = "update_player_pic",
            kind = "fn",
            run = function(speech, done)

            local choice = mod.save:get("player", "red")

            if choice == "green" then

                speech.playerPic = mod.assets:image(Green_Front)
                speech.playerTrueColor = false

                end


                for _, step in ipairs(speech.steps) do

                    if step.id == "name_player" then

                        if choice == "green" then
                            step.presets = { "GREEN", "LEAF", "YELLOW" }
                            else
                                step.presets = { "RED", "ASH", "BLUE" }
                                end

                                break
                                end

                                end


                                done()

                                end
        })


        mod.ui.insertStepBefore(steps, "ask_rival_name", {
            id = "choose_rival",
            kind = "choice",
            text = "Choose Your Rival:",
            saveKey = "rival",
            choices = { "BLUE", "YELLOW" },
            values = { "blue", "yellow" },
            tx = 5,
            ty = 4,
            tw = 10,
            th = 7
        })


        mod.ui.insertStepAfter(steps, "choose_rival", {
            id = "update_rival",
            kind = "fn",
            run = function(speech, done)

            local choice = mod.save:get("rival", "blue")


            for _, step in ipairs(speech.steps) do

                if step.id == "name_rival" then

                    if choice == "yellow" then
                        step.presets = { "YELLOW", "DAISY", "GREEN" }
                        else
                            step.presets = { "BLUE", "GARY", "RED" }
                            end

                            break

                            end

                            end


                            if choice == "yellow" then

                                speech.rivalPic = mod.assets:image(Yellow_Front)
                                speech.rivalTrueColor = false


                                for _, step in ipairs(speech.steps) do

                                    if step.id == "ask_rival_name" then

                                        step.text =
                                        "This is my grand-\ndaughter.\vShe's been\nyour rival since\nyou were a baby.\f...Erm, what was\nher name again?"

                                        elseif step.id == "confirm_rival_name" then

                                            step.text =
                                            "That's right! \nI remember now! \vHer name is {RIVAL}!"

                                        end

                                    end

                                end


                            done()

                    end
        })


        return steps

    end)


    mod.events:on("intro.oak_speech.answered", function(ev)


-- Player Portrait Selection

        if ev.saveKey == "player" then

            setPlayer(ev.value)

            if ev.value == "green" then

                local image = mod.assets:image(Green_Front)

                ev.speech.playerPic = image
                ev.speech.playerTrueColor = false

            end

        end

        if ev.saveKey == "rival" then

            setRival(ev.value)

            if ev.value == "yellow" then

                ev.speech.rivalPic = mod.assets:image(Yellow_Front)
                ev.speech.rivalTrueColor = false

                end

        end

    end)


-- Player Battle Sprite

mod.hooks:wrap("player.sprite", function(next, path, ctx)

    path = next(path, ctx)

    local choice = mod.save:get("player", "red")

    if choice ~= "green" then
        return path
    end

    if ctx.side == "back" and not ctx.demo and not ctx.oakDemo then
        return Green_Back
    end

    return path

end)



-- Overworld Sprite Swap

local function applyPlayerSprites(game)

    if not game or not game.data or not game.data.sprites then
        return
    end

    local sprites = game.data.sprites

    local pairsOf = {

        {
            def = sprites.SPRITE_RED,
            image = Green_Walk
        },

        {
            def = sprites.SPRITE_RED_BIKE,
            image = Green_Bike
        }

    }

    for _, row in ipairs(pairsOf) do

        local def = row.def

        if def then

            remember(def)

            if mod.save:get("player", "red") == "green" then

                def.image = row.image

            else

                def.image = vanilla[def].image
                def.paletteSource = vanilla[def].paletteSource

            end

        end

    end

end


mod.events:on("game.ready", function(ev)
    applyPlayerSprites(ev.game)
end)

mod.events:on("save.loaded", function(ev)
    applyPlayerSprites(ev.game)
end)

mod.events:on("save.created", function(ev)
    applyPlayerSprites(ev.game)
end)


end
