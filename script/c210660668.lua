--Cat Tengu
--Scripted by Gideon
-- (1) While face-up on the field, this card is also FIRE-Attribute.
-- (2) Before damage calulation: If this card battles a monster that doesn't share the same Attribute of this card; return that monster to the hand.
-- (3) You can Tribute this card; Add 1 "Dynamites" Banner monster from your deck to your hand but for the rest of this turn, you cannot Normal Summon/Set or Special Summon monsters with that name, nor activate their monster effects. You can only use this effect of "Cat Tengu" once per turn.
-- (4) You cannot activate this effect the turn this card was sent to the GY. While this card is in the GY: You can banish this card from your GY and Target 1 monster your opponent controls; it loses 1000 ATK.
local s,id=GetID()
function s.initial_effect(c)
	--Also treated as a FIRE monster on the field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e1)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(s.retcon)
	e2:SetTarget(s.rettg)
	e2:SetOperation(s.retop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.tcost)
	e3:SetTarget(s.ttarget)
	e3:SetOperation(s.toperation)
	c:RegisterEffect(e3)
	--activate effect from graveyard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(s.atkgcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.atktarget)
	e4:SetOperation(s.atkactivate)
	c:RegisterEffect(e4)
end
--E2
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local t=c:GetBattleTarget()
	e:SetLabelObject(t)
	return t and t:IsRelateToBattle() and not t:IsAttribute(c:GetAttribute())
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local t=c:GetBattleTarget()
    if chk==0 then return t and t:IsRelateToBattle() and not t:IsAttribute(c:GetAttribute()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,t,1,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	if t and t:IsRelateToBattle() then
		Duel.SendtoHand(t, nil, REASON_EFFECT)
	end
end
--e3
function s.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c)
    return c:IsAbleToHand() and c:IsCode(210660455) or c:IsCode(210660519) or c:IsCode(210660059) or c:IsCode(210660042) or c:IsCode(210660044) or c:IsCode(210660057) or c:IsCode(210660668) or c:IsCode(210660043) or c:IsCode(210660617) or c:IsCode(210660427) or c:IsCode(210660143)
end
function s.ttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.toperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.sumlimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetValue(s.aclimit)
		Duel.RegisterEffect(e4,tp)
	end
end
function s.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
--e4
function s.atkfilter(c)
	return c:IsFaceup() and c:IsMonster()
end
function s.atkgcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function s.atktarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.atkactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) then
	local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			tc:RegisterEffect(e1)
	end
end
