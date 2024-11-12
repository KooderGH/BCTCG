--Gaia the Creator
--Scripted by Gideon, Link Precedure by Konstak
--Effect
-- Link Monster ↙⬇↘	
-- 3 Monsters
-- (1) Cannot be used as Link material.
-- (2) Cannot be returned to hand or banished.
-- (3) Cannot be targeted by card effects. This effect cannot be negated.
-- (4) While you control this card, you cannot Normal Summon / Set Monsters. This effect cannot be negated.
-- (5) Neither player can activate the effects of monsters in the hand. This effect cannot be negated.
-- (6) Inflict's Piercing Damage. This effect cannot be negated.
-- (7) All effects that add or subtract ATK/DEF are reversed. This effect cannot be negated.
-- (8) When this card destroys an opponent's monster by battle and sends it to the GY: Special Summon that monster to your field. This effect cannot be negated.
-- (9) When this card leaves the field: You can target 1 Monster in either GY except "Gaia the Creator": Special Summon it
-- (10) During the battle phase: This card is unaffected by other card effects.
local s,id=GetID()
function s.initial_effect(c)
    --(1)Start
    c:EnableReviveLimit()
    --Link Summon Procedure
    Link.AddProcedure(c,s.matfilter,3,3)
    --cannot link material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Cannot be returned to hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_CANNOT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Cannot banish
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e3)
	--Summon cannot be negated
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)
    --Cannot be targeted (self)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --While you control this card, you cannot Normal Summon / Set Monsters.
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_SUMMON)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetTargetRange(1,0)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e7)
    --Neither player can activate the effects of monsters in the hand. This effect cannot be negated.
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e8:SetCode(EFFECT_CANNOT_ACTIVATE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTargetRange(1,1)
    e8:SetValue(s.aclimit)
    c:RegisterEffect(e8)
    --Inflict's Piercing Damage. This effect cannot be negated.
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_PIERCE)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e9)
    --Reverse trap
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_REVERSE_UPDATE)
    e10:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    c:RegisterEffect(e10)
    --Goyo on drugs
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(id,0))
    e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e11:SetCode(EVENT_BATTLE_DESTROYING)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e11:SetCondition(aux.bdogcon)
    e11:SetTarget(s.battletg)
    e11:SetOperation(s.battlepop)
    c:RegisterEffect(e11)
    --Special Summon another monster once leave field
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id,1))
    e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e12:SetCode(EVENT_LEAVE_FIELD)
    e12:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e12:SetCondition(s.thcon)
    e12:SetTarget(s.gtarget)
    e12:SetOperation(s.gactivate)
    c:RegisterEffect(e12)
    --During the battle phase: This card is unaffected by other card effects.
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE)
    e13:SetCode(EFFECT_IMMUNE_EFFECT)
    e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCondition(s.imcon)
    e13:SetValue(s.immunefilter()
    c:RegisterEffect(e13)
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
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
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
function s.immunefilter(e,te)
    return te:GetOwner()~=e:GetOwner() and Duel.GetCurrentPhase()==PHASE_BATTLE
end