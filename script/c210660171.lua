--Balaluga
--Scripted by Gideon. Thanks to naim for showing me -reset_tofield
-- (1) If you control a Fiend monster: You can Special Summon this card from your hand. This card cannot be Tributed or used as Link Material if summoned this way. 
-- (2) While this card is face-up on the field: Monsters with 1500 or more ATK cannot  declare an attack except Fiend Monsters.
-- (3) Your opponent takes no damage while this card is on the field.
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.atktarget)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)

end
--e1
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3303)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e4)
end
--e2
function s.atktarget(e,c)
	return c:GetAttack()>=1500 and not c:IsRace(RACE_FIEND)
end