STLSoundBoard = { }

local STLSoundFolder = "Interface\\AddOns\\STLSoundBoard\\Sounds\\"
local STLSoundChannel = "Master"

local STLClassColors = {
    ["Druid"] = "ffff7d0a",
    ["Hunter"] = "ffa9d271",
    ["Mage"] = "ff40c7eb",
    ["Paladin"] = "fff58cba",
    ["Priest"] = "ffffffff",
    ["Rogue"] = "fffff569",
    ["Shaman"] = "ff0070de",
    ["Warlock"] = "ff8787ed",
    ["Warrior"] = "ffc79c6e",
}

local STLCharacters = {
    ["Beveryman"] = "Warrior",
    ["Bombola"] = "Rogue",
    ["Crumbles"] = "Hunter",
    ["Funkyphantom"] = "Warrior",
    ["Harumph"] = "Warlock",
    ["Heboric"] = "Priest",
    ["Luger"] = "Hunter",
    ["Panserbjørn"] = "Druid",
    ["Powerthirst"] = "Mage",
    ["Rawberry"] = "Hunter",
    ["Resaris"] = "Rogue",
    ["Shmeeshmaam"] = "Paladin",
    ["Shmeetest"] = "Priest",
}

local STLCritSounds = {
    ["Beveryman"] = STLSoundFolder .. "Powerthirst.mp3",
    ["Bombola"] = STLSoundFolder .. "Zap.mp3",
    ["Crumbles"] = STLSoundFolder .. "Snip_Snap.mp3",
    ["Funkyphantom"] = STLSoundFolder .. "Funky.mp3",
    ["Harumph"] = STLSoundFolder .. "Harumph.mp3",
    ["Heboric"] = STLSoundFolder .. "GunShow.mp3",
    ["Luger"] = STLSoundFolder .. "GunShow.mp3",
    ["Panserbjørn"] = STLSoundFolder .. "Angry_Cat.mp3",
    ["Powerthirst"] = STLSoundFolder .. "Powerthirst.mp3",
    ["Rawberry"] = STLSoundFolder .. "Powerthirst.mp3",
    ["Resaris"] = STLSoundFolder .. "GunShow.mp3",
    ["Shmeeshmaam"] = STLSoundFolder .. "I_Am_The_Law.mp3",
}

local STLHealSounds = {
    ["Heboric"] = STLSoundFolder .. "Hallelujah.mp3",
    ["Panserbjørn"] = STLSoundFolder .. "Hallelujah.mp3",
    ["Shmeeshmaam"] = STLSoundFolder .. "Hallelujah.mp3",
}

local STLDeathSounds = {
    ["Beveryman"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Bombola"] = STLSoundFolder .. "Whatchasay.mp3",
    ["Crumbles"] = STLSoundFolder .. "Whatchasay.mp3",
    ["Funkyphantom"] = STLSoundFolder .. "Apollo13Blowup.mp3",
    ["Harumph"] = STLSoundFolder .. "MarioDeath.mp3",
    ["Heboric"] = STLSoundFolder .. "Wiggam.mp3",
    ["Luger"] = STLSoundFolder .. "Wiggam.mp3",
    ["Panserbjørn"] = STLSoundFolder .. "ComingRightForUs.mp3",
    ["Powerthirst"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Rawberry"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Resaris"] = STLSoundFolder .. "Wiggam.mp3",
    ["Shmeeshmaam"] = STLSoundFolder .. "MarioDeath.mp3",
}

local STLCritRecords = {
    ["Beveryman"] = 0,
    ["Bombola"] = 0,
    ["Crumbles"] = 0,
    ["Funkyphantom"] = 0,
    ["Harumph"] = 0,
    ["Heboric"] = 0,
    ["Luger"] = 0,
    ["Panserbjørn"] = 0,
    ["Powerthirst"] = 0,
    ["Rawberry"] = 0,
    ["Resaris"] = 0,
    ["Shmeeshmaam"] = 0,
}

local STLHealRecords = {
    ["Heboric"] = 0,
    ["Panserbjørn"] = 0,
    ["Shmeeshmaam"] = 0,
}

function STLClassColor(charName)
    return STLClassColors[STLCharacters[charName]]
end

local critWindowStartTime = 0
local critWindowOwner = ""
local critWindowCount = 0

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
                -- pass a variable number of arguments
                self:OnEvent(event, CombatLogGetCurrentEventInfo())
end)

function f:OnEvent(event, ...)
    --print(CombatLogGetCurrentEventInfo())
    local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
    local spellId, spellName, spellSchool, recapId, unconscious
    local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

    if subevent == "SWING_DAMAGE" then
        amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "SPELL_DAMAGE" or subevent == "RANGE_DAMAGE" then
        spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "SPELL_HEAL" then
        spellId, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
    elseif subevent == "SPELL_AURA_APPLIED" then
        spellId, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, ...)
    elseif subevent == "SPELL_CAST_START" then
        spellId, spellName, spellSchool = select(12, ...)
    elseif subevent == "SPELL_CAST_SUCCESS" then
        spellId, spellName, spellSchool = select(12, ...)
    elseif subevent == "UNIT_DIED" then
        recapId, unconscious = select(12, ...)
    end

    --
    -- Spell Effects
    --
    if STLCharacters[sourceName] then
        -- Polymorph Turtle
        --
        if subevent == "SPELL_AURA_APPLIED" and spellName == "Polymorph" then
            local MSG_POLYMORPH_EFFECT = "|c%s%s *IS* turtley enough for the Turtle Club!"
            print(MSG_POLYMORPH_EFFECT:format(STLClassColor(sourceName), destName))
            PlaySoundFile(STLSoundFolder .. "TurtleTurtle.mp3", STLSoundChannel)
            return
        end
        -- Mind Control casting
        --
        if subevent == "SPELL_CAST_START" and spellName == "Mind Control" then
            -- SPELL_CAST_START subevent has nil destName for some reason. GetUnitName is workaround
            target = GetUnitName("target")
            local MSG_MIND_CONTROL_EFFECT = "|c%s%s is taking %s's mind! Booweeeeoooo..."
            print(MSG_MIND_CONTROL_EFFECT:format(STLClassColor(sourceName), sourceName, target))
            PlaySoundFile(STLSoundFolder .. "Mentok_the_Mindtaker.mp3", STLSoundChannel)
            return
        end
        -- Blessing of Protection
        --
        if subevent == "SPELL_AURA_APPLIED" and spellName == "Blessing of Protection" then
            local MSG_BLESSING_OF_PROTECTION_EFFECT = "|c%s%s has been BoPed by %s! No Touchy"
            print(MSG_BLESSING_OF_PROTECTION_EFFECT:format(STLClassColor(sourceName), destName, sourceName))
            PlaySoundFile(STLSoundFolder .. "NoTouchy.mp3", STLSoundChannel)
            return
        end
        -- Taunt
        --
        if subevent == "SPELL_CAST_SUCCESS" and (spellName == "Taunt" or spellName == "Growl") then
            local MSG_TAUNT_SUCCESS = "|c%s%s taunted by %s! Give Uncle Scrotor a hug!"
            print(MSG_TAUNT_SUCCESS:format(STLClassColor(sourceName), destName, sourceName))
            PlaySoundFile(STLSoundFolder .. "UncleScrotor.mp3", STLSoundChannel)
            return
        end
        -- Holy Wrath
        --
        if subevent == "SPELL_CAST_START" and spellName == "Holy Wrath" then
            local MSG_HOLY_WRATH = "|c%s%s casting %s!"
            print(MSG_HOLY_WRATH:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "NixonLurcher.mp3", STLSoundChannel)
            return
        end
        -- AOE Fear
        --
        if subevent == "SPELL_CAST_SUCCESS" and (spellName == "Intimidating Shout" or spellName == "Psychic Scream") then
            local MSG_AOE_FEAR = "|c%s%s cast %s!"
            print(MSG_AOE_FEAR:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "BattleShout.mp3", STLSoundChannel)
            return
        end
    end

    --
    -- Deaths
    --
    if recapId and STLDeathSounds[destName] then
        PlaySoundFile(STLDeathSounds[destName], STLSoundChannel)
        return
    end

    --
    -- Healing
    --
    if critical and subevent == "SPELL_HEAL" and STLHealSounds[sourceName] and STLCharacters[destName] then
        local action = spellName
        local MSG_CRITICAL_HIT = "|c%s%s's %s critically healed %s for %d health!"
        print(MSG_CRITICAL_HIT:format(STLClassColor(sourceName), sourceName, action, destName, amount))

        if amount > STLHealRecords[sourceName] then
            STLHealRecords[sourceName] = amount
            PlaySoundFile(STLSoundFolder .. "DamnSon.mp3", STLSoundChannel)
        else
            PlaySoundFile(STLHealSounds[sourceName], STLSoundChannel)
        end
        return
    end

    --
    -- Critical Hits
    --
    if critical and STLCritSounds[sourceName] then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|c%s%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(STLClassColor(sourceName), sourceName, action, destName, amount))

        -- Critical record, always sound
        if amount > STLCritRecords[sourceName] then
            STLCritRecords[sourceName] = amount
            PlaySoundFile(STLSoundFolder .. "DamnSon.mp3", STLSoundChannel)
            return
        end
        -- Solo play, always sound
        if not IsInGroup() then
            PlaySoundFile(STLCritSounds[sourceName], STLSoundChannel)
            return
        end
        -- Group play, use a time window
        currentTime = time()
        if currentTime >= critWindowStartTime then
            critWindowStartTime = currentTime + 4 + random(3)

            if sourceName == critWindowOwner then
                critWindowCount = critWindowCount + 1
            else
                critWindowOwner = sourceName
                critWindowCount = 1
            end
            if critWindowCount >= 3 then
                critWindowCount = 0
                PlaySoundFile(STLSoundFolder .. "OhBabyATriple.mp3", STLSoundChannel)
            else
                PlaySoundFile(STLCritSounds[sourceName], STLSoundChannel)
            end
        end
    end
end
