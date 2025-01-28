--Wonder MOMOCO
--Scripted by Gideon. Got help from naim and pyrQ.
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. You can Special Summon this card from your Hand, GY, or Banish Zone when there is 5 or more Monster's banished in your Banish Zone with different monster types. Then move this card to your Extra Monster Zone. You can only activate this effect once per turn.
-- (2) Cannot be returned to hand.
-- (3) Cannot be targeted by card effects.
-- (4) Once per your turn (Quick): You can negate all face-up card effects on your opponent side of the field until the End Phase.
-- (5) During either player turn: You can Target 1 card on the field for each 2 cards you have in your Banish Zone; Banish them.
-- (6) Once per turn (Igntion): You can banish 4 cards from your GY: Draw 1 card.
-- (7) If there is 35 or more card's total counting from both player's Banish Zone's, You can activate this effect (Igntion): Set your opponent's LP to 0.
-- (8) When this card is destroyed and set to the GY; Add 4 cards from your Banish Zone to your Deck, shuffle the deck, then draw 1 card.
-- (9) Cannot be destroyed by battle, if you control 3 monster with different Type
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
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
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
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
	-- Negate effect on summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(s.negateop)
	c:RegisterEffect(e11)
    --(1)Finish
    --(2)Start
    --Cannot be returned to hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --(3)Finish
    --(4)Start
    --Negate the effects of opp
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,0))
    e6:SetCategory(CATEGORY_DISABLE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetTarget(s.distg)
    e6:SetOperation(s.disop)
    c:RegisterEffect(e6)
    --(4)Finish
    --(5)Start
    --Banish
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.rmcon)
	e7:SetTarget(s.rmtg)
	e7:SetOperation(s.rmop)
	e7:SetCountLimit(1)
	c:RegisterEffect(e7)
    --(5)Finish
    --(6)Start
    --Banish 3 GY Draw 1
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,2))
    e8:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetCountLimit(1)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCost(s.redrawcost)
    e8:SetTarget(s.redrawtarget)
    e8:SetOperation(s.redrawop)
    c:RegisterEffect(e8)
    --(6)Finish
    --(7)Start
    --Set opp LP to 0
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,3))
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetCountLimit(1)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCondition(s.wincon)
    e9:SetOperation(s.winop)
    c:RegisterEffect(e9)
    --(7)Finish
    --(8)Start
    --When destroyed, shuffle 4 banish, draw 1
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,4))
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e10:SetCode(EVENT_TO_GRAVE)
    e10:SetCountLimit(1)
    e10:SetCondition(s.shufflecon)
    e10:SetTarget(s.shufftarget)
    e10:SetOperation(s.shuffop)
    c:RegisterEffect(e10)
    --(8)Finish
	--(9) Start
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(s.indcon)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--(9) Finish
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
    local lftezm=Duel.CheckLocation(tp,LOCATION_EMZONE,0) and 0x20 or 0
    local rgtemz=Duel.CheckLocation(tp,LOCATION_EMZONE,1) and 0x40 or 0
    if (lftezm>0 or rgtemz>0) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~(lftezm|rgtemz))
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
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0) >= 2
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local gt = math.floor(Duel.GetFieldGroupCount(tp, LOCATION_REMOVED, 0) / 2)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
    if chk==0 then return gt > 0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectTarget(tp, Card.IsAbleToRemove,tp,LOCATION_ONFIELD, LOCATION_ONFIELD,1,gt,nil)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE,g,#g,0,0)
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
	if chk==0 then return Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_GRAVE,0,4,4,nil)
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
    return Duel.GetMatchingGroupCount(s.banishwinfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)>=35
end 
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,0)
end
--(8)
function s.dsfilter(c)
	return c:IsAbleToDeck()
end
function s.shufflecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
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
	if ct==4 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--(1) negate effect on summon
function s.negateop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e2)
end
--(9)
function s.indcon(e)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    return g:GetClassCount(Card.GetRace)>=3
end