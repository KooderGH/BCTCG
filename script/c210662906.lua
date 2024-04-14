-- Wizadron
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --Add Monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.addtg)
    e1:SetOperation(s.addop)
    c:RegisterEffect(e1)
    --Long Distance Ability
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetCondition(s.ldcon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
--Add function
function s.addfilter(c)
    return c:IsLevel(3) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--Long Distance Function
function s.ldfilter(c)
    return not c:IsCode(id)
end
function s.ldcon(e,c)
    if c==nil then end
    return Duel.IsExistingMatchingCard(s.ldfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end