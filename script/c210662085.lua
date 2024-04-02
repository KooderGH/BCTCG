-- Samurai Doggy
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
    --Also treated as a DARK monster on the field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_ATTRIBUTE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(ATTRIBUTE_DARK)
    c:RegisterEffect(e2)
    --Slow Ability
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCondition(s.slowcon)
    e3:SetOperation(s.slowop)
    c:RegisterEffect(e3)
end
--Special Summon Samurai Function
function s.hybridfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.hybridfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.hybridfilter,1,1,false,true,true,c,nil,nil,false,nil,nil)
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
--Slow Ability Function
function s.slowcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsRelateToBattle()
end
function s.slowop(e,tp,eg,ep,ev,re,r,rp)
    local effp=e:GetHandler():GetControler()
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.TossCoin(tp,1)==COIN_HEADS then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_BP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        if Duel.GetTurnPlayer()==effp then
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetCondition(s.skipcon)
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
        end
        Duel.RegisterEffect(e1,effp)
        Duel.NegateAttack()
    end
end
function s.skipcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end