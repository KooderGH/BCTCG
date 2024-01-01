--Crazed Yuki
--Scripted by whoever scripted lava golem cause I just copy pasted that and added piercing lol (Gideon)
--Effects
-- (1) Cannot be Normal Summoned/Set. Must first be Special Summoned from your hand to your opponent's field by Tributing 2 monsters they control. You cannot Normal Summon/Set the turn you Special Summon this card. 
-- (2) Once per turn, during your Standby Phase: Take 1000 damage.
-- (3) Does piercing damage.
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon procedure
	aux.AddLavaProcedure(c,2,POS_FACEUP,nil,0,aux.Stringid(id,0))
	--Take 1000 damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--Check/apply Normal Summon/Set restriction
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetCost(function(_,_,tp) return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 end)
	e3:SetOperation(s.spcostop)
	c:RegisterEffect(e3)
	--pierce
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e4)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.spcostop(e,tp,eg,ep,ev,re,r,rp)
	--Cannot Normal Summon/Set
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end