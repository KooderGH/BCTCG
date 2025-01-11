-- Gardeneel Bros.
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Targetable Warp Mechanic
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.warptg)
    e1:SetOperation(s.warpop)
    c:RegisterEffect(e1)
end
--Warp Function
function s.warpfilter(c)
	return c:IsAbleToRemove() and c:IsCanBeEffectTarget() and not c:IsCode(id)
end
function s.warptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.warpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(s.warpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.warpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.warpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    local tc=g:GetFirst()
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
            e1:SetOperation(s.returnop)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==2 then
        ct=0
        c:SetTurnCounter(ct)
        Duel.Hint(HINT_CARD,0,id)
        Duel.ReturnToField(e:GetLabelObject())
    end
end