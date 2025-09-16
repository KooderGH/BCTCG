--The 10th Angel
--Scripted by Gideon 2, 3. & 1 by poka-poka 
-- (1) You can Special Summon this card by discarding the top 3 cards in your deck
-- (2) During either players turn(Quick): You can Discard the top card in your deck and target one card on the field; Destroy that target. You can only activiate this effect of "The 10th Angel" once per turn.
-- (3) Your opponent must discard the top 2 card in their deck to Normal Summon or Special Summon a monster.
--special summon
local s,id=GetID()
function s.initial_effect(c)
	--send to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.tdcost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--Discard 2 card to normal or Special
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_ALL)
	e2:SetCost(s.costchk)
	e2:SetOperation(s.costop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e3)
	--(1)send 3 top deck to gy for sp summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1)
	e4:SetCondition(s.spcon)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
--e2
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--e3
function s.costchk(e,c,tp)
	return Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.DiscardDeck(tp,2,REASON_COST)
end
--(1)
function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDiscardDeck(tp,3)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.DiscardDeck(tp,3,REASON_COST)
end