-- Saint Red Fox
-- Scripted by poka-poka
-- Effects :
-- (1) You can only activate 1 "Saint Red Fox" per turn.
-- (2) When a monster effect is activated on the field: Destroy all monsters on the field during the End Phase of this turn.
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.actcon)
    e1:SetTarget(s.acttg)
    e1:SetOperation(s.actop)
    c:RegisterEffect(e1)
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return rc:IsType(TYPE_MONSTER) and rc:IsLocation(LOCATION_MZONE)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetOperation(s.desop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if #g>0 then
        Duel.Hint(HINT_CARD,0,id)
        Duel.Destroy(g,REASON_EFFECT)
    end
end
