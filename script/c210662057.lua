-- Teacher Cybear
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --special summon tribute
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_HAND)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetCondition(s.spcon)
    e0:SetTarget(s.sptg)
    e0:SetOperation(s.spop)
    c:RegisterEffect(e0)
    --Opponent No Battle Damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Attack all each time
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Metal Mechanic
    local e3=Effect.CreateEffect(c)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(s.desatktg)
    c:RegisterEffect(e3)
    --self destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(s.sdcon)
    c:RegisterEffect(e4)
end
function s.filter(c)
    return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.filter,2,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.filter,2,2,false,true,true,c,nil,nil,false,nil,nil)
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
--Metal Ability Function
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