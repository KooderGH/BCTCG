-- Car
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
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTarget(s.warptg)
    e2:SetOperation(s.warpop)
    c:RegisterEffect(e2)
end
--Warp Function
function s.warpfilter(c)
	return c:IsAbleToRemove() and c:IsMonster() and c:IsCanBeEffectTarget() and not c:IsCode(id)
end
function s.warptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.warpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    if tc and Duel.TossCoin(tp,1)==COIN_HEADS then
        Duel.HintSelection(g)
        if Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetReset(RESET_PHASE+PHASE_MAIN1,3)
            e1:SetLabelObject(tc)
            e1:SetCountLimit(1)
            e1:SetOperation(s.returnop1)
            Duel.RegisterEffect(e1,tp)
        end
    end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    --Return To Hand
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
    e2:SetLabel(Duel.GetTurnCount())
    e2:SetReset(RESET_PHASE+PHASE_MAIN1,13)
    e2:SetRange(LOCATION_MZONE)
    e2:SetLabelObject(c)
    e2:SetCountLimit(1)
    e2:SetOperation(s.returnop2)
    Duel.RegisterEffect(e2,tp)
end
function s.skipcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end
function s.returnop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    if ct>0 then
        Duel.Hint(HINT_CARD,0,id)
        Duel.ReturnToField(e:GetLabelObject())
    end
end
function s.returnop2(e,tp,eg,ep,ev,re,r,rp)
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