--Gaia the Creator
--Scripted by Gideon, Link Precedure by Konstak
--Effect
-- Link Monster ↙⬇↘	
-- 3 Monsters
-- (1) Cannot be returned to hand or banished.
-- (2) Cannot be targeted by card effects. This effect cannot be negated.
-- (3) While you control this card, you cannot Normal Summon / Set Monsters. This effect cannot be negated.
-- (4) Neither player can activate the effects of monsters in the hand. This effect cannot be negated.
-- (5) Inflict's Piercing Damage. This effect cannot be negated.
-- (6) All effects that add or subtract ATK/DEF are reversed. This effect cannot be negated.
-- (7) When this card destroys an opponent's monster by battle and sends it to the GY: Special Summon that monster to your field. This effect cannot be negated.
-- (8) When this card leaves the field: You can target 1 Monster in either GY; Special Summon it
-- (9) During the battle phase: This card is unaffected by other card effects.
local s,id=GetID()
function s.initial_effect(c)
    --(1)Start
    c:EnableReviveLimit()
    --Link Summon Procedure
	Link.AddProcedure(c,s.matfilter,3,3)
    --(1)Finish
    --(2)Start
    --Cannot be returned to hand
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_CANNOT_TO_HAND)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Cannot banish
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e2)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --(3)Finish
    --(4)Start
    --While you control this card, you cannot Normal Summon / Set Monsters.
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_SUMMON)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetTargetRange(1,0)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e6)
    --(4)Finish
    --(5)Start
    --Neither player can activate the effects of monsters in the hand. This effect cannot be negated.
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetCode(EFFECT_CANNOT_ACTIVATE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(1,1)
    e7:SetValue(s.aclimit)
    c:RegisterEffect(e7)
    --(5)Finish
    --(6)Start
    --Inflict's Piercing Damage. This effect cannot be negated.
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_PIERCE)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e8)
    --(6)Finish
    --(7)Start
    --Reverse trap
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetCode(EFFECT_REVERSE_UPDATE)
    e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    c:RegisterEffect(e9)
    --(7)Finish
    --(8)Start
    --Goyo on drugs
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,0))
    e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e10:SetCode(EVENT_BATTLE_DESTROYING)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e10:SetCondition(aux.bdogcon)
    e10:SetTarget(s.battletg)
    e10:SetOperation(s.battlepop)
    c:RegisterEffect(e10)
    --(8)Finish
    --(9)Start
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(id,1))
    e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e11:SetCode(EVENT_LEAVE_FIELD)
    e11:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e11:SetCondition(s.thcon)
    e11:SetTarget(s.gtarget)
    e11:SetOperation(s.gactivate)
    c:RegisterEffect(e11)
    --(9)Finish
    --(10)Start
    --During the battle phase: This card is unaffected by other card effects.
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_IMMUNE_EFFECT)
    e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCondition(s.imcon)
    e12:SetValue(1)
    c:RegisterEffect(e12)
end
--(1) functions
function s.matfilter(c,lc,sumtype,tp)
	return c:IsMonster() and c:IsFaceup()
end
--(5)
function s.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER)
end
--(8)
function s.battletg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function s.battlepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--(9)
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.gtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.gactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--(10)
function s.imcon(e)
	return Duel.GetCurrentPhase()==PHASE_BATTLE
end