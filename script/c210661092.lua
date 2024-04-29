--Manic Eraser Cat
--Scripted By Konstak
--Effect:
-- 2 Monster with different names, except tokens.
-- (1) You can only control one "Manic Eraser Cat".
-- (2) Your opponent can only target "Manic Eraser Cat" for attacks.
-- (3) You take no battle damage from attacks involving this card.
-- (4) While this card is face-up on the field, other monsters you control cannot be targeted by card effects.
-- (5) Once per turn while this card is face-up on the field: If it would be destroyed; it is not destroyed.
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,aux.NOT(aux.FilterBoolFunctionEx(Card.IsType,TYPE_TOKEN)),1,1,s.lcheck)
    --Only this monster can be attack target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(s.atlimit)
    c:RegisterEffect(e1)
    --Avoid Battle damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --No Battle Damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    c:RegisterEffect(e3)
    --other cards cannot be targeted by card effects.
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetValue(1)
    e4:SetTarget(s.monsterfilter)
    c:RegisterEffect(e4)
    --Once per turn while this card is face-up on the field: If it would be destroyed; It isn't.
    local e5=Effect.CreateEffect(c)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(s.desreptg)
    c:RegisterEffect(e5)
end
--lcheck
function s.lcheck(g,lc,sumtype,tp)
    return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end
--Only this monster can be attack target function
function s.atlimit(e,c)
    return c:IsFacedown() or not c:IsCode(id)
end
--Monster filter
function s.monsterfilter(e,c,tp,r)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end
--once per turn cannot be destroyed
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) end
    return true
end