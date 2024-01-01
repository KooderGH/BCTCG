--Papaluga
--Scripted by Gideon. Had aid from Naim
-- (1) Cannot be destroyed by battle.
-- (2) The ATK of non-Fiend monsters on the field becomes 200.
-- (3) If you control 4 or more Fiend monsters, negate the effects of all non-Fiend monsters your opponent controls.
-- (4) If you control less than 4 Fiend monsters, negate the effects of all non-Fiend monsters you control.
local s,id=GetID()
function s.initial_effect(c)
	--Cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--The ATK of non-Fiend monsters on the field becomes 200.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.atktarget)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.negateopcondition)
	e3:SetTarget(function(e,c) return not c:IsRace(RACE_FIEND) end)
	c:RegisterEffect(e3)
	--4
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(s.negateyourselfcondition)
	e4:SetTarget(function(e,c) return not c:IsRace(RACE_FIEND) end)
	c:RegisterEffect(e4)
end
--E2
function s.atktarget(e,c)
	return not c:IsRace(RACE_FIEND)
end
--E3
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function s.negateopcondition(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,4,nil)
end
--E4
--Uses same cfilter
function s.negateyourselfcondition(e)
	return not Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,4,nil)
end
