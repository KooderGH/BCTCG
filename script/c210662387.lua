-- Hackey
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Change battle damage (LP drain ability)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetCondition(s.con)
    e3:SetValue(1000)
    c:RegisterEffect(e3)
end
--Change Battle Damage Ability
function s.con(e)
	return e:GetHandler():IsAttackPos()
end