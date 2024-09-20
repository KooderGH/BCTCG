--Neneko
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsLevelBelow,4),1,1)
	c:EnableReviveLimit()
    -- Effect 1: Draw 1 card on Link Summon
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.drawcon)
    e1:SetCost(s.discardcost)
    e1:SetOperation(s.drawop)
    c:RegisterEffect(e1)
    -- Effect 2: Tribute a Level 5 or higher monster to Special Summon from GY
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(s.tributecost)
	e2:SetCondition(s.tributecon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    -- Effect 3: Add a monster from the deck when destroyed by battle
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end
--E1
function s.drawcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.discardcost(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
--E2
function s.tributecon(e)
    local tp = e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(Card.IsLevelAbove,tp,LOCATION_MZONE,0,1,nil,5) and
           Duel.IsExistingMatchingCard(Card.IsLevelBelow,tp,LOCATION_GRAVE,0,1,nil,4)
end
-- Tribute Cost: Check and release 1 monster with Level 5 or higher
function s.tributecost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsLevelAbove,1,nil,5) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsLevelAbove,1,1,nil,5)
    Duel.Release(g,REASON_COST)
end

-- Special Summon Filter
function s.filter(c,e,tp,zone)
    return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
-- Target Function: Check if we can special summon a Level 4 or lower monster
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local zone=e:GetHandler():GetLinkedZone(tp)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp,zone) end
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
            and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
-- Special Summon Operation
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=c:GetLinkedZone(tp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
--E3
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_DECK,0,1,nil) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsMonster,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        local tc=g:GetFirst()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetProperty(EFFECT_FLAG_OATH)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_SUMMON)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(function(e,c) return c:IsCode(tc:GetCode()) end)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        tc:RegisterEffect(e2)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CANNOT_ACTIVATE)
        e3:SetValue(1)
        tc:RegisterEffect(e3)
    end
end