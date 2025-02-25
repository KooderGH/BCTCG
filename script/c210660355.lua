--Mighty Rekon Korps
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --Special Summon this card
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Cannot be returned
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --no battle damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    c:RegisterEffect(e3)
    --When this card destroys a monster by battle; add one EARTH machine monster from deck to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetCondition(s.atkcon)
    e4:SetTarget(s.atktg)
    e4:SetOperation(s.atkop)
    c:RegisterEffect(e4)
    --atkup
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetCountLimit(1)
    e5:SetCondition(s.atkupcon)
    e5:SetOperation(s.atkupop)
    c:RegisterEffect(e5)
    --spsummon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,2))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCountLimit(1,id)
    e6:SetCondition(s.spgycon)
    e6:SetTarget(s.spgytg)
    e6:SetOperation(s.spgyop)
    c:RegisterEffect(e6)
end
--Special summon function
function s.filter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.CheckLPCost(c:GetControler(),1000)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,1000)
end
--Destroy and add function
function s.filter2(c)
    return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsMonster()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--atkup function
function s.rcfilter(c)
    return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function s.atkupcon(e,tp,eg,ep,ev,re,r,rp)
    return s.rcfilter(e:GetHandler()) or Duel.IsExistingMatchingCard(s.rcfilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.atkupop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToBattle() or c:IsFacedown() then return end
    local ct=Duel.GetMatchingGroupCount(s.rcfilter,tp,0,LOCATION_MZONE,nil)
    if s.rcfilter(c) then ct=ct+1 end
    if ct>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000*ct)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        c:RegisterEffect(e1)
    end
end
--Special Summon from GY function
function s.spgycon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousAttackOnField()>c:GetBaseAttack()
end
function s.spgyfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(id)
end
function s.spgytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spgyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.spgyfilter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spgyop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if #tg>0 then
        Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
    end
end
