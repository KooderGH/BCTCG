-- Koronium
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --special summon tribute
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Metal Mechanic
    local e2=Effect.CreateEffect(c)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.desatktg)
    c:RegisterEffect(e2)
    --self destroy
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_SELF_DESTROY)
    e3:SetCondition(s.sdcon)
    c:RegisterEffect(e3)
end
function s.smsfilter(c)
    return c:IsFaceup() and c:IsCode(210662147)
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.smsfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.smsfilter,1,1,false,true,true,c,nil,nil,false,nil,nil)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
    return true
    end
    return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Release(g,REASON_COST)
    g:DeleteGroup()
end
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsFaceup() end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(-50)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
        c:RegisterEffect(e1)
    return true
end
function s.sdcon(e)
    local c=e:GetHandler()
    return c:GetDefense()<=0
end