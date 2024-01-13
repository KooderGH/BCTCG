--Mighty Sphinx Korps
--Scripted by Konstak
--Effect
-- (1) You can Special Summon this card from your hand when your LP are 6000 or lower.
-- (2) Cannot be tributed.
-- (3) When this card is Summoned: You can reveal as many Earth Machine type monsters in your hand; Draw from your deck equal to the number of cards your revealed. At the end phase: You must discard your entire hand.
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
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
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
	e4:SetCountLimit(1,id)
    --e4:SetCost(s.shdcost)
	e4:SetTarget(s.shdtg)
	e4:SetOperation(s.shdop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function s.spcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<=6000
end

function s.shdfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function s.shdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return Duel.IsExistingMatchingCard(s.shdfilter,tp,LOCATION_DECK,0,h1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.shdop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoDeck(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,h1,REASON_EFFECT)
end
