--Keiji Claus
--Scripted by Kooder
--Effects:
-- Cannot be Normal Summoned. You can Special Summon this card from your hand if you control at least 1 FIRE Warrior monster on the field. If Summoned this way, any damage your opponent takes is halved until the End Phase.
-- Cannot be destroyed by battle.
-- Cannot attack directly
-- Cannot be targeted by Spell cards.
-- When you take LP damage of any kind; This card gains 500 ATK.
-- During your opponent's End Phase; Add 1 Equip Spell from your deck or either player's GY to your hand.
-- When this card leaves the field; You can add 1 level 4 or lower monster from your deck to your hand. You can only use this effect of "Keiji Claus" once per turn.
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
-- Can SP if you control atleast 1 FIRE Warrior
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
-- Cannot be destroyed by battle
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
-- Cannot attack directly
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
-- Cannot be targeted by spells
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.sfilter)
	c:RegisterEffect(e4)
-- Gains 500 ATK
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_DAMAGE)
    e5:SetCondition(s.atkcon)
    e5:SetOperation(s.atkop)
    c:RegisterEffect(e5)
-- Add 1 Equip Spell Card
	local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,0))
    e6:SetCategory(CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(s.thcon)
    e6:SetTarget(s.thtg)
    e6:SetOperation(s.thop)
    c:RegisterEffect(e6)
-- Add 1 level 4 or lower monster
	local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,1))
    e7:SetCategory(CATEGORY_TOHAND)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_LEAVE_FIELD)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCountLimit(1,{id,1})
    e7:SetTarget(s.thtg1)
    e7:SetOperation(s.thop1)
    c:RegisterEffect(e7)
end
function s.fwfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)
end
function s.sfilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_SPELL)
end
function s.eqfilter(c)
    return c:IsAbleToHand() and c:IsEquipSpell()
end
function s.lvfilter(c)
    return c:IsAbleToHand() and c:IsLevelBelow(4)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(s.fwfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() then
        c:UpdateAttack(500)
    end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK|LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK|LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.lvfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end