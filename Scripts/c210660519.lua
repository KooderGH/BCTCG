--Lasvoss
--Scripted by Gideon and Naim
--Special thanks to the edopro team for helping me re-learn battle triggers
-- You can banish this card from your hand; Draw 1 card. You can only activate this effect of "Lasvoss" once per turn.
-- You can Special Summon this card (from your hand) by banishing 2 cards from your hand and/or field.
-- When this card attacks; flip a coin. If heads, this card gains 2000 ATK until the end phase.
-- Once while this card is face-up on the field: if it would be destroyed; gain 1000 ATK instead.
local s,id=GetID()
function s.initial_effect(c)
--Banish self draw card
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,1))
e1:SetCategory(CATEGORY_DRAW)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetType(EFFECT_TYPE_IGNITION)
e1:SetRange(LOCATION_HAND)
e1:SetCost(aux.selfbanishcost)
e1:SetOperation(s.tdop)
e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
c:RegisterEffect(e1)
--Special Summon by banishing 2 other cards from the hand or field
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD)
e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
e2:SetCode(EFFECT_SPSUMMON_PROC)
e2:SetRange(LOCATION_HAND)
e2:SetCondition(s.spcon)
e2:SetTarget(s.sptg)
e2:SetOperation(s.spop)
c:RegisterEffect(e2)
--attack up
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,0))
e3:SetCategory(CATEGORY_ATKCHANGE)
e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e3:SetCode(EVENT_ATTACK_ANNOUNCE)
e3:SetCondition(s.condition)
e3:SetOperation(s.operation)
c:RegisterEffect(e3)
--Destruction replacement
local e4=Effect.CreateEffect(c)
e4:SetCode(EFFECT_DESTROY_REPLACE)
e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
e4:SetRange(LOCATION_MZONE)
e4:SetCountLimit(1)
e4:SetTarget(s.desreptg)
c:RegisterEffect(e4)
end
--E1 Part
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
	end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end

--E2 Part
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD|LOCATION_HAND,0,e:GetHandler())
	return #rg>=2 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD|LOCATION_HAND,0,e:GetHandler())
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--E3 part
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.TossCoin(tp,1)==COIN_HEADS then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

--E4 Part
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
	c:RegisterEffect(e1)
	return true
end