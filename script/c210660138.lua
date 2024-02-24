--Princess Kaguya
--Scripted by Konstak
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) If your opponent controls 2 or more monsters while you control a WIND Attribute monster, you can Special Summon this card from your hand.
-- (3) You can only use 1 of these effects of "Princess Kaguya" per turn, and only once that turn.
-- * When this card is Summoned; Your Opponent Skips their next Battle Phase. You cannot activate this effect if your opponent has no monsters OR controls at least 1 WIND monser.
-- * If this card is sent to the GY: Target 1 monster on your opponent side of the field; It cannot attack while it's face-up on the field.
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