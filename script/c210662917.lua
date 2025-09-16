-- Red Crab Cat
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Pay 150 LP based on how many you control
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetOperation(s.lpop)
    c:RegisterEffect(e1)
end
--e1
function s.crabfilter(c)
    return c:IsFaceup() and (c:IsCode(210662173) or c:IsCode(210662606) or c:IsCode(210662910) or c:IsCode(210662911) or c:IsCode(210662912) or c:IsCode(210662913) or c:IsCode(210662914) or c:IsCode(210662915) or c:IsCode(210662916) or c:IsCode(210662917) or c:IsCode(210662918))
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d = Duel.GetMatchingGroupCount(s.crabfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*150
    if e:GetHandler():IsRelateToEffect(e) and d then
        Duel.Damage(1-tp,d,REASON_EFFECT)
    end
end