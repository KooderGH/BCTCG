--Gaia the Creator
--Scripted by Gideon
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. You can Special Summon this card from your hand or GY by discarding 3 card's from your hand while controlling no monsters. Then move this card to your Extra Monster Zone. You can only activate this effect once per duel.
-- (2) Cannot be returned to hand or banished.
-- (3) Cannot be targeted by card effects. This effect cannot be negated.
-- (4) While you control this card, you cannot Normal Summon / Set Monsters. This effect cannot be negated.
-- (5) Neither player can activate the effects of monsters in the hand. This effect cannot be negated.
-- (6) Inflict's Piercing Damage. This effect cannot be negated.
-- (7) All effects that add or subtract ATK/DEF are reversed. This effect cannot be negated.
-- (8) When this card destroys an opponent's monster by battle and sends it to the GY: Special Summon that monster to your field. This effect cannot be negated.
-- (9) When this card leaves the field: You can target 1 Monster in either GY; Special Summon it
-- (10)During the battle phase: This card is unaffected by other card effects.
local s,id=GetID()
function s.initial_effect(c)
    --(1)Start
    --Makes it unsummonable via normal
    c:EnableUnsummonable()
    --Cannot be SS by other ways other then it's own effect via above and this function
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.FALSE)
    c:RegisterEffect(e0)
    --SS from Hand / GY
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e1:SetCondition(s.ssummoncon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Move to EMZ
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(s.mvop)
    c:RegisterEffect(e2)
    --Summon cannot be disabled (Hopefully)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
    --(1)Finish
    --(2)Start
    --Cannot be returned to hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Cannot banish
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e5)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --(3)Finish
    --(4)Start
    --While you control this card, you cannot Normal Summon / Set Monsters.
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_CANNOT_SUMMON)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetTargetRange(1,0)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e8)
    local e9=e7:Clone()
    e9:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e9)
    --(4)Finish
    --(5)Start
    --Neither player can activate the effects of monsters in the hand. This effect cannot be negated.
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e10:SetCode(EFFECT_CANNOT_ACTIVATE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetTargetRange(1,1)
    e10:SetValue(s.aclimit)
    c:RegisterEffect(e10)
    --(5)Finish
    --(6)Start
    --Inflict's Piercing Damage. This effect cannot be negated.
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_PIERCE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e11)
    --(6)Finish
    --(7)Start
    --Reverse trap
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_REVERSE_UPDATE)
    e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    c:RegisterEffect(e12)
    --(7)Finish
    --(8)Start
    --Goyo on drugs
    local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(id,0))
    e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e13:SetCode(EVENT_BATTLE_DESTROYING)
    e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e13:SetCondition(aux.bdogcon)
    e13:SetTarget(s.battletg)
    e13:SetOperation(s.battlepop)
    c:RegisterEffect(e13)
    --(8)Finish
    --(9)Start
    local e14=Effect.CreateEffect(c)
    e14:SetDescription(aux.Stringid(id,1))
    e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e14:SetCode(EVENT_LEAVE_FIELD)
    e14:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e14:SetCondition(s.thcon)
    e14:SetTarget(s.gtarget)
    e14:SetOperation(s.gactivate)
    c:RegisterEffect(e14)
    --(9)Finish
    --(10)Start
    --During the battle phase: This card is unaffected by other card effects.
    local e15=Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_SINGLE)
    e15:SetCode(EFFECT_IMMUNE_EFFECT)
    e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e15:SetRange(LOCATION_MZONE)
    e15:SetCondition(s.imcon)
    e15:SetValue(1)
    c:RegisterEffect(e15)
end
--(1)
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),0,c)
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_DISCARD,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
	g:DeleteGroup()
end
--Move to extra
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    if (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1)) then
        local lftezm=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,5) and 0x20 or 0
        local rgtemz=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,6) and 0x40 or 0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~ZONES_EMZ|(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
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