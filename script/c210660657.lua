--Iz the Dancer of Grief
--Scripted by Konstak
--Effect:
-- (1) Cannot be Normal Summoned/Set. Must be Special Summoned (from your hand) by having exactly 3 DARK monsters in your GY.
-- (2) You can banish 1 DARK monster from your GY, then target 1 card on the field (Igniton); Destroy that target.
-- (3) Level 6 or higher monster's cannot target this card with card effects.
-- (4) When this card is Banished; You can add 1 DARK monster from your deck to your hand.
-- (5) Cannot be tributed or used as Link Material
-- (6) You can only control one "Iz the Dancer"
local s,id=GetID()
function s.initial_effect(c)
	-- Can Only control 1
	c:SetUniqueOnField(1,0,id)
	c:EnableUnsummonable()
    --cannot special summon (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --special summon (1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.spcon)
    c:RegisterEffect(e2)
    --destroy (2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(s.descost)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
    --Lvl 8 or higher cannot target this card with card effects
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(s.levelval)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --banish and add 1 card from deck (4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_REMOVE)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_REMOVED)
    e5:SetTarget(s.bntg)
    e5:SetOperation(s.bnop)
    c:RegisterEffect(e5)
	-- (5) Cannot be tributed. Cannot be used as link material.
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_UNRELEASABLE_SUM)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e7)
	local e8=e6:Clone()
    e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e8)
end
--(1)
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)==3
end
--(2)
function s.desfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--(3)
function s.levelval(e,c)
    return c:IsLevelAbove(6)
end
--(4)
function s.banishfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function s.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.banishfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.banishfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end