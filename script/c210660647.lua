--Huntress Terun
--Scripted By Gideon (1,2) and poka-poka (3,4,5) and naim (debug touches)
-- (1) You can Normal Summon/Set this card without Tribute.
-- (2) When this card is Tribute Summoned; You can Special Summon the monsters that were used for this card Tribute and set their levels to 7.
-- (3) If you control 3 or more Level 7 LIGHT Spellcaster monsters: You can target 1 card on your opponent side of the field, 1 card in their hand randomly, and 1 card in their GY; Banish those targets.
-- (4) If this card is Tributed by a Spellcaster; Negate all current effect's on the field until the end phase.
-- (5) If this card is Special Summoned; Add 1 Spell from your deck to your hand.
-- (6) You can only use each effect of "Huntress Terun" once per turn and used only once while it is face-up on the field.
-- (7) You can only control 1 Huntress Terun
local s,id=GetID()
function s.initial_effect(c)
	--Can only control one
	c:SetUniqueOnField(1,0,id)
	--summon & set with no tribute (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
    --Tribute Summoned; You can Special Summon the monsters that were used for this card Tribute and set their levels to 7. (2)
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcond)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--Banish 1 card each from opponent's field, hand, and GY (3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(s.rmcon)
	e4:SetOperation(s.rmop)
	c:RegisterEffect(e4)
	--Negate all current effects if Tributed by a Spellcaster's effect or summon (4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(s.negcon)
	e5:SetOperation(s.negop)
	e5:SetCountLimit(1,{id,2})
	c:RegisterEffect(e5)
	--Special Summoned; Add 1 Spell from your deck to your hand. (5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,3))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(s.thtg)
	e6:SetOperation(s.thop)
	e6:SetCountLimit(1,{id,3})
	c:RegisterEffect(e6)
end
--E1
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--e2
function s.spcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=e:GetHandler():GetMaterial()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	if chk==0 then
		return ft>0 and ft>=mg:FilterCount(s.spfilter,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,#mg,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial():Filter(s.spfilter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	if #mg>0 and ft>#mg and Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP) then
		for tc in mg:Iter() do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(7)
			tc:RegisterEffect(e1,true)
		end
	end
end
--E3: Banish 1 card each from opponent's field, hand, and GY
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	-- Check for at least 3 LIGHT Spellcaster monsters with Level 7 or higher on the field (OH YEAH It's worked,now)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local count=0
	for tc in aux.Next(g) do
		if tc:IsLevelAbove(7) and tc:IsAttribute(ATTRIBUTE_LIGHT) and tc:IsRace(RACE_SPELLCASTER) then
			count = count + 1
		end
	end
	return count >= 3
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local availableTargets = #g1 + #g2 + #g3
	if availableTargets == 0 then
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,availableTargets,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g=Group.CreateGroup()
	-- Field selection by player
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		g:Merge(sg1)
	end
	-- Hand selection randomly
	if #g2>0 then
		g:Merge(g2)
	end
	-- Graveyard selection by player
	if #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:Select(tp,1,1,nil)
		g:Merge(sg3)
	end
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
--E4: Negate all current effects if Tributed by a Spellcaster's effect or summon
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (r==REASON_SUMMON or r==REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():GetReasonCard():IsRace(RACE_SPELLCASTER)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
-- E5:Special Summoned; Add 1 Spell from your deck to your hand.
function s.thfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- E6: You can only use each effect once per turn and only once while face-up on the field.
function s.efcon(e)
    return e:GetHandler():IsFaceup()
end