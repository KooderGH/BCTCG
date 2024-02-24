--Issun Boshi
--Scripted by Konstak
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) This card can attack directly.
-- (3) If you control 3 or more WIND monsters, this card cannot be targeted for attacks.
-- (4) You can only use 1 of these effects of "Issun Boshi" per turn, and only once that turn.
-- * When this card deals battle damage; Draw 1 card.
-- * If this card is sent to the GY while your opponent controls more cards than the combined number of cards in your hand and that you control; Draw cards equal to their surplus. You cannot activate this effect if you control a non WIND monster.
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
    --Can attack directly
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e2)
    --Cannot be battle target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetCondition(s.btcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --battle damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DAMAGE)
    e4:SetCondition(s.bdcon)
    e4:SetOperation(s.bdop)
    c:RegisterEffect(e4)
end
--Self Destroy Function
function s.sdfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.sdcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--Cannot be battle target
function s.btfilter(c)
    return c:IsMonster() and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.btcon(e)
    return Duel.IsExistingMatchingCard(s.btfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
--Battle damage function
function s.bdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.bdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end