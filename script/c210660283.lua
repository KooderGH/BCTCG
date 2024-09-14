--Pai Pai
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.descon)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	aux.GlobalCheck(s,function()
		s[0]=Group.CreateGroup()
		s[0]:KeepAlive()
		s[1]=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
		ge1:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_BATTLE_DESTROYED)
		ge2:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge2,0)
	end)
	    --SS from Hand
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,id)
    e3:SetCondition(s.ssummoncon)
    e3:SetTarget(s.ssummontarget)
    e3:SetOperation(s.ssummonop)
    c:RegisterEffect(e3)
	-- limit summon 2 max per turn
	--summon count limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetTarget(s.limittg)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
	--counter
	local et=Effect.CreateEffect(c)
	et:SetType(EFFECT_TYPE_FIELD)
	et:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	et:SetRange(LOCATION_SZONE)
	et:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	et:SetTargetRange(0,1)
	et:SetValue(s.countval)
	c:RegisterEffect(et)
	-- Gain 1000 ATK for each face-up Spell you control
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(s.atkval)
    c:RegisterEffect(e6)
	-- when destroyed by opponent's card effect add 1 warrior except "pai-pai"
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(s.searchcon)
	e7:SetTarget(s.searchtg)
	e7:SetOperation(s.searchop)
	c:RegisterEffect(e7)
end
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	s[0]:Clear()
	s[0]:Merge(Duel.GetFieldGroup(Duel.GetTurnPlayer(),0,LOCATION_MZONE))
	s[1]=s[0]:GetCount()
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if s[0]:GetCount()==0 then return end
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	s[0]:Sub(g)
	if s[0]:GetCount()==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,0,0,0)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsAttribute,rc),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)

end
--ss from hand
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spellfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,2,nil)
end
function s.ssummontarget(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local rg=Duel.GetMatchingGroup(s.spellfilter,tp,LOCATION_SZONE+LOCATION_FZONE,0,e:GetHandler())
    local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_SELECT,nil,nil,true)
    if #g>0 then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    end
    return false
end
function s.ssummonop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function s.spellfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
--Summon Limit
function s.limittg(e,c,tp)
	local t1,t2,t3=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_FLIPSUMMON,ACTIVITY_SPSUMMON)
	return t1+t2+t3>=2
end
function s.countval(e,re,tp)
	local t1,t2,t3=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_FLIPSUMMON,ACTIVITY_SPSUMMON)
	if t1+t2+t3>=2 then return 0 else return 2-t1-t2-t3 end
end
-- Gain ATK for each controlled Spell
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(function(card) return card:IsType(TYPE_SPELL) and card:IsFaceup() end, e:GetHandlerPlayer(), LOCATION_ONFIELD, 0, nil) * 1000
end
-- add 1 warrior
function s.searchcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp~=tp
end
function s.thfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsMonster() and c:IsAbleToHand() and not c:IsCode(id)
end
function s.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.searchop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end