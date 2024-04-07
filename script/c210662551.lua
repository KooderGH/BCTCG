-- Elder Flame Doron
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
    --Death Surge
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTarget(s.surgetg)
    e2:SetOperation(s.surgeop)
    c:RegisterEffect(e2)
end
function s.surgetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.surgeop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local d1=6
    while d1>3 do
        d1=Duel.TossDice(tp,1)
    end
    local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,d1)
    local Zone=d1
    if tc then
		--Disable Zone
        local seq=tc:GetSequence()
        local nseq=4-seq
        Duel.Destroy(tc,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE_FIELD)
        e1:SetRange(LOCATION_SZONE)
        e1:SetLabel(nseq+16)
        e1:SetOperation(s.disop)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY,1)
        Duel.RegisterEffect(e1,tp)
    else
        local seq=Zone
        local nseq=4-seq
        if Duel.CheckLocation(1-tp,LOCATION_MZONE,nseq) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_DISABLE_FIELD)
            e1:SetRange(LOCATION_SZONE)
            e1:SetLabel(nseq+16)
            e1:SetOperation(s.disop)
            e1:SetReset(RESET_PHASE+PHASE_STANDBY,1)
            Duel.RegisterEffect(e1,tp)
        end
    end
    --Return To Hand
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
    e2:SetLabel(Duel.GetTurnCount())
    e2:SetReset(RESET_PHASE+PHASE_MAIN1,5)
    e2:SetRange(LOCATION_MZONE)
    e2:SetLabelObject(c)
    e2:SetCountLimit(1)
    e2:SetOperation(s.returnop)
    Duel.RegisterEffect(e2,tp)
end
function s.disop(e,tp)
    return 0x1<<e:GetLabel()
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
    if ct==4 then
        ct=0
        c:SetTurnCounter(ct)
        Duel.Hint(HINT_CARD,0,id)
        Duel.SendtoHand(e:GetLabelObject(),tp,REASON_EFFECT)
    end
end
