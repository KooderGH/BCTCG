--Mekako Saionji
--Scripted by Gideon
--Effects
--Once per turn, you can either: Target 1 DARK Warrior Monster you control; equip this card to that target, OR: Unequip this card and Special Summon it.
--During either player turn, while equipped to a monster by this effect: You can target 1 face-up monster on the field; the equipped monster loses exactly 700 ATK (even if this card leaves the field), and if it does, destroy that target. You can only active this effect of "Mekako Saionji" once per turn.
--If the equipped monster would be destroyed by battle or card effect, destroy this card instead.
--When this card is destroyed and sent to the graveyard; You can add one Psychic Monster from your deck or GY to your hand. HOPT
local s,id=GetID()
function s.initial_effect(c)
	aux.AddUnionProcedure(c,s.unfilter)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.IsUnionState)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
--Union filter
function s.unfilter(c)
	return c:IsMonster() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
--E1
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return e:GetHandler():GetEquipTarget():GetAttack()>=700
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--Lower atk by 700, destroy faceup card
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	local tc=Duel.GetFirstTarget()
	if ec:UpdateAttack(-700,nil,c)==-700 and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--e2
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.filter(c)
	return c:IsMonster() and c:IsRace(RACE_PSYCHIC)
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