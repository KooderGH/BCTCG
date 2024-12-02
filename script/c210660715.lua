--Mighty Sphinx Korps
--Scripted by Konstak and Gideon. 
--Effect
-- (1) You can Special Summon this card from your hand when your LP are 6000 or lower.
-- (2) Cannot be tributed.
-- (3) When this card is Summoned: You can reveal as many Earth Machine type monsters in your hand; Draw from your deck equal to the number of cards your revealed. At the end phase: Shuffle your deck and send your entire hand at the bottom of your deck.
-- (4) When this card is destroyed, you can select 3 Earth Machine Type monsters from your GY; Shuffle them to your deck, then, Draw 1 card.
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon this card (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetCountLimit(1)
    c:RegisterEffect(e1)
    --cannot be tributed (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UNRELEASABLE_SUM)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e3)
    --Summon Effect (3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetCountLimit(1)
    e4:SetCost(s.shdcost)
    e4:SetTarget(s.shdtg)
    e4:SetOperation(s.shdop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,1))
    e7:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetTarget(s.gravtg)
    e7:SetOperation(s.gravop)
    c:RegisterEffect(e7)
end
function s.spcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<=6000
end
--E4
function s.cfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic()
end
function s.shdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
    local hg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND,0,nil)
    local ct=1
    if #hg>=2 then
        for i=2,#hg do
            if Duel.IsPlayerCanDraw(tp,i) then
                ct=ct+1
            end
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,ct,nil)
    e:SetLabel(#g)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function s.shdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function s.shdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_PHASE|PHASE_END)
    e1:SetOperation(s.disop)
    Duel.RegisterEffect(e1,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(e:GetOwnerPlayer(),LOCATION_HAND,0)
    Duel.ShuffleDeck(tp)
    Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
end
--e7
function s.gfilter(c)
	return c:IsMonster() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToDeck()
end
function s.gravtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(s.gfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.gfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.gravop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
