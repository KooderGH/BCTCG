--Legeluga
--Scripted by Gideon with Naim's help. Special thanks to Naim for the EMZ effects! Link Precedure by Konstak
--Effect
-- Link Monster ↙↘	
-- 2 Level 3 or lower Fiend Monsters
-- (1) Cannot be used as Link material.
-- (2) Summon Cannot be Negated.
-- (3) This cards Summon and Effects cannot be negated.
-- (4) Cannot be returned to hand, banished, or tributed while on the field.
-- (5) After 10 turns have passed after you Summoned this card (counting the turn you Summoned this card as the 1st turn), you win the Duel.
-- (6) Once per turn during your Main phase: You can Special Summon one Fiend monster from your hand or GY.
-- (7) If you control 4 or more Fiend monsters, your opponent cannot enter the battle phase.
-- (8) When this card leaves the field; banish it.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Link Summon Procedure
	Link.AddProcedure(c,s.matfilter,2,2)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --Summon cannot be disabled (Hopefully)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)
    --Cannot be Tributed
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetCode(EFFECT_UNRELEASABLE_SUM)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e4)
    --Cannot be returned to hand
    local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_TO_HAND)
    c:RegisterEffect(e5)
    --Cannot banish while on the field
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_CANNOT_REMOVE)
    e6:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetTargetRange(1,1)
    e7:SetTarget(s.rmlimit)
    c:RegisterEffect(e7)
    --Legelan Timer
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS+EFFECT_FLAG_CANNOT_NEGATE)
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetOperation(s.activate)
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
    c:RegisterEffect(e8)
    --Special summon a fiend
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,0))
    e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetProperty(EFFECT_FLAG_CANNOT_NEGATE)
    e9:SetCountLimit(1,{id,1})
    e9:SetRange(LOCATION_MZONE)
    e9:SetTarget(s.specialfiendtarget)
    e9:SetOperation(s.specialfiendop)
    c:RegisterEffect(e9)
    --Cannot enter battle phase
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_CANNOT_BP)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_NEGATE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetTargetRange(0,1)
    e10:SetCondition(s.bpcond)
    c:RegisterEffect(e10)
    --When this card leaves the field; banish it.
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e11:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e11)
end
--(1) functions
function s.matfilter(c,lc,sumtype,tp)
	return c:IsLevelBelow(3) and c:IsRace(RACE_FIEND) and c:IsFaceup()
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