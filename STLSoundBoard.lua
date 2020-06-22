STLSoundBoard = { }

--Druid color: ff7d0a
--Hunter color: a9d271
--Mage color: 40c7eb
--Paladin color: f58cba
--Priest color: ffffff
--Rogue color: fff569
--Shaman color: 0070de
--Warlock color: 8787ed
--Warrior color: c79c6e

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
                -- pass a variable number of arguments
                self:OnEvent(event, CombatLogGetCurrentEventInfo())
end)

function f:OnEvent(event, ...)
    --print(CombatLogGetCurrentEventInfo())
    local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
    local spellId, spellName, spellSchool
    local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

    if subevent == "SWING_DAMAGE" then
        amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "SPELL_DAMAGE" or subevent == "RANGE_DAMAGE" then
        spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "SPELL_HEAL" then
        spellId, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
    elseif subevent == "SPELL_AURA_APPLIED" then
        spellId, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
    end

    --
    -- Spell Effects
    --
    if spellName == "Polymorph" and sourceName == "Powerthirst" then
        local MSG_POLYMORPH_EFFECT = "|cff40c7eb%s *IS* turtley enough for the Turtle Club!"
        print(MSG_POLYMORPH_EFFECT:format(destName))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\TurtleTurtle.mp3", "Master")
    end

    --
    -- Critical Hits
    --
    if critical and sourceName == "Beveryman" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cffc79c6e%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Powerthirst.mp3", "Master")
    end

    if critical and sourceName == "Bombola" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cfffff569%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Zap.mp3", "Master")
    end

    if critical and sourceName == "Crumbles" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cffa9d271%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Snip_Snap.mp3", "Master")
    end

    if critical and sourceName == "Funkyphantom" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cffc79c6e%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Funky.mp3", "Master")
    end

    if critical and sourceName == "Harumph" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cff8787ed%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Harumph.mp3", "Master")
    end

    if critical and sourceName == "Heboric" and subevent == "SPELL_HEAL" and (destName == "Beveryman" or destName == "Crumbles" or destName == "Funkyphantom" or destName == "Harumph" or destName == "Heboric" or destName == "Panserbjørn" or destName == "Powerthirst" or destName == "Rawberry" or destName == "Shmeeshmaam") then
        local action = spellName
        local MSG_CRITICAL_HIT = "|cffffffff%s's %s critically healed %s for %d health!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Hallelujah.mp3", "Master")
    end

    if critical and sourceName == "Luger" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cffa9d271%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\GunShow.mp3", "Master")
    end

    if critical and sourceName == "Resaris" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cfffff569%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\GunShow.mp3", "Master")
    end

    if critical and sourceName == "Panserbjørn" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cffff7d0a%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Angry_Cat.mp3", "Master")
    end

    if critical and sourceName == "Powerthirst" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cff40c7eb%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Powerthirst.mp3", "Master")
    end

    if critical and sourceName == "Rawberry" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cffa9d271%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Powerthirst.mp3", "Master")
    end

    if critical and sourceName == "Shmeeshmaam" then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|cfff58cba%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
        PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\I_Am_The_Law.mp3", "Master")
    end

    --if not critical and sourceName == "Shmeetest" and subevent == "SPELL_HEAL" and (destName == "Crumbles" or destName == "Funkyphantom" or destName == "Heboric" or destName == "Panserbjørn" or destName == "Powerthirst" or destName == "Shmeeshmaam" or destName == "Shmeetest") then
    --local action = spellName
    --local MSG_CRITICAL_HIT = "|cffffffff%s's %s critically healed %s for %d health!"
    --print(MSG_CRITICAL_HIT:format(sourceName, action, destName, amount))
    --PlaySoundFile("Interface\\AddOns\\STLSoundBoard\\Sounds\\Harumph.mp3", "Master")
    --end
end
