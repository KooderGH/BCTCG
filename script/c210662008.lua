-- Sir Seal
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Pay 500 LP
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetOperation(s.lpop)
    c:RegisterEffect(e1)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.Damage(1-tp,500,REASON_EFFECT)
        Duel.Damage(tp,500,REASON_EFFECT)
    end
end