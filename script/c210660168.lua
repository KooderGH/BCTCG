--Asiluga
--Scripted by Gideon with some help from Naim. Opperations are a pain sometimes!
--Effect
-- (1) Can't be destroyed by battle.
-- (2) Any monster on your opponents side of the field that is Normal Summoned, Flip Summoned or Special Summoned is changed to Defense Position.
-- (3) When this card is Summoned; You can add one Fiend monster with 1000 or less ATK from your deck to your hand.
local s,id=GetID()
function s.initial_effect(c)
	--Cannot be destroyed by Battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	e2:SetCondition(s.hcondition)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(s.tg)
	e5:SetOperation(s.op)
	e5:SetCountLimit(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end
--E2-E4 Functions
function s.hcondition(e,tp,eg,ep,ev,re,r,rp)
    return eg and eg:IsExists(aux.FaceupFilter(Card.IsControler,1-tp),1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,#eg,0,0)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) and c:IsControler(1-tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(s.filter,nil,e,tp)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
--E5-E7 Functions
function s.sfilter(c)
	return c:IsMonster() and c:IsRace(RACE_FIEND) and c:IsAttackBelow(1000) and c:IsAbleToHand()
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end