--Headmistress Jeanne
--Scripted by Konstak, Fixed by Gideon
--Effect:
local s,id=GetID()
function s.initial_effect(c)
    --summon with 3 tribute
    local e1=aux.AddNormalSummonProcedure(c,true,false,3,3)
    local e2=aux.AddNormalSetProcedure(c,true,false,3,3)
    --cannot special summon
    local e3=Effect.CreateEffect(c)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e3)
    --tribute limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_TRIBUTE_LIMIT)
    e4:SetValue(s.spfilter)
    c:RegisterEffect(e4)
    --Move to EMZ
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetOperation(s.mvop)
    c:RegisterEffect(e5)
    --Cannot be returned to hand
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetCode(EFFECT_CANNOT_TO_HAND)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --Cannot banish
    local e7=e6:Clone()
    e7:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e7)
    --Cannot be targeted (self)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(1)
    c:RegisterEffect(e8)
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
    --Tribute 1 Spellcaster monster, tribute 1 card.
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,1))
    e10:SetCategory(CATEGORY_RELEASE)
    e10:SetType(EFFECT_TYPE_QUICK_O)
    e10:SetCode(EVENT_FREE_CHAIN)
    e10:SetRange(LOCATION_MZONE)
    e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e10:SetCountLimit(1)
    e10:SetCost(s.trcost)
    e10:SetTarget(s.trtg)
    e10:SetOperation(s.trop)
    c:RegisterEffect(e10)
    --Add counter if a spellcaster monster is Tributed
    c:EnableCounterPermit(0x4004)
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(id,2))
    e11:SetCategory(CATEGORY_COUNTER)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e11:SetProperty(EFFECT_FLAG_DELAY,EFFECT_FLAG2_CHECK_SIMULTANEOUS)
    e11:SetCode(EVENT_RELEASE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetLabel(0)
    e11:SetCondition(s.ctcon)
    e11:SetTarget(s.cttg)
    e11:SetOperation(s.ctop)
    c:RegisterEffect(e11)
    --Win Condition
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetProperty(EFFECT_FLAG_DELAY)
    e12:SetCode(EVENT_ADJUST)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCondition(s.wincon)
    e12:SetOperation(s.winop)
    c:RegisterEffect(e12)
    --Add 1000 LP based on how many you control
    local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(id,3))
    e13:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCode(EVENT_PHASE+PHASE_END)
    e13:SetCountLimit(1)
    e13:SetOperation(s.lpop)
    c:RegisterEffect(e13)
    --Special summon itself from GY
    local e14=Effect.CreateEffect(c)
    e14:SetDescription(aux.Stringid(id,4))
    e14:SetCategory(CATEGORY_TOHAND)
    e14:SetType(EFFECT_TYPE_IGNITION)
    e14:SetRange(LOCATION_GRAVE)
    e14:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e14:SetCost(s.gycost)
    e14:SetTarget(s.gytg)
    e14:SetOperation(s.gyop)
    c:RegisterEffect(e14)
end
function s.spfilter(e,c)
    return not c:IsAttribute(ATTRIBUTE_LIGHT) or not c:IsRace(RACE_SPELLCASTER)
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
--SS from GY (4)
function s.specialfilter(c,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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
--Send to Gy
function s.trfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function s.trcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.trfilter,1,false,nil,nil) end
    local g=Duel.SelectReleaseGroupCost(tp,s.trfilter,1,1,false,nil,nil)
    Duel.Release(g,REASON_COST)
end
function s.trtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasableByEffect() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Release(tc,REASON_EFFECT)
	end
end
--Tribute condition
function s.cfilter(c,label)
	if label==1 and c:IsFacedown() then return false end
	if c:IsPreviousLocation(LOCATION_MZONE) then
		return c:GetPreviousRaceOnField()&RACE_SPELLCASTER>0
	else
		return c:IsMonster() and c:IsOriginalRace(RACE_SPELLCASTER)
	end
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetLabel())
end
s.counter_list={0x4004}
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x4004)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x4004,1)
    end
end
--Win Condition
function s.wincon(e)
    return e:GetHandler():GetCounter(0x4004)>=10
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Win(tp,0x63)
end
function s.ggfilter(c)
    return c:IsFaceup() and c:IsLevelAbove(7)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d = Duel.GetMatchingGroupCount(s.ggfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*1000
    if e:GetHandler():IsRelateToEffect(e) and d then
        Duel.Recover(tp,d,REASON_EFFECT)
    end
end
--Add to hand
function s.ggfilter2(c,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function s.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.ggfilter2,1,false,nil,nil,tp) end
    local g=Duel.SelectReleaseGroupCost(tp,s.ggfilter2,1,1,false,nil,nil,tp)
    Duel.Release(g,tp,REASON_COST)
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end