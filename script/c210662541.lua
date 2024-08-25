-- Raynard
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetLabel(1)
    e1:SetCondition(s.redcon)
    e1:SetValue(s.adval)
    c:RegisterEffect(e1)
    --Surge Attack (Ignition)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1,id)
    e2:SetLabel(3)
    e2:SetCondition(s.redcon)
    e2:SetTarget(s.surgetg)
    e2:SetOperation(s.surgeop)
    c:RegisterEffect(e2)
end
function s.filter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_PYRO) and c:IsAttackPos()
end
function s.redcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Atk gain
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*150
end
--Surge Attack Function
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
            e1:SetReset(RESET_PHASE+PHASE_STANDBY,1)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function s.disop(e,tp)
    return 0x1<<e:GetLabel()
end