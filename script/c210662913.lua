-- Assassin Crab
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
    --Damage LP
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,3))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCountLimit(1)
    e3:SetOperation(s.lpop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
end
--Special Summon SS Function
function s.crabfilter(c)
    return c:IsFaceup() and (c:IsCode(210662173) or c:IsCode(210662910) or c:IsCode(210662911) or c:IsCode(210662912) or c:IsCode(210662913) or c:IsCode(210662914) or c:IsCode(210662915) or c:IsCode(210662916) or c:IsCode(210662917) or c:IsCode(210662918))
end
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 or Duel.IsExistingMatchingCard(s.crabfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--Special Summon Tribute Function
function s.spcon2(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.crabfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.crabfilter,1,1,false,true,true,c,nil,nil,false,nil,nil)
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
--Damage LP Function
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.Damage(1-tp,500,REASON_EFFECT)
    end
end