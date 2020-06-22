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
    ["Funkyphantom"] = STLSoundFolder .. "KennedySpirit.mp3",
    ["Harumph"] = STLSoundFolder .. "MarioDeath.mp3",
    ["Heboric"] = STLSoundFolder .. "Wiggam.mp3",
    ["Luger"] = STLSoundFolder .. "Wiggam.mp3",
    ["Panserbjørn"] = STLSoundFolder .. "ComingRightForUs.mp3",
    ["Powerthirst"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Rawberry"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Resaris"] = STLSoundFolder .. "Wiggam.mp3",
    ["Shmeeshmaam"] = STLSoundFolder .. "MarioDeath.mp3",
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
    elseif subevent == "UNIT_DIED" then
        recapId, unconscious = select(12, ...)
    end

    --
    -- Spell Effects
    --
    if spellName == "Polymorph" and sourceName == "Powerthirst" then
        local MSG_POLYMORPH_EFFECT = "|c%s%s *IS* turtley enough for the Turtle Club!"
        print(MSG_POLYMORPH_EFFECT:format(STLClassColor(sourceName), destName))
        PlaySoundFile(STLSoundFolder .. "TurtleTurtle.mp3", STLSoundChannel)
        return
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
        PlaySoundFile(STLHealSounds[sourceName], STLSoundChannel)
        return
    end

    --
    -- Critical Hits
    --
    if critical and STLCritSounds[sourceName] then
        local action = spellName or MELEE
        local MSG_CRITICAL_HIT = "|c%s%s's %s critically hit %s for %d damage!"
        print(MSG_CRITICAL_HIT:format(STLClassColor(sourceName), sourceName, action, destName, amount))

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
