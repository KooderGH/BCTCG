--Wonder MOMOCO
--Scripted by Gideon. Got help from naim and pyrQ.
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. You can Special Summon this card from your Hand, GY, or Banish Zone when there is 5 or more Monster's banished in your Banish Zone with different monster types. Then move this card to your Extra Monster Zone. 
-- (2) Cannot be returned to hand, banished, or tributed.
-- (3) Cannot be targeted by card effects.
-- (4) Once per your turn (Quick): You can negate all face-up card effects on your opponent side of the field until the End Phase.
-- (5) During either player turn: You can Target 1 card on the field for each 2 cards you have in your Banish Zone; Banish them.
-- (6) Once per turn (Igntion): You can banish 3 cards from your GY: Draw 1 card.
-- (7) If there is 30 or more card's total counting from both player's Banish Zone's, You can activate this effect (Igntion): Set your opponent's LP to 0.
-- (8) When this card is destroyed; Add 4 cards from your Banish Zone to your Deck, shuffle the deck, then draw 1 card.
local s,id=GetID()
function s.initial_effect(c)
--(1)Start
	--Makes it unsummonable via normal
	c:EnableUnsummonable()
	--Cannot be SS by other ways other then it's own effect via above and this function
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--SS from Hand / GY / Banish
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCondition(s.ssummoncon)
	c:RegisterEffect(e1)
	--Move to EMZ
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(s.mvop)
    c:RegisterEffect(e2)
	--Summon cannot be disabled (Hopefully)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--(1)Finish
	--(2)Start
	--Cannot be Tributed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--Cannot be returned to hand
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	--Cannot banish
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e7)
	--(2)Finish
	--(3)Start
	--Cannot be targeted (self)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--(3)Finish
	--(4)Start
	--Negate the effects of opp
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,0))
	e9:SetCategory(CATEGORY_DISABLE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetTarget(s.distg)
	e9:SetOperation(s.disop)
	c:RegisterEffect(e9)
	--(4)Finish
	--(5)Start
	--Banish
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,1))
	e10:SetCategory(CATEGORY_REMOVE)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTarget(s.rmtg)
	e10:SetOperation(s.rmop)
	e10:SetCountLimit(1)
	c:RegisterEffect(e10)
	--(5)Finish
	--(6)Start
	--Banish 3 GY Draw 1
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,2))
	e11:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetCountLimit(1)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCost(s.redrawcost)
	e11:SetTarget(s.redrawtarget)
	e11:SetOperation(s.redrawop)
	c:RegisterEffect(e11)
	--(6)Finish
	--(7)Start
	--Set opp LP to 0
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,3))
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCountLimit(1)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCondition(s.wincon)
	e12:SetOperation(s.winop)
	c:RegisterEffect(e12)
	--(7)Finish
	--(8)Start
	--When destroyed, shuffle 4 banish, draw 1
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(id,4))
	e13:SetCode(EVENT_DESTROYED)
	e13:SetCountLimit(1)
	e13:SetTarget(s.shufftarget)
	e13:SetOperation(s.shuffop)
	c:RegisterEffect(e13)
	--(8)Finish
end
--(1) functions
function s.banishfilter(c)
    return c:IsFaceup()
end
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(s.banishfilter,tp,LOCATION_REMOVED,0,nil)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and #g>=5 and g:GetClassCount(Card.GetRace)>=5
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1))
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    if (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1)) then
        local lftezm=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,5) and 0x20 or 0
        local rgtemz=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,6) and 0x40 or 0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~ZONES_EMZ|(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--(4) functions
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsNegatable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsNegatable,tp,0,LOCATION_ONFIELD,c)
	if #g==0 then return end
	for tc in g:Iter() do
		--Negate effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
--(5)
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
    local gt=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)//2
    if chk==0 then return gt>0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,gt,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,gt,gt,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if #tg>0 then
        Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
    end
end
--(6)
function s.discfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function s.redrawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.redrawtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.redrawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--(7)
function s.banishwinfilter(c)
    return c:IsFaceup() or c:IsFacedown()
end
function s.wincon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroup(s.banishwinfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)>=30
end 
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,0)
end
--(8)
function s.dsfilter(c)
	return c:IsAbleToDeck()
end
function s.shufftarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.dsfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(s.dsfilter,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.dsfilter,tp,LOCATION_REMOVED,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.shuffop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end