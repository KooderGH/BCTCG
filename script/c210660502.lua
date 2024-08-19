--Myrcia
--Scripted By Gideon
-- (1) When this card is Normal Summoned; you can Special Summon one Level 4 or lower Spellcaster from your hand.
-- (2) When this card is Tributed: You can Target 1 card per 2 levels this card had on the field; Negate their effects.
-- (3) When an Spellcaster is Tributed except "Myrcia"; You can draw 1 card.
-- (4) When a monster your opponent control's is Tribute summoned: You can reduce it's level to 1; Add the difference to this card.
-- (5) You can only use each above effect of "Myrcia" once per turn and used only once while it is face-up on the field.
-- (6) If this card is in your GY: You can banish 3 Spell cards from your GY; Special Summon this card. You can only use this effect of "Myrcia" once per duel.
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
    --Tribute (2)
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_NEGATE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.reltg)
	e3:SetOperation(s.relop)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
    --Tribute draw (3)
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,2})
	e4:SetCondition(s.drawcon)
	e4:SetTarget(s.drawtg)
	e4:SetOperation(s.drawpop)
	c:RegisterEffect(e4)
    --When a monster your opponent control's is Tribute summoned: You can reduce it's level to 1; Add the difference to this card.
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetCategory(CATEGORY_LVCHANGE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,{id,3})
    e5:SetCondition(s.levelcon)
    e5:SetTarget(s.leveltarget)
    e5:SetOperation(s.levelop)
    c:RegisterEffect(e5)
    --SS from GY once per duel.
    local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,4))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_GRAVE)
    e6:SetCountLimit(1,{id,3},EFFECT_COUNT_CODE_DUEL)
	e6:SetCost(s.gravecost)
	e6:SetTarget(s.spgravetg)
	e6:SetOperation(s.sgravepop)
	c:RegisterEffect(e6)
end
--e1
function s.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e2
function s.opfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
    local ct=e:GetHandler():GetPreviousLevelOnField()//2
	if chk==0 then return Duel.IsExistingTarget(s.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,s.sefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,nil,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,ct,0,0)
end
function s.refilter(c,e)
	return ((c:IsFaceup() and not c:IsDisabled()) or c:IsType(TYPE_TRAPMONSTER)) and c:IsRelateToEffect(e)
end
function s.relop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc=tg:GetNext()
	end
end
--e4
function s.spcfilter(c,tp)
	return c:GetPreviousRaceOnField()&RACE_SPELLCASTER==RACE_SPELLCASTER and not c:IsCode(id)
end
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spcfilter,1,nil,tp)
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drawpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--e5
function s.tribfilter(c,tp)
    return c:IsSummonType(SUMMON_TYPE_TRIBUTE) and c:IsSummonPlayer(tp) and c:IsLevelAbove(1)
end
function s.levelcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.tribfilter,nil,1,1-tp)
end
function s.leveltarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return eg:IsExists(s.tribfilter,1,nil,1-tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=eg:FilterSelect(tp,s.tribfilter,1,1,nil,1-tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,nil,2,0,0)
end
function s.levelop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local lv=1
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        lv=tc:GetLevel()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_LEVEL)
        e2:SetValue(lv-1)
        e2:SetReset(RESET_EVENT|RESETS_STANDARD)
        c:RegisterEffect(e2)
    end
end
--e6
function s.costfilter(c,tp)
	return c:IsSpell() and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c) 
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function s.gravecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler(),tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.spgravetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sgravepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end()
end