-- Zapy
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Can target 1 card on the field. destroy that target (Ignition)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    --Immune to Wave, Surge, Single Attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Battle Warp Mechanic
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetCondition(s.warpcon)
    e3:SetTarget(s.warptg)
    e3:SetOperation(s.warpop)
    c:RegisterEffect(e3)
end
--Destroy That Target Function
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(3206)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e:GetHandler():RegisterEffect(e1,true)
    end
end
--Warp Function
function s.warpcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.warptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function s.warpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=e:GetHandler():GetBattleTarget()
    local d1=Duel.TossDice(tp,1)
    if bc:IsRelateToBattle() and d1<=2 then
        if Duel.Remove(bc,bc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetReset(RESET_PHASE+PHASE_MAIN1,2)
            e1:SetLabelObject(bc)
            e1:SetCountLimit(1)
            e1:SetOperation(s.returnop)
            Duel.RegisterEffect(e1,tp)
            Duel.NegateAttack()
        end
    end
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==1 then
        ct=0
        c:SetTurnCounter(ct)
        Duel.Hint(HINT_CARD,0,id)
        Duel.ReturnToField(e:GetLabelObject())
    end
end