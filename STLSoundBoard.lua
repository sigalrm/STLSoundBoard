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
    ["Blubblub"] = "Warrior",
    ["Bombola"] = "Rogue",
    ["Crumbbug"] = "Paladin",
    ["Crumbles"] = "Hunter",
    ["Funkyphantom"] = "Warrior",
    ["Harumph"] = "Warlock",
    ["Heboric"] = "Priest",
    ["Luger"] = "Hunter",
    ["Panserbjørn"] = "Druid",
    ["Pistachu"] = "Shaman",
    ["Powerthirst"] = "Mage",
    ["Rawberry"] = "Hunter",
    ["Resaris"] = "Rogue",
    ["Shmeeshmaam"] = "Paladin",
    ["Shmeetest"] = "Priest",
    ["Troffer"] = "Priest",
}

local STLCritSounds = {
    ["Beveryman"] = STLSoundFolder .. "Powerthirst.mp3",
    ["Blubblub"] = STLSoundFolder .. "Powerthirst.mp3",
    ["Bombola"] = STLSoundFolder .. "Zap.mp3",
    ["Crumbbug"] = STLSoundFolder .. "I_Am_The_Law.mp3",
    ["Crumbles"] = STLSoundFolder .. "Snip_Snap.mp3",
    ["Funkyphantom"] = STLSoundFolder .. "Funky.mp3",
    ["Harumph"] = STLSoundFolder .. "Harumph.mp3",
    ["Heboric"] = STLSoundFolder .. "GunShow.mp3",
    ["Luger"] = STLSoundFolder .. "GunShow.mp3",
    ["Panserbjørn"] = STLSoundFolder .. "Angry_Cat.mp3",
    ["Pistachu"] = STLSoundFolder .. "GunShow.mp3",
    ["Powerthirst"] = STLSoundFolder .. "Powerthirst.mp3",
    ["Rawberry"] = STLSoundFolder .. "Powerthirst.mp3",
    ["Resaris"] = STLSoundFolder .. "GunShow.mp3",
    ["Shmeeshmaam"] = STLSoundFolder .. "I_Am_The_Law.mp3",
    ["Troffer"] = STLSoundFolder .. "Powerthirst.mp3",
}

local STLHealSounds = {
    ["Crumbbug"] = STLSoundFolder .. "Hallelujah.mp3",
    ["Heboric"] = STLSoundFolder .. "Hallelujah.mp3",
    ["Panserbjørn"] = STLSoundFolder .. "Hallelujah.mp3",
    ["Pistachu"] = STLSoundFolder .. "Hallelujah.mp3",
    ["Shmeeshmaam"] = STLSoundFolder .. "Hallelujah.mp3",
    ["Troffer"] = STLSoundFolder .. "Hallelujah.mp3",
}

local STLDeathSounds = {
    ["Beveryman"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Blubblub"] = STLSoundFolder .. "MarioDeath.mp3",
    ["Bombola"] = STLSoundFolder .. "Whatchasay.mp3",
    ["Crumbles"] = STLSoundFolder .. "Whatchasay.mp3",
    ["Crumbbug"] = STLSoundFolder .. "Whatchasay.mp3",
    ["Funkyphantom"] = STLSoundFolder .. "Apollo13Blowup.mp3",
    ["Harumph"] = STLSoundFolder .. "MarioDeath.mp3",
    ["Heboric"] = STLSoundFolder .. "Wiggam.mp3",
    ["Luger"] = STLSoundFolder .. "Wiggam.mp3",
    ["Panserbjørn"] = STLSoundFolder .. "ComingRightForUs.mp3",
    ["Pistachu"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Powerthirst"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Rawberry"] = STLSoundFolder .. "NixonGrumble.mp3",
    ["Resaris"] = STLSoundFolder .. "Wiggam.mp3",
    ["Shmeeshmaam"] = STLSoundFolder .. "MarioDeath.mp3",
    ["Troffer"] = STLSoundFolder .. "NixonGrumble.mp3",
}

local STLSpecialCritAbility = {
    ["Druid"] = "Moonfire",
    ["Hunter"] = "Arcane Shot",
    ["Mage"] = "Fire Blast",
    ["Paladin"] = "Hammer of Wrath",
    ["Priest"] = "Mind Blast",
    ["Rogue"] = "Sinister Strike",
    ["Shaman"] = "Earth Shock",
    ["Warlock"] = "Shadowburn",
    ["Warrior"] = "Heroic Strike",
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
    ["Troffer"] = 0,
}

local STLHealRecords = {
    ["Heboric"] = 0,
    ["Panserbjørn"] = 0,
    ["Shmeeshmaam"] = 0,
    ["Troffer"] = 0,
}

function STLClassColor(charName)
    return STLClassColors[STLCharacters[charName]]
end

local critWindowTime = 0
local critWindowOwner = ""
local critWindowCount = 0
local recordWindowTime = 0
local deathWindowTime = 0
local deathWindowCount = 0
local spiderWindowTime = 0

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
                -- pass a variable number of arguments
                self:OnEvent(event, CombatLogGetCurrentEventInfo())
end)

function STLCritSound(charName, charClass, action)
    if STLSpecialCritAbility[charClass] == action then
        PlaySoundFile(STLSoundFolder .. "BubbRubbWooWoo.mp3", STLSoundChannel)
    else
        PlaySoundFile(STLCritSounds[charName], STLSoundChannel)
    end
end

function f:OnEvent(event, ...)
    --print(CombatLogGetCurrentEventInfo())
    local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
    local spellId, spellName, spellSchool, recapId, unconscious
    local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand
    local stlCharClass = STLCharacters[sourceName]

    if subevent == "SWING_DAMAGE" then
        amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "SPELL_DAMAGE" or subevent == "RANGE_DAMAGE" then
        spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, ...)
    elseif subevent == "SPELL_SUMMON" then
        spellId, spellName, spellSchool = select(12, ...)
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
    if stlCharClass then
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
            local MSG_MIND_CONTROL_EFFECT = "|c%s%s is taking someone's mind! Booweeeeoooo..."
            print(MSG_MIND_CONTROL_EFFECT:format(STLClassColor(sourceName), sourceName))
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
        if subevent == "SPELL_CAST_SUCCESS" and (spellName == "Intimidating Shout" or spellName == "Psychic Scream" or spellName == "Howl of Terror") then
            local MSG_AOE_FEAR = "|c%s%s cast %s!"
            print(MSG_AOE_FEAR:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "MarvSkeleton.mp3", STLSoundChannel)
            return
        end
        -- Dash
        --
        if subevent == "SPELL_CAST_SUCCESS" and (spellName == "Charge" or spellName == "Intercept") then
            local MSG_DASH = "|c%s%s cast %s!"
            print(MSG_DASH:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "ToejamDash.mp3", STLSoundChannel)
            return
        end
        -- Lay on Hands
        --
        if subevent == "SPELL_CAST_SUCCESS" and spellName == "Lay on Hands" then
            local MSG_LAY_ON_HANDS = "|c%s%s cast %s! POWER UP!"
            print(MSG_LAY_ON_HANDS:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "ZanPowerup.mp3", STLSoundChannel)
            return
        end
        -- Target Dummy
        --
        if subevent == "SPELL_CAST_SUCCESS" and spellName:sub(-12) == "Target Dummy" then
            local MSG_TARGET_DUMMY = "|c%s%s deploys %s! Magic Decoy!"
            print(MSG_TARGET_DUMMY:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "MagicDecoy.mp3", STLSoundChannel)
            return
        end
        -- Battle Shout
        --
        if subevent == "SPELL_CAST_SUCCESS" and spellName == "Battle Shout" then
            local MSG_BATTLE_SHOUT = "|c%s%s uses %s!"
            print(MSG_BATTLE_SHOUT:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "Braveheart.mp3", STLSoundChannel)
            return
        end
        -- Vampirism
        --
        if subevent == "SPELL_HEAL" and spellName == "Vampirism" then
            local MSG_VAMPIRISM = "|c%s%s cast %s!"
            print(MSG_VAMPIRISM:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "Vampirism.mp3", STLSoundChannel)
            return
        end
        -- Blackblade of Shahram
        --
        if subevent == "SPELL_SUMMON" and spellName == "Shahram" then
            local MSG_SHAHRAM = "|c%s%s summons %s!"
            print(MSG_SHAHRAM:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "RobotBartender.mp3", STLSoundChannel)
            return
        end
        -- Demonic Sacrifice
        --
        if subevent == "SPELL_CAST_SUCCESS" and spellName == "Demonic Sacrifice" then
            local MSG_DEMONIC_SACRIFICE = "|c%s%s cast %s!"
            print(MSG_DEMONIC_SACRIFICE:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "HeyGuys.mp3", STLSoundChannel)
            return
        end
        -- Mind Quickening Gem
        --
        if subevent == "SPELL_CAST_SUCCESS" and spellName == "Mind Quickening" then
            local MSG_MIND_QUICKENING = "|c%s%s cast %s!"
            print(MSG_MIND_QUICKENING:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "FeelSpeedy.mp3", STLSoundChannel)
            return
        end
        -- Warrior Ulti
        --
        if subevent == "SPELL_CAST_SUCCESS" and (spellName == "Recklessness" or spellName == "Retaliation" or spellName == "Shield Wall") then
            local MSG_RECKLESSNESS = "|c%s%s uses %s!"
            print(MSG_RECKLESSNESS:format(STLClassColor(sourceName), sourceName, spellName))
            PlaySoundFile(STLSoundFolder .. "BeatYouUp.mp3", STLSoundChannel)
            return
        end
    end

    --
    -- Buffs
    --
    if destName == GetUnitName("player") and subevent == "SPELL_CAST_SUCCESS" then
        if spellName == "Arcane Intellect" or spellName == "Arcane Brilliance" then
            PlaySoundFile(STLSoundFolder .. "Indubitably.mp3", STLSoundChannel)
            return
        end
        if spellName == "Power Word: Fortitude" or spellName == "Prayer of Fortitude" then
            PlaySoundFile(STLSoundFolder .. "NixonFeelGood.mp3", STLSoundChannel)
            return
        end
        if spellName == "Prayer of Spirit" then
            PlaySoundFile(STLSoundFolder .. "KennedySpirit.mp3", STLSoundChannel)
            return
        end
        if spellName == "Thorns" then
            PlaySoundFile(STLSoundFolder .. "Thorns.mp3", STLSoundChannel)
            return
        end
        if spellName == "Mark of the Wild" then
            PlaySoundFile(STLSoundFolder .. "WildThing.mp3", STLSoundChannel)
            return
        end
    end

    --
    -- Deaths
    --
    if recapId and STLDeathSounds[destName] then
        currentTime = time()
        if currentTime >= deathWindowTime then
            deathWindowCount = 1
            deathWindowTime = currentTime + 60
        else
            deathWindowCount = deathWindowCount + 1
        end
        if deathWindowCount >= 3 then
            deathWindowTime = 0
            PlaySoundFile(STLSoundFolder .. "Apollo13Medical.mp3", STLSoundChannel)
        else
            PlaySoundFile(STLDeathSounds[destName], STLSoundChannel)
        end
        return
    end

    --
    -- Healing
    --
    if critical and subevent == "SPELL_HEAL" and STLHealSounds[sourceName] and STLCharacters[destName] then
        local action = spellName
        -- local MSG_CRITICAL_HIT = "|c%s%s's %s critically healed %s for %d health!"
        -- print(MSG_CRITICAL_HIT:format(STLClassColor(sourceName), sourceName, action, destName, amount))

        if amount > STLHealRecords[sourceName] then
            STLHealRecords[sourceName] = amount
            PlaySoundFile(STLSoundFolder .. "DamnSon.mp3", STLSoundChannel)
        else
            PlaySoundFile(STLHealSounds[sourceName], STLSoundChannel)
        end
        return
    end

    --
    -- Spider Melee Hits
    --
    if subevent == "SWING_DAMAGE" and STLCharacters[destName] and UnitCreatureFamily(destName .. "-target") == "Spider" then
        currentTime = time()
        if currentTime >= spiderWindowTime then
            spiderWindowTime = currentTime + 180
            local MSG_SPIDER_HIT = "|c%s%s hit by %s for %d damage! A Tarantula!"
            print(MSG_SPIDER_HIT:format(STLClassColor(destName), destName, sourceName, amount))
            PlaySoundFile(STLSoundFolder .. "Tarantula.mp3", STLSoundChannel)
        end
        return
    end

    --
    -- Critical Hits
    --
    if critical and stlCharClass then
        local action = spellName or MELEE
        -- local MSG_CRITICAL_HIT = "|c%s%s's %s critically hit %s for %d damage!"
        -- print(MSG_CRITICAL_HIT:format(STLClassColor(sourceName), sourceName, action, destName, amount))

        -- Critical record, always sound
        if amount > STLCritRecords[sourceName] then
            STLCritRecords[sourceName] = amount
            currentTime = time()
            if not IsInGroup() or currentTime > recordWindowTime then
                recordWindowTime = currentTime + 5
                PlaySoundFile(STLSoundFolder .. "DamnSon.mp3", STLSoundChannel)
            end
            return
        end
        -- Solo play, always sound
        if not IsInGroup() then
            STLCritSound(sourceName, stlCharClass, action)
            return
        end
        -- Group play, use a time window
        currentTime = time()
        if currentTime >= critWindowTime then
            critWindowTime = currentTime + 4 + random(3)

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
                STLCritSound(sourceName, stlCharClass, action)
            end
        end
    end
end
