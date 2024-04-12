--Hevijak the Wicked
--Scripted by Konstak
--Effect
--(1) If you control no monsters while your opponent controls a monster: You can Special Summon this card from your hand.
--(2) When this card is Tribute Summoned; Destroy all monsters in Defense Position.
--(3) When this card is Special Summoned; Add one Dragon monster from your deck to your hand.
--(4) Once while this card is on the field (Quick): You can target 1 card your opponent controls and one card you control; Destroy those target's
--(5) When this card is destroyed by a card effect: You can Target one Spell or Trap in your GY; Add it to your hand. You can only use this effect of "Hevijak the Wicked" once per duel.
--(6) When this card is destroyed by battle; You can Special Summon one Dragon monster from your hand.
--(7) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.(7)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e7:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e7)
end