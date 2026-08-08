-- Female dialogue only applies to a Green save.
if mod.save:get("player", "red") ~= "green" then
    return
    end

    local textChanges = {
        _RedsHouse1FMomWakeUpText = "MOM: Right.\nAll girls leave\vhome some day.\vIt said so on TV.\fPROF.OAK, next\ndoor, is looking\vfor you.",
        _SaffronGateGuardImParchedText = "Whoa, miss!\nI'm parched!\v...\vHuh? I can have\vthis drink?\vGee, thanks!",
        _Route9Hiker3BattleText = "Hahahaha!\nCome on, lady!",
        _SSAnne1FRoomsGirl1Text = "Waitress, I would\nlike a cherry pie\vplease!",
        _Route14Biker2AfterBattleText = "Raising POKéMON\nis a drag, lady.",
        _SSTicketNoRoomText = "You've got too\nmuch stuff, lady!",
        _BillsHouseBillCheckOutMyRarePokemonText = "BILL: Look, lady,\njust check out\vsome of my rare\vPOKéMON on my PC!",
        _BillsHouseBillThankYouText = "BILL: Yeehah!\nThanks, miss! I\vowe you one!\fSo, did you come\nto see my POKéMON\vcollection?\vYou didn't?\vThat's a bummer.\fI've got to thank\nyou... Oh here,\vmaybe this'll do.",
    }

    for label, text in pairs(textChanges) do
        mod.content.text:override(label, text)
        end

        end

        return
