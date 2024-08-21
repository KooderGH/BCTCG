--Lilin
--Scripted By Gideon
-- (1) This card gains 500 ATK/DEF for each Level 5 or higher LIGHT Spellcaster on the field.
-- (2) When this card is Tribute Summoned; Add 3 level's to all monster's you control.
-- (3) When this card is Tributed; Destroy all monster's your opponent control. You cannot attack the turn you use this effect.
-- (4) You can Tribute 1 LIGHT Spellcaster you control except "Lilin"; Add up to 2 Level 4 or lower Spellcaster's from your deck to your hand.
-- (5) You can only use each effect of "Lilin" once per turn and used only once while it is face-up on the field.
-- (6) Has piercing battle damage.
local s,id=GetID()
function s.initial_effect(c)
    --500 ATK/DEF for each Level 5 or higher LIGHT Spellcaster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --When tribute Summoned; Add levels
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCountLimit(1,id)
    e3:SetCondition(s.thcon)
    e3:SetTarget(s.leveltg)
    e3:SetOperation(s.levelop)
    c:RegisterEffect(e3)
    --When tributed, destroy all monsters opponent controls
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,{id,1})
	e4:SetTarget(s.reltg)
	e4:SetOperation(s.relop)
	c:RegisterEffect(e4)
    --Tribute 1 LIGHT Spellcaster you control except "Lilin"; Add up to 2 Level 4 or lower Spellcaster's
    local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,{id,2})
    e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e5:SetRange(LOCATION_MZONE)
	e5:SetCost(s.cost)
	e5:SetTarget(s.ttarget)
	e5:SetOperation(s.topp)
	c:RegisterEffect(e5)
    --Piercing
    local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
end
--e1
function s.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(5) and c:IsRace(RACE_SPELLCASTER)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.cfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*500
end
--e3
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.filter(c)
	return c:IsFaceup() and c:HasLevel()
end
function s.leveltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.levelop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
--e4
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.relop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
--e5
function s.sfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function s.tributefilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and (not c:IsCode(id))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.tributefilter,1,false,nil,nil,tp) and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,2,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.tributefilter,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.ttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.topp(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK,0,2,2,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end