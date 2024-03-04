--Wolfchild Deale
--Scripted by Gideon
-- (1) Cannot be attacked.
-- (2) During either turn, except the End Phase: You can discard this card from your hand; apply this effect this turn. You can only use this effect of "Wolfchild Deale" once per turn.
-- * Each time your opponent Special Summons an Effect Monster(s) during the Main Phase or Battle Phase, you gain LP equal to that monster's ATK. If you did not gain LP by this effect, your LP are halved during the End Phase.
-- (3) You can Tribute this face-up card on the field; Each player draws 1 card, and neither player takes damage until the end of the opponent's next turn.
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be attacked (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --recover (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.condition)
    e2:SetCost(s.cost)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
    --Tribute, one day (3)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(s.tcost)
    e3:SetTarget(s.ttarget)
    e3:SetOperation(s.toperation)
    c:RegisterEffect(e3)
end
--(1) Effect
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase() < PHASE_END
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetCountLimit(1,{id,1})
	e0:SetCondition(s.damcon)
	e0:SetOperation(s.damop)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetLabelObject(e0)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.reccon1)
	e1:SetOperation(s.recop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(s.reccon2)
	e3:SetOperation(s.recop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	e2:SetLabelObject(e3)
end
function s.filter(c,sp)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()==sp
	else
		return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&TYPE_EFFECT ~= 0 and c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonPlayer()==sp
	end
end
function s.reccon1(e,tp,eg,ep,ev,re,r,rp)
	local ph = Duel.GetCurrentPhase()
	return eg:IsExists(s.filter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
		and ph >= PHASE_MAIN1 and ph <= PHASE_MAIN2
end
function s.sum(c)
	if c:IsLocation(LOCATION_MZONE) then
		return c:GetAttack()
	else
		return c:GetPreviousAttackOnField()
	end
end
function s.recop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,1-tp)
	if #g>0 then
		local sum=g:GetSum(s.sum)
		Duel.Hint(HINT_CARD,0,id)
		if Duel.Recover(tp,sum,REASON_EFFECT)~=0 then 
			Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ph = Duel.GetCurrentPhase()
	return eg:IsExists(s.filter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
		and ph >= PHASE_MAIN1 and ph <= PHASE_MAIN2
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,1-tp)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	e:GetLabelObject():SetLabel(g:GetSum(s.sum)+e:GetLabelObject():GetLabel())
end
function s.reccon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0 
end
function s.recop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,id)
	local rec=e:GetLabel()
	e:SetLabel(0)
	Duel.Hint(HINT_CARD,0,id)
	if Duel.Recover(tp,rec,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+1)==0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp/2)
end
--(2) Effect
function s.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.ttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.toperation(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.Draw(tp,1,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if d1==0 or d2==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetTargetRange(1,1)
	Duel.RegisterEffect(e3,tp)
end
