-- M. Ost
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Knockback ability
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(2)
    e1:SetTarget(s.knockbacktg)
    e1:SetOperation(s.knockbackop)
    c:RegisterEffect(e1)
    --Curse on Battle Ability
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.cursecon)
    e2:SetTarget(s.cursetg)
    e2:SetOperation(s.curseop)
    c:RegisterEffect(e2)
    --Add lv6 or above Monster
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetTarget(s.drtg)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
end
--Knockback function
function s.knockbacktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_APPLYTO)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.knockbackop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(3206)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
        tc:RegisterEffect(e1)
    end
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
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
        Duel.NegateAttack()
    end
end
--Destroy and add function
function s.drfilter(c)
    return c:IsLevelAbove(6) and c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.drfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.drfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
