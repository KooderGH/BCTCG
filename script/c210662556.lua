-- Aku Gory
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Savage Blow
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetCondition(s.svgcon)
    e1:SetTarget(s.svgtg)
    e1:SetOperation(s.svgop)
    c:RegisterEffect(e1)
end
--Savage Blow
function s.svgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsRelateToBattle()
end
function s.svgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.svgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d1=Duel.TossDice(tp,1)
    if c:IsFaceup() and c:IsRelateToEffect(e) and d1<=2 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(c:GetAttack())
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e1)
    end
end