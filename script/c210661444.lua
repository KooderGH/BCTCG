--Neo Piledriver Cat
--Scripted By Konstak
--Effect:
-- 2 EARTH Machine monsters with different names, except tokens.
-- (1) Cannot be used as Link material.
-- (2) You can only control one "Neo Piledriver Cat".
-- (3) When your opponent activates a monster effect; Add 1 Spell Counter to this card
-- (4) Cannot be destroyed by battle and cannot be targeted by card effects.
-- (5) You can remove 2 Spell Counters from this card to add 1 EARTH Machine monster from your Deck or GY to your hand. (Quick)
-- (6) When this card declares an attack on a monster: Negate the attack; The attack target cannot attack until the end of your next turn.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(COUNTER_SPELL)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,s.machinefilter,2,2,s.lcheck)
    --cannot link material
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    --Add counter
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(aux.chainreg)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.acon)
    e2:SetOperation(s.acop)
    c:RegisterEffect(e2)
    --Cannot be destroyed by battle
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Cannot be targeted
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --add one EARTH Machine monster from your deck or GY to hand
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(s.srcost)
    e5:SetTarget(s.srtg)
    e5:SetOperation(s.srop)
    c:RegisterEffect(e5)
    --Knockback ability
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_DISABLE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetCondition(s.knockbackcon)
    e6:SetTarget(s.knockbacktg)
    e6:SetOperation(s.knockbackop)
    c:RegisterEffect(e6)
end
s.counter_place_list={COUNTER_SPELL}
--lcheck
function s.machinefilter(c,scard,sumtype,tp)
    return c:IsRace(RACE_MACHINE,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_EARTH,scard,sumtype,tp) and not c:IsType(TYPE_TOKEN)
end
function s.lcheck(g,lc,sumtype,tp)
    return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end
--add counter
function s.acon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(1)>0 then
        e:GetHandler():AddCounter(COUNTER_SPELL,1)
    end
end
--Special Summon Search function
function s.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_SPELL,2,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,COUNTER_SPELL,2,REASON_COST)
end
function s.srfilter(c)
    return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--Knockback function
function s.knockbackcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.knockbacktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
end
function s.knockbackop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetHandler():GetBattleTarget()
    if tc:IsRelateToBattle() and tc and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
        Duel.NegateAttack()
    end
end