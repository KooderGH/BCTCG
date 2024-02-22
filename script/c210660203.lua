--Kachi-Kachi
--Scripted by "Konstak"
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) If a WIND monster is sent to your GY; You can Special Summon this card from your hand.
-- (3) You can only use 1 of these effects of "Kachi-Kachi" per turn, and only once that turn.
-- * When this card is Special Summoned: Add 1 WIND Machine monster from your GY to your Hand.
-- * When this card is sent to the GY: Add 1 WIND Machine monster from your Deck to your Hand.
local s,id=GetID()
function s.initial_effect(c)
    --self destroy
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    e1:SetCondition(s.sdcon)
    c:RegisterEffect(e1)
    --Special Summon itself
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    --summon and add one WIND machine monster from your deck to your hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,id)
    e3:SetTarget(s.sstg)
    e3:SetOperation(s.ssop)
    c:RegisterEffect(e3)
    --once sent to the graveyard destroy S/T based on the number of WIND machine you control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,id)
    e4:SetTarget(s.rmtg)
    e4:SetOperation(s.rmop)
    c:RegisterEffect(e4)
end
--Self Destroy Function
function s.sdfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.sdcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--SS Function
function s.spfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(s.spfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--Add when SS Search function
function s.specialfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.specialfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Add when sent to GY function
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.specialfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end