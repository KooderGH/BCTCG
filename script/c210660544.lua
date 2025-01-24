--Kyosaka Nanaho
--Scripted by Gideon, Link Precedure by Konstak
--Effect
-- Link Monster ↙⬇↘	
-- 3 Monsters
-- (1) Cannot be used as Link material.
-- (2) Cannot be returned to hand or banished.
-- (3) Cannot be targeted by card effects. This effect cannot be negated.
-- (4) When this card is Link Summoned using 3 different Attribute: Look at your opponent's hand; Banish 1 card from their hand and all cards with that same name from their hand/deck face-down.
-- (5) Once while this card is face-up on the field: If it would be destroyed; gain 1000 ATK instead.
-- (6) This card can attack your opponents monsters once each.
-- (7) If this card is in your GY: You can banish 3 cards from top of your deck facedown; Add this card to your hand.
-- (9) "During your opponent's end phase: If this is the only face-up monster you control; Target 1 monster in either player's GY; Special Summon it.
local s,id=GetID()
function s.initial_effect(c)
    --(1)Start
    c:EnableReviveLimit()
    --Link Summon Procedure
    Link.AddProcedure(c,s.matfilter,3,3)
    --cannot link material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Cannot be returned to hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_CANNOT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Cannot banish
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e3)
	--Summon cannot be negated
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)
    --Cannot be targeted (self)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Banish from Opp hand.
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,{id,1})
	e5:SetCondition(s.linkcon)
    e5:SetTarget(s.handtg)
    e5:SetOperation(s.handop)
    c:RegisterEffect(e5)
    --Once while this card is face-up on the field: If it would be destroyed; gain 1000 ATK instead.
    local e6=Effect.CreateEffect(c)
    e6:SetCode(EFFECT_DESTROY_REPLACE)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetTarget(s.desreptg)
    c:RegisterEffect(e6)
    --This card can attack your opponents monsters once each.
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_ATTACK_ALL)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    --Add this card from the GY to your hand
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,0))
    e8:SetCategory(CATEGORY_TOHAND)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_GRAVE)
    e8:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e8:SetCost(s.thcost)
    e8:SetTarget(s.thtg)
    e8:SetOperation(s.thop)
    c:RegisterEffect(e8)
	--SS from either GY if this only card you controll
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,1))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(s.gscon)
	e9:SetTarget(s.gstg)
	e9:SetOperation(s.gsop)
	c:RegisterEffect(e9)
end
--(1) functions
function s.matfilter(c,lc,sumtype,tp)
	return c:IsMonster() and c:IsFaceup()
end
--4
function s.linkcon(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    if not c:IsSummonType(SUMMON_TYPE_LINK) then return false end
    local g = c:GetMaterial()
    return #g==3 and g:GetClassCount(Card.GetAttribute)==3
end
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
--e9
function s.gscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,e:GetHandler())==0
end
function s.gstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingTarget(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,0,tp,false,false)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,0,tp,false,false)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.gsop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
