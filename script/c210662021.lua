-- Ms Sign
local s,id=GetID()
function s.initial_effect(c)
    --summon count limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,1)
    e2:SetTarget(s.limittg)
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
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	return t1>=1
end
function s.countval(e,re,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if t1>=1 then return 0 else return 1-t1 end
end
