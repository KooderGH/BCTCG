--Ice Cat
--Scripted by Konstak
--Effect
-- (1) Cannot be Normal Summoned/Set. Can only be Special Summoned (from your hand) while you control no monsters.
-- (2) During either player's turn (Quick): You can Target 1 card on the field; negate it until the end of this turn. You can only use this effect of "Ice Cat" once per turn.
-- (3) When this card is attacked; Double this card's attack until end of damage calulation.
-- (4) During your opponent's End Phase; Return this card to your hand, then draw 1 card.
-- (5) If this card is destroyed while on the field; Banish it, then end the current turn.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --Special Summon this card (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    --either player's turn (Quick): Target 1 card on the field (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.negtg)
    e2:SetOperation(s.negop)
    c:RegisterEffect(e2)
    --if this card is attacked (3)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetCondition(s.atkcon)
    e3:SetOperation(s.atkop)
    c:RegisterEffect(e3)
    --3 or more cards you control. Destroy this card (4)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(s.drcon)
    c:RegisterEffect(e4)
    --If this card is destroyed while on the field (5)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetOperation(s.bncon)
    e5:SetOperation(s.bnop)
    c:RegisterEffect(e5)
end
--Special Summon Function
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--(2)
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsNegatable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsNegatable,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
    local g=Duel.SelectTarget(tp,Card.IsNegatable,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
    end
end
--(3)
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttackTarget()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToBattle() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(c:GetAttack())
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e1)
    end
end
--(4)
function s.countfilter(c)
	return c:IsFaceup() and c:IsMonster()
end
function s.drcon(e)
	return Duel.IsExistingMatchingCard(s.countfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
--(5)
function s.bncon(e,c)
    return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local turnp=Duel.GetTurnPlayer()
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
    Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
    Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
    Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
    Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,turnp)
end
