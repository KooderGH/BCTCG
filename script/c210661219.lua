--SV-001
--Scripted by Kooder
--Effects:
-- Cannot be Normal Summoned or Set. Must first be Special Summoned (from your hand) when you control "MARCO", "ERI", "TARMA", and "FIO".
-- Unaffected by effects of Trap Cards.
-- This card gains 500 ATK/DEF for each Level 3 FIRE Machine monster on the field.
-- Any battle damage inflicted to either player becomes 100 instead.
-- "MARCO', "ERI", "TARMA", and "FIO" cards you control can attack directly.
-- At the End phase; Discard 2 cards from the Top of your opponent's deck for each FIRE Machine monster you control.
-- If this card is destroyed by battle: Select 1 Spell Card from your opponent's GY; Add it to your hand.
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
-- SP Summon when you control all MTEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
-- Unaffected by Trap Cards
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
-- 500 ATK/DEF for each Lv3 FIRE Machine
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
-- Any battle damage becomes 100
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(100)
	c:RegisterEffect(e5)
-- MTEF can attack directly
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(s.dirtg)
    c:RegisterEffect(e6)
-- Discard 2 cards for each FIRE Machine
	local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,0))
    e7:SetCategory(CATEGORY_DECKDES)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetRange(LOCATION_MZONE|LOCATION_DECK)
    e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCountLimit(1)
	e7:SetCondition(s.sdcon)
    e7:SetTarget(s.sdtg)
    e7:SetOperation(s.sdop)
    c:RegisterEffect(e7)
-- 1 spell from your opponent's GY to hand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,1))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_DESTROYED)
	e8:SetCondition(s.thcon)
	e8:SetTarget(s.thtg)
	e8:SetOperation(s.thop)
	c:RegisterEffect(e8)
end
function s.mteffilter(c)
	return c:IsFaceup() and c:IsCode(210661215) or c:IsCode(210661216) or c:IsCode(210661217) or c:IsCode(210661218)
end
function s.marcofilter(c)
	return c:IsFaceup() and c:IsCode(210661215) 
end
function s.erifilter(c)
	return c:IsFaceup() and c:IsCode(210661216)
end
function s.tarmafilter(c)
	return c:IsFaceup() and c:IsCode(210661217) 
end
function s.fiofilter(c)
	return c:IsFaceup() and c:IsCode(210661218)
end
function s.efilter(e,te)
	return te:IsTrapEffect()
end
function s.fmlvfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_MACHINE) and c:IsLevel(3)
end
function s.fmfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_MACHINE)
end
function s.spfilter(c)
	return c:IsSpell() and c:IsAbleToHand()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.marcofilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(s.erifilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tarmafilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.fiofilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.fmlvfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*500
end
function s.dirtg(e,c)
	return Duel.IsExistingMatchingCard(s.mteffilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	local sd=Duel.GetMatchingGroupCount(s.fmfilter,0,LOCATION_MZONE,0,nil)*2
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,sd)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local sd=Duel.GetMatchingGroupCount(s.fmfilter,0,LOCATION_MZONE,0,nil)*2
    Duel.DiscardDeck(1-tp,sd,REASON_EFFECT)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,0,LOCATION_GRAVE,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end