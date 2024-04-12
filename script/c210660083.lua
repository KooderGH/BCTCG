--Sodom
--Scripted by Konstak
--Effect
--(1) Can be Normal Summoned without tribute.
--(2) If this card is Tribute Summoned: You can Target 1 card your opponent controls; Shuffle that card into their deck.
--(3) At the start of the Damage Step, if this card battles an opponent's monster: You can return your opponent's monster to their hand.
--(4) If a Spell or Trap is destroyed while this card is face-up on the field; You can add 1 Dragon type monster from your GY to your hand. You can only use this effect of "Sodom" once per turn.
--(5) If this card is destroyed by a card effect; You can add 1 Dragon type from your deck to your hand.
--(6) When this card is destroyed by battle: You can target 1 card you control; Return that card to your hand.
--(7) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --Can Be Normal Summoned without Tribute. (1) 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    c:RegisterEffect(e1)
    --Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.(7)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e7:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e7)
end