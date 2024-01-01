--Legeluga
--Scripted by Gideon with Naim's help. Special thanks to Naim for the EMZ effects!
--Effect
-- (1) Cannot be Normal Summoned or Set. Can only be Special Summoned from your hand or GY by Tributing 2 Fiend monsters you control, then move this card to your Extra Monster Zone.
-- (2) This cards Summon and Effects cannot be negated.
-- (3) Cannot be returned to hand, banished, or tributed while on the field.
-- (4) After 10 turns have passed after you Summoned this card (counting the turn you Summoned this card as the 1st turn), you win the Duel.
-- (5) Once per turn during your Main phase: You can Special Summon one Fiend monster from your hand or GY.
-- (6) If you control 4 or more Fiend monsters, your opponent cannot enter the battle phase.
-- (7) When this card leaves the field; banish it.
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
	--SS from Hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Move to EMZ
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(s.mvop)
    c:RegisterEffect(e2)
	--(1)Finish
	--(2)Start
	--Summon cannot be disabled (Hopefully)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--(2)Finish
	--(3)Start
	--Cannot be Tributed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_NEGATE)
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
	--Cannot banish while on the field
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_REMOVE)
	e7:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,1)
	e8:SetTarget(s.rmlimit)
	c:RegisterEffect(e8)
	--(3)Finish
	--(4)Start
	local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS+EFFECT_FLAG_CANNOT_NEGATE)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetOperation(s.activate)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:SetCountLimit(1)
		ge1:SetOperation(s.endop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(s.winop)
		Duel.RegisterEffect(ge2,0)
		end)
    c:RegisterEffect(e9)
	--(4)Finish
	--(5)Start
	--Special summon a fiend
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetProperty(EFFECT_FLAG_CANNOT_NEGATE)
	e10:SetCountLimit(1,{id,1})
	e10:SetRange(LOCATION_MZONE)
	e10:SetTarget(s.specialfiendtarget)
	e10:SetOperation(s.specialfiendop)
	c:RegisterEffect(e10)
	--(5)Finish
	--(6)Start
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_BP)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_NEGATE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(0,1)
	e11:SetCondition(s.bpcond)
	c:RegisterEffect(e11)
	--(6)Finish
	--(7)Start
	local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e12:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e12)
	--(7)Finish
end
--(1) functions
function s.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsReleasable()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
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
--(3) functions
function s.rmlimit(e,c,tp,r,re)
    return c==e:GetHandler() and re:GetHandler()~=e:GetHandler()
end
--(4) functions
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(id)
	e1:SetOperation(s.checkop)
	e1:SetCountLimit(1)
	e1:SetLabel(0)
	e1:SetValue(0)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END,11)
	Duel.RegisterEffect(e1,tp)
	local descnum=tp==c:GetOwner() and 0 or 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetDescription(aux.Stringid(id,descnum))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(1082946)
	e2:SetLabelObject(e1)
	e2:SetOwnerPlayer(tp)
	e2:SetOperation(s.reset)
	e2:SetReset(RESET_PHASE+PHASE_END,11)
	c:RegisterEffect(e2)
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	s.checkop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function s.endop(e,tp,eg,ep,ev,re,r,rp)
	local eff={Duel.GetPlayerEffect(tp,id)}
	for _,te in ipairs(eff) do
		s.checkop(te,te:GetOwnerPlayer(),nil,0,0,nil,0,0)
	end
	s.winop(e,tp,eg,ep,ev,re,r,rp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetValue()
	ct=ct+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetValue(ct)
	if ct==10 then
		if re then re:Reset() end
	end
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	t[0]=0
	t[1]=0
	local eff={Duel.GetPlayerEffect(tp,id)}
	for _,te in ipairs(eff) do
		local p=te:GetOwnerPlayer()
		local ct=te:GetValue()
		if ct==10 then
			t[p]=t[p]+1
			local label=te:GetLabel()+1
			if label==3 then
				te:Reset()
			end
		end
	end
	if t[0]>0 or t[1]>0 then
		if t[0]==t[1] then
			Duel.Win(PLAYER_NONE,WIN_REASON_FINAL_COUNTDOWN)
		elseif t[0]>t[1] then
			Duel.Win(0,WIN_REASON_FINAL_COUNTDOWN)
		else
			Duel.Win(1,WIN_REASON_FINAL_COUNTDOWN)
		end
	end
end
--(5) functions
function s.fiendfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.specialfiendtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.fiendfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.specialfiendop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.fiendfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--(6) functions
function s.bpcond(e)
  return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_FIEND),e:GetHandlerPlayer(),LOCATION_MZONE,0,4,nil)
end