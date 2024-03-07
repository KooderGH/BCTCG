--Ganglion
--Scripted by Konstak
--Effect
-- (1) This card can be Normal Summoned without tributing.
-- (2) Cannot be targeted for effects.
-- (3) When this card is Tribute Summoned, target up to 3 card(s) on the field; destroy those targets.
-- (4) This card gains 500 ATK for each face-up FIRE monster on the field, except this card.
-- (5) If this card is destroyed by card effect: Look at your opponent's hand; Destroy 1 card in your opponent's hand.
-- (6) When this card is destroyed by battle: You can add one Dragon monster from your deck to your hand.
-- (7) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --Can Be Set without Tribute. (1) 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    c:RegisterEffect(e1)
    --cannot be target (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --once tributed summon destroy up to 3 cards on the field (3)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCondition(s.trcon)
    e3:SetTarget(s.trtg)
    e3:SetOperation(s.trop)
    c:RegisterEffect(e3)
    --FIRE monsters player controls gain 500 ATK (4)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetValue(s.adval)
    c:RegisterEffect(e4)
    --When destroyed by card effect (5)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(s.descon)
    e5:SetTarget(s.handtg)
    e5:SetOperation(s.handop)
    c:RegisterEffect(e5)
    --When destroyed by battle (6)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,3))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCondition(s.descon2)
    e6:SetTarget(s.destg2)
    e6:SetOperation(s.desop2)
    c:RegisterEffect(e6)
    --Double tribute for the Tribute Summon of Dragon monsters (7)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e7:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e7)
end
--Tribute summon function (2)
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.trtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetTargetCards(e)
    if #tc>0 then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--Atk update function (4)
function s.atkfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(id)
end
function s.adval(e,c)
    return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*500
end
--Hand destroy (5)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,1)
    --Neither player can activate in response
    Duel.SetChainLimit(aux.FALSE)
end
function s.handop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if #g==0 then return end
    Duel.ConfirmCards(tp,g)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local hg=g:Select(tp,1,1,nil)
    Duel.Destroy(hg,POS_FACEUP,REASON_EFFECT)
    Duel.ShuffleHand(1-tp)
end
--Add when destroyed by battle function (6)
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.addfilter(c)
    return c:IsMonster() and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end