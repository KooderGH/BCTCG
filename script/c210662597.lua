-- Emelia & Cat
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetLabel(1)
    e1:SetCondition(s.ccon)
    e1:SetValue(s.adval)
    c:RegisterEffect(e1)
end
function s.filter(c)
    return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function s.ccon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Atk gain
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end