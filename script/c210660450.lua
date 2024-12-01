--High Lord Babel
--Scripted by Gideon
--Effect
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card's Summon cannot be negated. If a monster(s) you control is destroyed by an card effect: You can pay half your LP; Special Summon this card from your hand or GY into Defense Position. Then move this card to your Extra Monster Zone. Neither player can activate cards or effects in response to this card effect.
-- (2) Cannot be returned to hand or banished.
-- (3) Cannot be targeted by card effects.
-- (4) This card cannot move to attack position. (If a effect would move it, it would switch to defense position instead)
-- (5) Unaffected by effects other than its own
-- (6) Each time card(s) on your side of the field are destroyed by card effect(s): Place one Castle Counter on this card.
-- (7) When this card has 10 Castle Counters, you win the duel.
-- (8) During each end phase: Gain 1000 LP for each Dragon monster you control.
-- (9) While you have no cards in your hand: You cannot lose the duel by any means.
-- (10) Once per turn (Ignition): You can add 1 FIRE Dragon monster from your deck to your hand. 
-- (11) You can only control 1 "High Lord Babel".
local s,id=GetID()
function s.initial_effect(c)
    --(1)Start
    --Makes it unsummonable via normal
    c:EnableUnsummonable()
    --Cannot be SS by other ways other then it's own effect via above and this function
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.FALSE)
    c:RegisterEffect(e0)
    --SS on destroyed effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Move to EMZ
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(s.mvop)
    c:RegisterEffect(e2)
    --Summon cannot be disabled (Hopefully)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
    --(1)Finish
    --(2)Start
    --Cannot be returned to hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Cannot banish
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e5)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --(3)Finish
    --(4)Start
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_SET_POSITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(POS_FACEUP_DEFENSE)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e7)
    --(4)Finish
    --(5)Start
    --Unaffected by effects other than its own.
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_IMMUNE_EFFECT)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(s.efilter)
    c:RegisterEffect(e8)
    --(5)Finish
    --(6)Start
    --When card(s) on destroyed by card effect(s) Place Castle Counter
    c:EnableCounterPermit(0x4000)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e9:SetProperty(EFFECT_FLAG_DELAY)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EVENT_DESTROYED)
    e9:SetCondition(s.ctcon)
    e9:SetOperation(s.ctop)
    c:RegisterEffect(e9)
    --(6)Finish
    --(7)Start
    --Win con
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e10:SetProperty(EFFECT_FLAG_DELAY)
    e10:SetCode(EVENT_ADJUST)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCondition(s.wincon)
    e10:SetOperation(s.winop)
    c:RegisterEffect(e10)
    --(7)Finish
    --(8)Start
    --Heal 1000 for each dragon controlled
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(id,1))
    e11:SetCategory(CATEGORY_RECOVER)
    e11:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e11:SetCode(EVENT_PHASE+PHASE_END)
    e11:SetRange(LOCATION_MZONE)
    e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e11:SetCountLimit(1)
    e11:SetTarget(s.rectg)
    e11:SetOperation(s.recop)
    c:RegisterEffect(e11)
    --(8)Finish
    --(9)Start
    --Cannot lose if 0 cards in hand
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_CANNOT_LOSE_DECK)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(1,0)
    e12:SetCondition(s.losecon)
    c:RegisterEffect(e12)
    local e13=e12:Clone()
    e13:SetCode(EFFECT_CANNOT_LOSE_LP)
    c:RegisterEffect(e13)
    local e14=e12:Clone()
    e14:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
    c:RegisterEffect(e14)
    --(9)Finish
    --(10)Start
    c:SetUniqueOnField(1,0,id)
    --(10)Finish
    --(11)Start
    local e15=Effect.CreateEffect(c)
    e15:SetDescription(aux.Stringid(id,2))
    e15:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e15:SetType(EFFECT_TYPE_IGNITION)
    e15:SetRange(LOCATION_MZONE)
    e15:SetCountLimit(1)
    e15:SetTarget(s.searchdrgtarget)
    e15:SetOperation(s.searchdrgopp)
    c:RegisterEffect(e15)
end
--(1)
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsReason(REASON_EFFECT)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1))end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
		c:CompleteProcedure()
	end
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local lftezm=Duel.CheckLocation(tp,LOCATION_EMZONE,0) and 0x20 or 0
    local rgtemz=Duel.CheckLocation(tp,LOCATION_EMZONE,1) and 0x40 or 0
    if (lftezm>0 or rgtemz>0) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--(5)
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--(6)
s.counter_list={0x4000}
function s.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ctfilter,1,nil,tp)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4000,1)
end
--(7)
function s.wincon(e)
	return e:GetHandler():GetCounter(0x4000)>=10
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x62)
end
--(8)
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsRace,RACE_DRAGON),tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1000)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsRace,RACE_DRAGON),tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*1000,REASON_EFFECT)
end
--(9)
function s.losecon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
--(11)
function s.dragonfiltersearch(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function s.searchdrgtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.dragonfiltersearch,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.searchdrgopp(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.dragonfiltersearch,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end