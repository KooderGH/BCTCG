-- Aku Gory
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --When Normal Summoned (Search Ability)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.srtg)
    e1:SetOperation(s.srop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --Savage Blow
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetCondition(s.svgcon)
    e3:SetTarget(s.svgtg)
    e3:SetOperation(s.svgop)
    c:RegisterEffect(e3)
end
--When NS add function
function s.dfilter(c)
    return c:IsLevelBelow(3) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PSYCHIC) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK,0,2,2,nil)
    if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
    end
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