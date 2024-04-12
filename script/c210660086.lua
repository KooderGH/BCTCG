--Kamukura
--Scripted by Konstak
--Effect
--(1) If you control a Dragon monster on the field: You can Normal Summon this card without tributing.
--(2) If you Tribute Summon this card; You can return all card's your opponent controls.
--(3) This card cannot be destroyed by card effect's while on the field.
--(4) Each time monster(s) are destroyed by a card effect; This card gain's a Counter (max 6).
--(5) If this card has 3 counter(s) on it, this card can no longer attack. 
--(6) You can remove 3 counter(s) from this card and Target one Dragon monster from your GY; Special Summon it.
--(7) If this card is destroyed by a card effect: You can Target up to 2 Dragon monster's in your GY: Special Summon those target's.
--(8) When this card is destroyed by battle: You can Target 1 monster in your opponent's GY; Special Summon it to your side of the field.
--(9) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.(9)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e9:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e9)
end