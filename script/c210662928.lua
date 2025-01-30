-- Blue Bot
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    -- Special Summon this card
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    -- Special Summon Tribute
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetCondition(s.spcon2)
    e2:SetTarget(s.sptg2)
    e2:SetOperation(s.spop2)
    c:RegisterEffect(e2)
    --Shield Mechanic
    local e3=Effect.CreateEffect(c)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(s.desatktg)
    c:RegisterEffect(e3)
    --Death Disable Field
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTarget(s.surgetg)
    e4:SetOperation(s.surgeop)
    c:RegisterEffect(e4)
end
--Special Summon SS Function
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_DARK),c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--Special Summon Tribute Function
function s.blackfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.spcon2(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.blackfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.blackfilter,1,1,false,true,true,c,nil,nil,false,nil,nil)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
    return true
    end
    return false
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Release(g,REASON_COST)
    g:DeleteGroup()
end
--Shield Mechanic
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and c:IsFaceup() end
    return true
end
--Death Surge Function
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