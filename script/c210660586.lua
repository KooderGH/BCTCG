--Emperor Cat
--Scripted by poka-poka
--Effect
--(1) Cannot be Special Summoned. Must be Normal Summoned/Set by Tributing 3 monsters.
--(2) Cannot be destroyed by battle or card effects.
--(3) The ATK/DEF of all monster's in your opponent side of the field are halved.
--(4) At the end of the battle phase, if this card battled: Inflict 2000 damage to your opponent.
--(5) Once per turn: You can Tribute 1 monster; This card gains ATK equal to the Tributed monster's original ATK.
--(6) Once per duel: If this card is in your GY, You can Tribute 1 monster you control with 2500 or more ATK; Special Summon this card, ignoring its Summoning conditions.
local s,id=GetID()
function s.initial_effect(c)
	--summon with 3 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,false,3,3)
	local e2=aux.AddNormalSetProcedure(c,true,false,3,3)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--half atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(s.atktg)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(s.defval)
	c:RegisterEffect(e5)
	--cannot be battle destroyed
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--cannot be destroyed by effect
	local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(1)
    c:RegisterEffect(e7)
	--If this card battled, inflict 2000 damage to opponents at the end of the battle phase
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.ddcon)
	e8:SetOperation(s.ddop)
	c:RegisterEffect(e8)
	-- tribute monster, Increase ATK equal to the tributed monster atk
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,0))
	e9:SetCategory(CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCost(s.atcost)
	e9:SetOperation(s.atop)
	c:RegisterEffect(e9)
	-- tribute 1 monster with 2500 or more attack, SP summon from GY ignore its summon condition
	local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,1))
    e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e10:SetCost(s.spcost)
    e10:SetTarget(s.sptg)
    e10:SetOperation(s.spop)
    c:RegisterEffect(e10)
end
--halve atk/def
function s.atktg(e,c)
    return c:IsControler(1-e:GetHandlerPlayer())
end
function s.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function s.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end
--2000 damage if battled
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattledGroupCount()>0
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,2000,REASON_EFFECT)
end
-- Tribute & increase attack
function s.atkfilter(c)
    return c:GetAttack()>0
end
function s.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.atkfilter,1,false,nil,c) end
    local g=Duel.SelectReleaseGroupCost(tp,s.atkfilter,1,1,false,nil,c)
    local atk=g:GetFirst():GetAttack()
    if atk<0 then atk=0 end
    e:SetLabel(atk)  
    Duel.Release(g,REASON_COST)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end
--SP summon from GY
function s.spfilter(c,tp)
    return c:IsAttackAbove(2500) and c:IsReleasable()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.spfilter,1,false,nil,nil,tp) end
    local g=Duel.SelectReleaseGroupCost(tp,s.spfilter,1,1,false,nil,nil,tp)
    Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
    end
end