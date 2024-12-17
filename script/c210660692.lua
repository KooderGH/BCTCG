--Issun Boshi
--Scripted by Konstak, fix by Gideon
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) This card can attack directly.
-- (3) If you control 3 or more WIND monsters, this card cannot be targeted for attacks.
-- (4) You can only use 1 of these effects of "Issun Boshi" per turn, and only once that turn.
-- * When this card deals battle damage; Draw 1 card.
-- * If this card is sent to the GY while your opponent controls more cards than the combined number of cards in your hand and that you control; Draw cards equal to their surplus. You cannot activate this effect if you control a non WIND monster.
-- (5) You can only control 1 Issun Boshi
local s,id=GetID()
function s.initial_effect(c)
    --self destroy (1)
    c:SetUniqueOnField(1,0,id)
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
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCountLimit(1,id)
    e4:SetCondition(s.bdcon)
    e4:SetOperation(s.bdop)
    c:RegisterEffect(e4)
    --once sent to the graveyard
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1,id)
    e5:SetCondition(s.drcon)
    e5:SetTarget(s.drtg)
    e5:SetOperation(s.drop)
    c:RegisterEffect(e5)
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
--Draw once sent to GY function
function s.ndrfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local ot=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
    if not Duel.IsExistingMatchingCard(s.ndrfilter,tp,LOCATION_MZONE,0,1,nil) then return t>ot end
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local ot=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,t-ot) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(t-ot)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,t-ot)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local t=Duel.GetFieldGroupCount(p,0,LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(p,LOCATION_HAND+LOCATION_ONFIELD,0)
	if t>s then
		Duel.Draw(p,t-s,REASON_EFFECT)
	end
end