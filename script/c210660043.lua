--Cat Machine
--Scripted by Konstak
--Effect:
-- (1) Twice per turn; cannot be destroyed. 
-- (2) Cannot be targeted for attacks by Warrior monsters.
-- (3) Cannot be returned to hand.
-- (4) Cannot be tributed.
-- (5) During your opponent's end phase, you can banish this face-up card on the field; You can search and add one monster from your deck to your hand. Skip your next draw phase when you use this effect.
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be destroyed twice per turn (1)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
    e1:SetTarget(s.destg)
    c:RegisterEffect(e1)
    --Cannot be targeted for attacks by Warrior monsters (2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetValue(s.atkcon)
	c:RegisterEffect(e2)
	--Cannot be Tributed (4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	--Cannot be returned to hand (3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e5)
	--During your opponent's end phase, you can banish this face-up card on the field (5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
    e6:SetCondition(s.bancon)
    e6:SetCost(aux.selfbanishcost)
	e6:SetOperation(s.banop)
	c:RegisterEffect(e6)
end
--(1)
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) end
	return true
end
--(2)
function s.atkcon(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
--(5)
function s.bancon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.monfilter(c)
	return c:IsMonster() and c:IsAbleToHand()
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.monfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_SKIP_DP)
        e1:SetTargetRange(1,0)
        if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
            e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
        end
        Duel.RegisterEffect(e1,tp)
	end
end