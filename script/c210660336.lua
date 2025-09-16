--By Tungnon E1 & poka-poka E2,3,4,5
--Queen Reika
local s,id=GetID()
function s.initial_effect(c)
	--When Opponents SS, SS this card then Flip Opponents SSed monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.getflippedcon)
	e1:SetTarget(s.getflippedtg)
	e1:SetOperation(s.getflippedop)
	c:RegisterEffect(e1)
	-- Effect damage would heal the same amount instead
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_REVERSE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(s.rev)
	c:RegisterEffect(e2)
    -- Quick : if opponents targets spell/trap cards, Negate and destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.qcon)
    e3:SetCost(s.qcost)
    e3:SetTarget(s.qtg)
    e3:SetOperation(s.qop)
    c:RegisterEffect(e3)
	-- Special Summon if destroyed by card effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
	-- Special Summon if Tributed then draw a card
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_RELEASE)
	e5:SetCountLimit(1,{id,2})
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
--E1
function s.getflippedcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetCount()==1 and eg:GetFirst():IsControler(1-tp)
end
function s.getflippedtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=eg:GetFirst()
    if chk==0 then return tc and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() end
    Duel.SetTargetCard(tc)
end
function s.getflippedop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) ~= 0 then
        if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
            Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
        end
    end
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if eg:IsContains(tc) and tc:GetFlagEffectLabel(id)==e:GetLabel() then
		local p=tc:GetPreviousControler()
		if Duel.Damage(p,tc:GetBaseAttack(),REASON_EFFECT)>0 then
			Duel.Hint(HINT_CARD,0,id)
		end
		tc:ResetFlagEffect(id)
		e:Reset()
	end
end
--E2
function s.rev(e,re,r,rp,rc)
	return (r&REASON_EFFECT)>0
end
--E3
function s.qfilter(c)
    return c:IsOnField() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
-- Check if opponent's effect targets a Spell/Trap card for destruction
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
    if e==re or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
    local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
    return ex and tg~=nil and tg:IsExists(s.qfilter,1,nil)
end
-- Discard 1 card
function s.qcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
-- Negate the activation and destroy
function s.qtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function s.qop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
--E4 & E5
-- Condition for Effect 4
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
-- Special Summon
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
    end
end