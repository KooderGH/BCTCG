-- Devil Wife
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Death Disable Field
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTarget(s.surgetg)
    e1:SetOperation(s.surgeop)
    c:RegisterEffect(e1)
end
function s.surgetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.surgeop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsPlayerCanDraw(1-tp,1) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetCode(EVENT_PHASE+PHASE_DRAW)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        e1:SetCountLimit(1)
        e1:SetOperation(s.drawop)
        c:RegisterEffect(e1)
    end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local d1=6
    while d1>3 do
        d1=Duel.TossDice(tp,1)
    end
    local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,d1)
    local Zone=d1
    if tc then
        local seq=tc:GetSequence()
        local nseq=seq
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
        local nseq=seq
        if Duel.CheckLocation(1-tp,LOCATION_MZONE,nseq) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_DISABLE_FIELD)
            e1:SetRange(LOCATION_SZONE)
            e1:SetLabel(nseq+16)
            e1:SetOperation(s.disop)
            e1:SetReset(RESET_PHASE+PHASE_STANDBY,3)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function s.disop(e,tp)
    return 0x1<<e:GetLabel()
end