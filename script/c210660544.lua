--Kyosaka Nanaho
--Scripted by Gideon, Link Precedure by Konstak
--Effect
-- Link Monster ↙⬇↘	
-- 3 Monsters
-- (1) Cannot be returned to hand or banished.
-- (2) Cannot be targeted by card effects. This effect cannot be negated.
-- (3) When this card is Special Summoned: Look at your opponent's hand; Banish 1 card from their hand and all cards with that same name from their hand/deck face-down.
-- (4) Once while this card is face-up on the field: If it would be destroyed; gain 1000 ATK instead.
-- (5) This card can attack your opponents monsters once each.
-- (6) If this card is in your GY: You can banish 3 cards from top of your deck facedown; Add this card to your hand.
local s,id=GetID()
function s.initial_effect(c)
    --(1)Start
    c:EnableReviveLimit()
    --Link Summon Procedure
	Link.AddProcedure(c,s.matfilter,3,3)
    --(1)Finish
    --(2)Start
    --Cannot be returned to hand
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_TO_HAND)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Cannot banish
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e2)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --(3)Finish
    --(4)Start
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetTarget(s.handtg)
    e4:SetOperation(s.handop)
    c:RegisterEffect(e4)
    --(4)Finish
    --(5)Start
    --Once while this card is face-up on the field: If it would be destroyed; gain 1000 ATK instead.
    local e5=Effect.CreateEffect(c)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(s.desreptg)
    c:RegisterEffect(e5)
    --(5)Finish
    --(6)Start
    --This card can attack your opponents monsters once each.
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_ATTACK_ALL)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --(6)Finish
    --(7)Start
    --Add this card from the GY to your hand
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,0))
    e7:SetCategory(CATEGORY_TOHAND)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_GRAVE)
    e7:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e7:SetCost(s.thcost)
    e7:SetTarget(s.thtg)
    e7:SetOperation(s.thop)
    c:RegisterEffect(e7)
end
--(1) functions
function s.matfilter(c,lc,sumtype,tp)
	return c:IsMonster() and c:IsFaceup()
end
--4
function s.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,1)
	--Neither player can activate in response
	Duel.SetChainLimit(aux.FALSE)
end
function s.handop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local hg=g:Select(tp,1,1,nil)
	Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)
	local rg=Group.CreateGroup()
	for tc in hg:Iter() do
		if tc:IsLocation(LOCATION_REMOVED) then
			local tpe=tc:GetType()
			if (tpe&TYPE_TOKEN)==0 then
				rg:Merge(Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_HAND,nil,tc:GetCode()))
			end
		end
	end
	if #rg>0 then
		Duel.BreakEffect()
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
--5
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
	c:RegisterEffect(e1)
	return true
end
--7
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end