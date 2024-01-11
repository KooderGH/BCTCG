--Mighty Bomburr
--Scripted by Konstak
--Effect
-- (1) Cannot be Normal Summoned/Set. Can be Special Summoned if you control no Monsters OR if you control at least one EARTH Machine monster.
-- (2) Cannot be tributed.
-- (3) When this card is Summoned: For each EARTH Machine monster you control, Target 1 card your opponent controls; Destroy those targets.
-- (4) When this card is destroyed: You can add one EARTH Machine Type monster from your Deck to your Hand.
-- (5) You can only activate each effect of "Mighty Bomburr" once per turn.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --Special Summon this card
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
    --cannot be tributed
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
    --Summon and destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetTarget(s.smtg)
    e4:SetOperation(s.smop)
    e4:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e6)
    --Destroy and add machine
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,1))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetTarget(s.srtg)
    e7:SetOperation(s.srop)
    e7:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e7)
end
--Filter and Special summon function
function s.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 or Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--Summon and destroy
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
