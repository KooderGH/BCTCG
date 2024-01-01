--Kubiluga
--Scripted by Gideon
-- (1) Cannot be returned to hand.
-- (2) When this card battles, before damage calulation; return the monster this card is battling.
-- (3) During your Main Phase, you can Normal Summon 1 Fiend monster in addition to your Normal Summon (but not set). (You can only gain this effect once per turn.)
-- (4) While this card is Face-up on the field: Face-up monster's you control are changed to Attack Position and their battle positions cannot be changed. (Mandatory Continuous)
local s,id=GetID()
function s.initial_effect(c)
	--Cannot be returned to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e1)
	--Return on battle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(s.rtarget)
	e2:SetOperation(s.roperation)
	c:RegisterEffect(e2)
	--Normal Summon 1 Fiend
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND))
	c:RegisterEffect(e3)
	--Force Atk Position
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e5)
end
--e2
function s.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,t,1,0,0)
end
function s.roperation(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	if t and t:IsRelateToBattle() then
		Duel.SendtoHand(t, nil, REASON_EFFECT)
	end
end