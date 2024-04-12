--Megidora
--Scripted by Konstak
--Effect
--(1) Any monster that is Normal Summoned, Flip Summoned, or Special Summoned is changed to Defense Position except Dragon type monsters.
--(2) Once per turn (Igntion): You can target one monster on your side of the field except "Megidora" and one monster on your opponent side; Destroy both targets.
--(3) When this card is in Defense Position; destroy it.
--(4) When this card is destroyed by a card effect: You can target 1 Dragon monster in your GY except "Megidora"; Special Summon it.
--(5) When this card is destroyed by battle: You can target 1 monster you control; It gains 500 ATK.
--(6) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.(6)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e6:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e6)
end