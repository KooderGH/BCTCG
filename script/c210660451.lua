--Ushiwakamaru
--Scripted by Konstak
--Effect
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. You can Special Summon this card from your hand or GY by controling 3 or more WIND type monsters, Then, move this card to your Extra Monster Zone. You can only activate this effect once per duel.
-- (2) Cannot be returned to hand, banished, or tributed.
-- (3) Cannot be targeted by card effects.
-- (4) Once during either players turn (Quick): You can target 1 WIND monster in your GY; Special Summon it.
-- (5) This card gains 200 ATK for each WIND monster in your GY.
-- (6) Each time a WIND monster is sent to the GY; Add 1 Quaking Hammer Counter(s) to this card.
-- (7) You can remove 10 Quaking Hammer Counter(s) from this card (Ignition); Banish all cards on your opponent's side of the field. Your opponent cannot activate cards or effects in response to this effect. Your opponent cannot Normal Summon/Set next turn.
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
    --Special Summon from GY
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,0))
    e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e9:SetType(EFFECT_TYPE_QUICK_O)
    e9:SetCode(EVENT_FREE_CHAIN)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1)
    e9:SetTarget(s.sstg)
    e9:SetOperation(s.ssop)
    c:RegisterEffect(e9)
    --(4)Finish
    --(5)Start
    --ATK based on Wind machines on your GY
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e10:SetRange(LOCATION_EMZONE)
    e10:SetCode(EFFECT_UPDATE_ATTACK)
    e10:SetValue(s.atkval)
    c:RegisterEffect(e10)
    --(5)Finish
    --(6)Start
    --When card(s) on destroyed by card effect(s) Place Quaking Hammer Counter
    c:EnableCounterPermit(0x4002)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetProperty(EFFECT_FLAG_DELAY)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EVENT_TO_GRAVE)
    e11:SetCondition(s.ctcon)
    e11:SetOperation(s.ctop)
    c:RegisterEffect(e11)
    --(6)Finish
    --(7)Start
    --add one wind monster from your deck or GY to hand
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id,1))
    e12:SetCategory(CATEGORY_REMOVE)
    e12:SetType(EFFECT_TYPE_IGNITION)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCountLimit(1,id)
    e12:SetCost(s.rmcost)
    e12:SetTarget(s.rmtg)
    e12:SetOperation(s.rmop)
    c:RegisterEffect(e12)
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
    if (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1)) then
        local lftezm=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,5) and 0x20 or 0
        local rgtemz=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,6) and 0x40 or 0
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~ZONES_EMZ|(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--SS from GY (4)
function s.specialfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.specialfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--ATK gain (5)
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_WIND)*200
end
-- Quaking Hammer (6)
s.counter_list={0x4002}
function s.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsPreviousControler(tp)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ctfilter,1,nil,tp)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x4002,1)
end
--Banish all monsters your opponent controls (7)
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x4002,10,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x4002,10,REASON_COST)
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_MZONE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_MZONE,e:GetHandler())
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