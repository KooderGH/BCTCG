--Awakened Ururun
--Scripted by Kooder
--Effects:
-- This card can be Ritual Summoned with the Ritual Spell Card, "Awaken thy Cat!".
-- If this card is Ritual Summoned using only Level 4 Monster's; Add 1 card from your Deck to your hand.
-- Unafected by spell/trap effects and activated effects from any monster who's original level/rank is lower than this card's current level.
-- For each face-up monster with levels on the field: This card gains 100 ATK/DEF x the levels the monster(s) have.
-- This monster's Level is increased by the Level of monsters it destroys by battle.
-- If this card is destroyed while it's Level is 13 or higher; Add 1 Spell or Trap card from your GY to your hand.
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
-- When summoned with only Level 4 Monsters, Add 1 card from your Deck to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.matcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
-- Immune against Spell/Trap and monsters that have lower level/rank effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
-- 100 ATK/DEF for each level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(s.value)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e5)
-- Increase level
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(s.condition)
	e6:SetOperation(s.operation)
	c:RegisterEffect(e6)
-- Add 1 Spell or Trap card
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LVCHANGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.thcon1)
	e7:SetTarget(s.thtg1)
	e7:SetOperation(s.thop1)
	c:RegisterEffect(e7)
end
function s.lv4filter(c)
	return c:GetLevel()==4
end
function s.thfilter(c)
    return c:IsAbleToHand()
end
function s.idkfilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK) then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
function s.matcheck(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local lg=g:Filter(s.lv4filter,nil,nil)
	if #g==#lg then
		c:RegisterFlagEffect(1,RESET_EVENT|RESETS_STANDARD&~(RESET_TOFIELD|RESET_LEAVE|RESET_TEMP_REMOVE),0,1)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRitualSummoned() and c:GetFlagEffect(1)~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.efilter(e,te)
	if te:IsSpellTrapEffect() then return true
	else return s.idkfilter(e,te) end
end
function s.thfilter1(c)
    return c:IsSpellTrap() and c:IsAbleToHand()
end
function s.value(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLevel)*100
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle() and e:GetHandler():IsFaceup()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local lvl=bc:GetLevel()
	if lvl>0 then
		if c:GetFlagEffect(id)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(lvl)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_DISABLE,0,0)
			e:SetLabelObject(e1)
			e:SetLabel(lvl)
		else
			local pe=e:GetLabelObject()
			local ct=e:GetLabel()+lvl
			e:SetLabel(ct)
			pe:SetValue(ct)
		end
	end
end
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetPreviousLevelOnField()
	if lv>=13 then
		return c:IsPreviousLocation(LOCATION_MZONE)
	end
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end