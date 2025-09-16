--King of Doom Phonos
--Scripted by Gideon
--Effect
-- (1) You can destroy one DARK monster from your hand to Special Summon this card from your hand or graveyard. You can only activate this effect of "King of Doom Phono" once per turn.
-- (2) Cannot be Special Summoned from the GY except by its own effect.
-- (3) If this card battles, your opponent cannot activate cards or effects until the end of the Damage Step. 
-- (4) During damage calulation, if this card battles an opponent's monster, you can banish one DARK monster from your graveyard, this card ATK becomes 5000 during that damage calculation only.
-- (5) You can only control one "Child of Destiny Phono"
local s,id=GetID()
function s.initial_effect(c)
	-- Can Only control 1
	c:SetUniqueOnField(1,0,id)
	--SS destroy (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Cannot activate in battle (2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)
	--Banish set atk to 5000
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.atkcon)
	e3:SetCost(s.atkcost)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	--canot SS from gy except by its own Effect
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetValue(s.splimit)
	c:RegisterEffect(e4)
end
--(1) Functions
function s.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_HAND)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_HAND,0,c)
	if chk==0 then return #g>=1 and aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),0)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_HAND,0,c)
	if #g<1 then return end
	local dg=aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_DESTROY)
	if #dg==1 and Duel.Destroy(dg,REASON_EFFECT)==1 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
--(2) Functions
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
--(3) Functions
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	--This magically works and I don't understand why
    return e:GetHandler():GetBattleTarget()~=nil
end
function s.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(5000)
		c:RegisterEffect(e1)
	end
end
--canot SS from gy except by its own Effect
function s.splimit(e,se,sp,st)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_GRAVE) then
        return se:GetHandler()==c
    end
    return true
end