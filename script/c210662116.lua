-- Angel Fanboy
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
    c:RegisterEffect(e0)
    --Normal summon count limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetTarget(s.limittg)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e2)
    --counter
    local et=Effect.CreateEffect(c)
    et:SetType(EFFECT_TYPE_FIELD)
    et:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
    et:SetRange(LOCATION_MZONE)
    et:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    et:SetTargetRange(1,1)
    et:SetValue(s.countval)
    c:RegisterEffect(et)
end
function s.limittg(e,c,tp)
	local t1,t2=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_FLIPSUMMON)
	return t1+t2>=1
end
function s.countval(e,re,tp)
	local t1,t2=Duel.GetActivityCount(tp,ACTIVITY_SUMMON,ACTIVITY_FLIPSUMMON)
	if t1+t2>=1 then return 0 else return 1-t1-t2 end
end