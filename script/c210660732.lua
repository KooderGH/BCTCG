--Ninja Girl Tomoe
--By Gideon
-- (1) When a monster effect is activated in your opponent's hand (Quick Effect): You can send this card from your hand to the GY; negate the activation, and if you do, return that card to their hand (if possible). For the rest of this turn after this card resolves, your opponent cannot activate cards, or the effects of cards, with the same name. You can only use this effect of "Ninja Girl Tomoe" once per turn.
-- (2) FLIP: You can draw 2 cards, then discard 1 card.
-- (3) If this card is destroyed by battle; Add 1 monster from your deck to your hand.
local s,id=GetID()
function s.initial_effect(c)
	--Negate Handtrap (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.opp)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local relation=rc:IsRelateToEffect(re)
	if chk==0 then return rc:IsAbleToHand(tp)
		or (not relation and Duel.IsPlayerCanSendtoHand(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if relation then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.opp(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoHand(tc,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetValue(s.aclimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end