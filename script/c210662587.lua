-- Ackey
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Shield Mechanic
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.desatktg)
    c:RegisterEffect(e1)
    --Can make a second attack (Multi-hit)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Can attack directly
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e3)
end
--Shield Mechanic
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and c:IsFaceup() end
    return true
end