-- Ms Sign
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Special summon count limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetTarget(s.limittg)
    c:RegisterEffect(e1)
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
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	return t1>=1
end
function s.countval(e,re,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if t1>=1 then return 0 else return 1-t1 end
end
