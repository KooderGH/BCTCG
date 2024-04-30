--Brainwashed Mohawk Cat
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    aux.AddUnionProcedure(c)
    --Atk up
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-500)
    e1:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e1)
    --Def up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetValue(-500)
    e2:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e2)
    --double attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Search
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(s.thcon)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    e4:SetCountLimit(1,id)
    c:RegisterEffect(e4)
end
--e4
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.filter(c)
    return c:IsMonster() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end