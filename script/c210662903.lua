-- Li'l Green Bot
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Curse on Battle Ability
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.cursecon)
    e1:SetTarget(s.cursetg)
    e1:SetOperation(s.curseop)
    c:RegisterEffect(e1)
end
--Curse on Battle Function
function s.cursecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsRelateToBattle() and Duel.GetTurnPlayer()==tp
end
function s.cursetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
end
function s.curseop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetHandler():GetBattleTarget()
    if tc and (tc:IsFaceup() and not tc:IsDisabled()) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_PHASE+PHASE_MAIN1,2)
        tc:RegisterEffect(e1)
        Duel.NegateAttack()
    end
end