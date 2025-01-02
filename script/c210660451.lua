--Ushiwakamaru
--Scripted by Konstak
--Effect
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. You can Special Summon this card from your hand or GY by controling 3 or more WIND type monsters, Then, move this card to your Extra Monster Zone. You can only activate this effect once per duel.
-- (2) Cannot be returned to hand, banished, or tributed.
-- (3) Cannot be targeted by card effects.
-- (4) (Ignition) You can remove 1 Quaking Hammer Counter;SS one WIND monster from your GY.
-- (5) You can Target 1 card on your field (Ignition); Destroy that target. You can only activate this effect once per turn.
-- (6) This card gains 500 DEF for each WIND monster in your GY.
-- (7) Each time a WIND monster is sent to the GY; Add 1 Quaking Hammer Counter(s) to this card.
-- (8) (Ignition) You can remove 3 Quaking Hammer Counter; Swap this card's current DEF to it's ATK until your next standby phase. 
-- (9) If this card would be destroyed, you can remove 4 Quaking Hammer Counters from this card instead.
-- (10) You can remove 7 Quaking Hammer Counter(s) from this card (Ignition); Banish all cards on your opponent's side of the field. Your opponent cannot activate cards or effects in response to this effect. Your opponent cannot Normal Summon/Set next turn.
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
    --SS from Hand / GY
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e1:SetCondition(s.ssummoncon)
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
    --Cannot be Tributed
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUM)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e5)
    --Cannot be returned to hand
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_TO_HAND)
    c:RegisterEffect(e6)
    --Cannot banish
    local e7=e4:Clone()
    e7:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e7)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(1)
    c:RegisterEffect(e8)
    --(3)Finish
    --(4)Start
	-- Remove 1 counter to Special Summon a Wind monster from GY
    local e16=Effect.CreateEffect(c)
    e16:SetDescription(aux.Stringid(id,0))
    e16:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e16:SetType(EFFECT_TYPE_IGNITION)
    e16:SetRange(LOCATION_MZONE)
	e16:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e16:SetCountLimit(1)
    e16:SetCost(s.spcost)
    e16:SetTarget(s.sptg)
    e16:SetOperation(s.spop)
    c:RegisterEffect(e16)
    --(4)Finish
    --(5)Start
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,1))
    e10:SetCategory(CATEGORY_DESTROY)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCountLimit(1)
    e10:SetTarget(s.destg)
    e10:SetOperation(s.desop)
    c:RegisterEffect(e10)
    --(5)Finish
    --(6)Start
	-- 500 defense for each wind monster in GY
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_EMZONE)
    e11:SetCode(EFFECT_UPDATE_DEFENSE)
    e11:SetValue(s.defval)
    c:RegisterEffect(e11)
    --(6)Finish
    --(7)Start
    --When card(s) on destroyed Place Quaking Hammer Counter
    c:EnableCounterPermit(0x4002)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetProperty(EFFECT_FLAG_DELAY)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCode(EVENT_TO_GRAVE)
    e12:SetCondition(s.ctcon)
    e12:SetOperation(s.ctop)
    c:RegisterEffect(e12)
    --(7)Finish
    --(8)Start
    --remove 7 counter, Banish all card your opponents control
    local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(id,2))
    e13:SetCategory(CATEGORY_REMOVE)
    e13:SetType(EFFECT_TYPE_IGNITION)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCountLimit(1,id)
    e13:SetCost(s.rmcost)
    e13:SetTarget(s.rmtg)
    e13:SetOperation(s.rmop)
    c:RegisterEffect(e13)
    --(8)Finish
	--Cannot enter the Battle Phase the turn it is Special Summoned
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_SPSUMMON_SUCCESS)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCondition(s.nbpcon)
	e14:SetOperation(s.nbpop)
	c:RegisterEffect(e14)
	-- Swap DEF and ATK by removing 3 Quaking Hammer Counters
	local e17=Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(id,3))
	e17:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCountLimit(1)
	e17:SetCost(s.swapcost)
	e17:SetOperation(s.swapop)
	c:RegisterEffect(e17)
	--destroy replace
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e18:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e18:SetCode(EFFECT_DESTROY_REPLACE)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTarget(s.reptg)
	e18:SetOperation(s.repop)
	c:RegisterEffect(e18)
end
--(1) functions
function s.Windfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(s.Windfilter,tp,LOCATION_MZONE,0,nil)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1))
        and Duel.IsExistingMatchingCard(s.Windfilter,tp,LOCATION_MZONE,0,3,nil)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local lftezm=Duel.CheckLocation(tp,LOCATION_EMZONE,0) and 0x20 or 0
    local rgtemz=Duel.CheckLocation(tp,LOCATION_EMZONE,1) and 0x40 or 0
    if (lftezm>0 or rgtemz>0) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--SS from GY (4)
-- Remove 1 counter to Special Summon a Wind monster from GY
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetCounter(0x4002)>=1 end
    e:GetHandler():RemoveCounter(tp,0x4002,1,REASON_COST)
end
function s.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g > 0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--Destroy 1 Monster you control (5)
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--DEF gain (6)
function s.defval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_WIND)*500
end
-- Quaking Hammer (7)
s.counter_list={0x4002}
function s.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD|LOCATION_DECK|LOCATION_HAND) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsPreviousControler(tp)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ctfilter,1,nil,tp)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4002,1)
end
--Banish all cards your opponent controls (8)
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x4002,7,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x4002,7,REASON_COST)
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    e1:SetCondition(s.efcon)
    e1:SetLabel(Duel.GetTurnCount())
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_MSET)
    Duel.RegisterEffect(e2,tp)
end
function s.efcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end
-- Cannot BP
function s.nbpcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsContains(e:GetHandler()) and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.nbpop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE|PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
-- Remove 3 Quaking Hammer Counters, Swap DEF and ATK
function s.swapcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetCounter(0x4002)>=3 end
    e:GetHandler():RemoveCounter(tp,0x4002,3,REASON_COST)
end
function s.swapop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local atk=c:GetAttack()
        local def=c:GetDefense()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(def)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetValue(atk)
        c:RegisterEffect(e2)
    end
end
--destroy replace
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
            and c:IsCanRemoveCounter(tp,0x4002,4,REASON_COST)
    end
    if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
        return true
    else
        return false
    end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsCanRemoveCounter(tp,0x4002,4,REASON_COST) then
        c:RemoveCounter(tp,0x4002,4,REASON_COST)
    end
end