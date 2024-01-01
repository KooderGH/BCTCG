--Eva Unit-01
--Scripted by Konstak. Help from Gideon.
--Effect:
--(1) You can Special Summon this card by Tributing 1 monster you control.
--(2) This card can attack all monsters your opponent controls once each.
--(3) Has piercing battle damage.
--(4) When this card destroys a monster by battle; Gain 400 ATK.
local s,id=GetID()
function s.initial_effect(c)
    --special summon tribute
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Attack all each time
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --pierce
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e3)
    --gain Atk
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetCondition(s.atkcon)
    e4:SetOperation(s.atkop)
    c:RegisterEffect(e4)
end
function s.spcon(e,c)
	if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),nil,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,false,true,true,c,nil,nil,false,nil,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsMonster()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		c:RegisterEffect(e1)
	end
end