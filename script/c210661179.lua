--Cosmic Cyclone
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,nil,3,3,s.spcheck)
	--Add 1 card in your GY to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--untargetable and cannot be destroyed by card effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.immval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(s.immval)
    c:RegisterEffect(e3)
	--immune when link summoned using level 7 or above
		--Gain Effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(s.matcheck)
	c:RegisterEffect(e4)
	--attack all special summoned once each
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(s.atkfilter)
	c:RegisterEffect(e5)
	--Cannot attack directly
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
	--gain 1500 attack when destroying
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCountLimit(1,id)
	e7:SetCondition(aux.bdocon)
	e7:SetOperation(s.atkop)
	c:RegisterEffect(e7)
end
--Diffrenet name Same attribute
function s.spcheck(g,lc,sumtype,tp)
	return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp) and g:CheckSameProperty(Card.GetAttribute,lc,sumtype,tp)
end
--e1
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--e2
function s.imcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetLinkedGroup():FilterCount(Card.IsMonster,nil)==0
end
function s.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated() and s.imcon(e) --condition handling for mid-resolution updating
end
--e3
function s.filter(c)
	return c:IsMonster() and c:IsLevelAbove(7)
end
function s.matcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(s.filter,1,nil) then
		--Immune to Your opponent card effects.
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.efilter)
		c:RegisterEffect(e1)
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--e4
function s.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
--e6
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--It gains 1500 ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end