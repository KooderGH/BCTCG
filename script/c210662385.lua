-- Hater
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Zombie monsters you control cannot be banished by card effects
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_REMOVE)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(s.rmlimit)
    c:RegisterEffect(e1)
end
--Cannot remove
function s.rmlimit(e,c,tp,r)
    return c:IsRace(RACE_ZOMBIE) and c:IsFaceup() and not c:IsImmuneToEffect(e) and r&REASON_EFFECT>0
end