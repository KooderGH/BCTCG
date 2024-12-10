--Mighty Bomburr
--Scripted by Konstak & poka-poka e7
--Effect
-- (1) Cannot be tributed.
-- (2) When this card is Summoned: For each EARTH Machine monster you control, Target 1 card your opponent controls; Destroy those targets.
-- (3) When this card is destroyed: You can add one EARTH Machine Type monster from your Deck to your Hand.
-- (4) Unaffected by Zombie type Monster effect
local s,id=GetID()
function s.initial_effect(c)
    --cannot be tributed
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UNRELEASABLE_SUM)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e2)
    --Summon and destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetTarget(s.smtg)
    e3:SetOperation(s.smop)
    e3:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --Destroy and add machine
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetTarget(s.srtg)
    e6:SetOperation(s.srop)
    e6:SetCountLimit(1)
    c:RegisterEffect(e6)
	--This card is immune to Zombie effects
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(s.immuneval)
	c:RegisterEffect(e7)
end
--Summon and destroy
function s.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end
function s.smtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    local gt=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return gt>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,gt,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,gt,gt,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.smop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if #tg>0 then
        Duel.Destroy(tg,REASON_EFFECT)
    end
end
--Destroy and add function
function s.filter2(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Anti Zombie
function s.immuneval(e,te)
    return te:GetHandler():IsRace(RACE_ZOMBIE)
end