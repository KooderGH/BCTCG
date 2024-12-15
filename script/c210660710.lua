--Eva Unit-13
--Scripted by Gideon
-- (1) Can be Special Summoned to your side of the field by Tributing one Special Summoned monster your opponent controls. If you summon this way: You cannot conduct your battle phase the turn you summon this card.
-- (2) Cannot be destroyed by battle.
-- (3) At the end of the damage step; Destroy the monster that battled with this card.
-- (4) During your Standby Phase: You can Target 1 monster your opponent controls; return it.
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--Check/apply Battle Phase restriction
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EFFECT_SPSUMMON_COST)
	e9:SetCost(function(_,_,tp) return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end)
	e9:SetOperation(s.spcostop)
	c:RegisterEffect(e9)
	--Cannot be destroyed by battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Destroy at end of battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--Return on Standby
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(s.con)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end
--e1
function s.rfilter(c,tp)
	return c:IsControler(1-tp) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,s.rfilter,1,false,1,true,nil,nil,nil,true,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,false,true,true,nil,nil,nil,true,nil,tp)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	if Duel.Release(g,REASON_COST) > 0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
		end
	end
	g:DeleteGroup()
end
--e3
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	e:SetLabelObject(t)
	return t and t:IsRelateToBattle()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsRelateToBattle() then
		Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
	end
end
--e4
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.filter(c)
	return c:IsMonster() and c:IsAbleToHand()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--e9 / battle restriction
function s.spcostop(e,tp,eg,ep,ev,re,r,rp)
	--Cannot conduct your Battle Phase
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end