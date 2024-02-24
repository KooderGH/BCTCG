--Shitakiri Sparrow
--Scripted by Konstak
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) When a Spell card is activated; Add 1 Spell Counter(s) to this card.
-- (3) You can only use 1 of these effects of "Shitakiri Sparrow" per turn, and only once that turn.
-- * You can remove 2 Spell Counter(s) from this card to add 1 WIND monster from your Deck or GY to your hand.
-- * If this card is sent to the GY; For every 2 WIND monsters you control, add 1 Spell card from your GY to your hand.
local s,id=GetID()
function s.initial_effect(c)
    --self destroy (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    e1:SetCondition(s.sdcon)
    c:RegisterEffect(e1)


end
--Self Destroy Function
function s.sdfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.sdcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end