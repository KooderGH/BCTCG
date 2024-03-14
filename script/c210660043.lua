--Cat Machine
--Scripted by Konstak
--Effect:
-- (1) When summoned, place in defense. 
-- (2) Twice per turn; cannot be destroyed. 
-- (3) Cannot be targeted for attacks by Warrior monsters.
-- (4) Cannot be returned to hand.
-- (5) Cannot be tributed.
-- (6) During your opponent's end phase, you can banish this face-up card on the field; You can search and add one monster from your deck to your hand. Skip your next draw phase when you use this effect.
local s,id=GetID()
function s.initial_effect(c)
    --to defense (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.deftg)
    e1:SetOperation(s.defop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --Cannot be destroyed twice per turn (2)
    local e4=Effect.CreateEffect(c)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(2)
    e4:SetTarget(s.destg)
    c:RegisterEffect(e4)
    --Cannot be targeted for attacks by Warrior monsters (3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e5:SetValue(s.atkcon)
    c:RegisterEffect(e5)
    --Cannot be Tributed (4)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_UNRELEASABLE_SUM)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e7)
    --Cannot be returned to hand (5)
    local e8=e6:Clone()
    e8:SetCode(EFFECT_CANNOT_TO_HAND)
    c:RegisterEffect(e8)
    --During your opponent's end phase, you can banish this face-up card on the field (6)
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,1))
    e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EVENT_PHASE+PHASE_END)
    e9:SetCountLimit(1)
    e9:SetCondition(s.bancon)
    e9:SetCost(aux.selfbanishcost)
    e9:SetOperation(s.banop)
    c:RegisterEffect(e9)
end
--(1)
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
--(2)
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) end
    return true
end
--(3)
function s.atkcon(e,c)
    return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
--(4)
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