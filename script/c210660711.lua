--Betrothed Balaluga
--Scripted By poka-poka
local s,id=GetID()
function s.initial_effect(c)
	-- Effect 1 : Special summon If you control a Fiend monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	-- Effect 2 : Monsters with 1500 or more ATK cannot declare an attack except Fiend Monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.atktarget)
	c:RegisterEffect(e2)
	-- Effect 3 : Add 2000 more LP when opponent gains LP
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_RECOVER)
    e3:SetRange(LOCATION_MZONE) 
    e3:SetCondition(s.lpcon)
    e3:SetOperation(s.lpop)
    c:RegisterEffect(e3)
	-- Effect 4 : Opponent must pay 2000 LP per Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCost(s.costchk)
	e4:SetOperation(s.costop)
	c:RegisterEffect(e4)
	-- Effect 5 : Add DARK fiend from Deck when destroyed by battle
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCondition(s.battlecon)
    e5:SetTarget(s.battletg)
    e5:SetOperation(s.battleop)
    c:RegisterEffect(e5)
end
--e1
--SP summon
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	-- Banish when leaving the field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
end
--e2
-- Filter >1500 ATK and not Fiend
function s.atktarget(e,c)
	return c:GetAttack()>=1500 and not c:IsRace(RACE_FIEND)
end
--e3
--Unlimited LP Glitch doesnt exist
s.rcvlp_flag=false
-- Opponents Gain LP and is not caused by this card (or its copies)
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return ep~=tp and ev>0 and not rc:IsCode(id) and not s.rcvlp_flag
end
-- Add 2000 more LP to the opponent
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    s.rcvlp_flag=true
    Duel.Recover(1-tp,2000,REASON_EFFECT)
    s.rcvlp_flag=false
end
--e4
-- Opponent must pay 2000 LP for each Special Summon
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetPlayerEffect(tp,id)
	return Duel.CheckLPCost(tp,2000)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.PayLPCost(tp,2000)
end
--e5
-- Add DARK fiend  from Deck when destroyed by battle condition
function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE)
end
-- Add DARK fiend  from Deck target
function s.battletg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.battlefilter,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
-- Add DARK fiend  from Deck operation
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp,s.battlefilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g > 0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- Filter for DARK fiend monsters in the Deck
function s.battlefilter(c)
    return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end