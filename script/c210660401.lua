--Volta
--Scripted by Gideon
-- (1) If you control no monsters or If you control a Fairy monster; You can Special Summon this card from your Hand.
-- (2) When this card is summoned; You can add one Fairy monster with 1200 ATK/DEF from your deck to your hand except "Volta".
-- (3) (Quick) You can remove 3 Fog Counter(s) from the field to Special summon One Fairy monster from your Hand. You can only activate this effect of "Volta" once per turn.
-- (4) If this card is removed from the field while having a Fog Counter on it; You can add one Fairy monster from your deck or GY to your hand. You can only activate this effect of "Volta" once per turn.
-- (5) When monster(s) are Special Summoned: Target 1 of those monsters; Place 2 Fog Counter(s) on it.
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    --Search on Summon (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(s.tg)
    e2:SetOperation(s.op)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --SS Hand (3)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
    e5:SetCost(s.spcost)
    e5:SetTarget(s.sphandtg)
    e5:SetOperation(s.sphandpop)
    c:RegisterEffect(e5)
    --Recovery on death with counters (4)
    --register a flag
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_LEAVE_FIELD_P)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetOperation(s.regop)
    c:RegisterEffect(e0)
    --search
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCondition(s.reccon)
    e6:SetTarget(s.rectg)
    e6:SetOperation(s.recpop)
    e6:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
    e6:SetLabelObject(e0)
    c:RegisterEffect(e6)
    --When a monster is Special Summoned; Place 2 Fog Counter(s) on the field. (5)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,2))
    e7:SetCategory(CATEGORY_COUNTER)
    e7:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTarget(s.cctg)
    e7:SetOperation(s.ccoperation)
    c:RegisterEffect(e7)
end
--Fog counter
s.counter_place_list={0x1019}
--e1
function s.specialfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--e2/e3/e4
function s.filter(c)
	return c:IsMonster() and c:IsAttack(1200) and c:IsDefense(1200) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e5
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,3,REASON_COST)
end
function s.sfilter(c,e,tp)
	return c:IsMonster() and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sphandtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.sphandpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e6
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCounter(0x1019)>=1 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()==1
end
function s.lfilter(c)
	return c:IsMonster() and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.recpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.lfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e7
function s.ccfilter(c,e,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsCanBeEffectTarget(e)
end
function s.cctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.ccfilter(chkc,e,tp) and chkc:IsCanAddCounter(0x1019,2) end
	if chk==0 then return eg:IsExists(s.ccfilter,1,nil,e,tp) and not eg:IsContains(e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,s.ccfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function s.ccoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x1019,2) then
		tc:AddCounter(0x1019,2)
	end
end