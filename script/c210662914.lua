-- Flying Crab Cat
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    aux.AddUnionProcedure(c,s.crabfilter)
    --Stats up
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(200)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
end
--Union filter
function s.crabfilter(c)
    return c:IsFaceup() and (c:IsCode(210662173) or c:IsCode(210662606) or c:IsCode(210662910) or c:IsCode(210662911) or c:IsCode(210662912) or c:IsCode(210662913) or c:IsCode(210662914) or c:IsCode(210662915) or c:IsCode(210662916) or c:IsCode(210662917) or c:IsCode(210662918))
end