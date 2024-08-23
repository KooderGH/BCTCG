-- Gobble
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Toxic Ability
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.toxiccon)
    e1:SetTarget(s.toxictg)
    e1:SetOperation(s.toxicop)
    c:RegisterEffect(e1)
    --No battle damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    c:RegisterEffect(e2)
    --Avoid Battle damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
--Toxic on Battle function
function s.toxiccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.toxictg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
end
function s.toxicop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() and tc and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.NegateAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-500)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(-500)
        tc:RegisterEffect(e2)
	end
end