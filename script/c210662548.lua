-- Wafer Cat
local s,id=GetID()
function s.initial_effect(c)
    aux.AddNormalSetProcedure(c)
    --self destroy
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    c:RegisterEffect(e1)
    --Death Slow
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTarget(s.weakentg)
    e2:SetOperation(s.weakenop)
    c:RegisterEffect(e2)
end
function s.weakentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.weakenop(e,tp,eg,ep,ev,re,r,rp)
    local effp=e:GetHandler():GetControler()
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    if Duel.GetTurnPlayer()==effp then
        e1:SetLabel(Duel.GetTurnCount())
        e1:SetCondition(s.skipcon)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
    else
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
    end
    Duel.RegisterEffect(e1,effp)
    --Return To Hand
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
    e2:SetLabel(Duel.GetTurnCount())
    e2:SetReset(RESET_PHASE+PHASE_MAIN1,13)
    e2:SetRange(LOCATION_MZONE)
    e2:SetLabelObject(c)
    e2:SetCountLimit(1)
    e2:SetOperation(s.returnop)
    Duel.RegisterEffect(e2,tp)
end
function s.skipcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==12 then
        ct=0
        c:SetTurnCounter(ct)
        Duel.Hint(HINT_CARD,0,id)
        Duel.SendtoHand(e:GetLabelObject(),tp,REASON_EFFECT)
    end
end
