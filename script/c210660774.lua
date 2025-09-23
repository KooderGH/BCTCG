--Mech Patrol Axel
--Scripted by Kooder
--Effects:
-- If this card is Summoned; You can add 1 Level 4 or lower DARK Warrior Monster with 1900 or less ATK from your Deck or GY to your hand.
-- You can Tribute this card; Set 1 Trap card from your Deck to the Field. You can activate that Trap card this turn.
-- If this card deals battle damage; Your opponent declares either Spell or Trap, then you can Set 1 card of that type directly from your deck to your side of the field.
-- If you control 4 or more DARK Warrior monsters, you can activate this effect: Destroy 1 card your opponent controls. Your opponent cannot take battle damage the turn you use this effect.
-- You can only activate each of "Mech Patrol Axel" effects Once per turn.
local s,id=GetID()
function s.initial_effect(c)
-- Add 1 Monster from Deck or GY to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
-- Tribute then set 1 Trap card from deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_DECK|LOCATION_MZONE)
	e4:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e4:SetCost(Cost.SelfTribute)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
-- Set 1 Spell/Trap after dealing damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(s.setcon1)
	e5:SetTarget(s.settg1)
	e5:SetOperation(s.setop1)
	c:RegisterEffect(e5)
-- If 4 or more DH, destroy a card
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,{id,3},EFFECT_COUNT_CODE_OATH)
	e6:SetLabel(4)
	e6:SetCondition(s.dhcount)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)
end
function s.thfilter(c)
	return c:IsMonster() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand() and c:IsAttackBelow(1900) and c:IsLevelBelow(4)
end
function s.setfilter(c,e,tp,ft)
	return c:IsTrap() and c:IsSSetable()
end
function s.setfilter1(c)
	return c:IsSSetable()
end
function s.setfilter2(c,typ)
	return c:GetType()==typ and c:IsSSetable()
end
function s.dhfilter(c)
	return c:IsFaceup() and c:IsCode(210660481) or c:IsCode(210660698) or c:IsCode(210660634) or c:IsCode(210660431) or c:IsCode(210660226) or c:IsCode(210660261) or c:IsCode(210660194) or c:IsCode(210660774) or c:IsCode(210660212) or c:IsCode(210660195) or c:IsCode(210660196) or c:IsCode(210660533)
end
function s.dhcount(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.dhfilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,nil):GetFirst()
	Duel.SSet(tp,sc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	sc:RegisterEffect(e1)
end
function s.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.settg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter1,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
	local op=Duel.SelectOption(1-tp,71,72)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=nil
	if op==0 then g=Duel.SelectMatchingCard(tp,s.setfilter2,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
	else g=Duel.SelectMatchingCard(tp,s.setfilter2,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP) end
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
