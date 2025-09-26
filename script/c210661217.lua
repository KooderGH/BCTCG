--ERI
--Scripted by Kooder
--Effects:
-- When this card is Summoned; Add 1 "MARCO", "TARMA", or "FIO" from your Deck or GY to your hand.
-- This card gains 300 ATK for each "Metal Slug" Banner monster on the field.
-- If this card inflicts battle damage to your opponent, activate 1 of these effects:
-- * Add up to 2 "MARCO", "TARMA", "ERI", or "FIO" from your Deck, GY, or Banish to your Hand.
-- * Send 1 spell or trap card from your opponent side of the field to the GY.
local s,id=GetID()
function s.initial_effect(c)
-- Add 1 card from your deck or GY to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
-- 300 ATK for each MS monster on field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
-- If this card inflicts battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(s.condition)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
end
function s.thfilter(c)
	return c:IsCode(210661215) or c:IsCode(210661216) or c:IsCode(210661218)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.msfilter(c)
	return c:IsFaceup() and c:IsCode(210660727) or c:IsCode(210661219) or c:IsCode(210660224) or c:IsCode(210660225) or c:IsCode(210660223) or c:IsCode(210660222) or c:IsCode(210661220) or c:IsCode(210661221) or c:IsCode(210661216) or c:IsCode(210661215) or c:IsCode(210661217) or c:IsCode(210661218)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.msfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*300
end
function s.mteffilter(c)
	return c:IsCode(210661215) or c:IsCode(210661216) or c:IsCode(210661217) or c:IsCode(210661218) 
end
function s.stfilter(c)
	return c:IsSpellTrap()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE)) or (chkc:IsLocation(LOCATION_REMOVED|LOCATION_DECK|LOCATION_GRAVE) and chkc:IsControler(tp) and s.mteffilter(chkc)) end
	local b1=Duel.IsExistingMatchingCard(s.mteffilter,tp,LOCATION_REMOVED|LOCATION_DECK|LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.stfilter,1-tp,LOCATION_SZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED|LOCATION_DECK|LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		-- Add up to 2 MTEF to hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.mteffilter,tp,LOCATION_REMOVED|LOCATION_DECK|LOCATION_GRAVE,0,1,2,nil)
		if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	else
		-- 1 Spell/Trap card to GY
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end