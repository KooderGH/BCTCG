--Hades The Punisher
--Scripted by Konstak
--Effect
-- (1) Can Be Set without Tribute.
-- (2) When a Card is activated that targets this face-down card (Quick Effect): Change this card to face-up Defense Position, and if you do, negate the activation and if you do, banish it.
-- (3) After damage caluation involving this card: You can target 1 monster in your GY; add it to your hand.
-- (4) When this card is Tributed: Special Summon 1 Monster from your Deck and make it's ATK and DEF 0.
-- (5) When this card is destroyed; You can Special Summon this card in Defense Position during the End Phase. 
local s,id=GetID()
function s.initial_effect(c)
    --Can Be Set without Tribute. (1) 
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    c:RegisterEffect(e1)
end