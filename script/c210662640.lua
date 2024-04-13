-- Suidae Piggicus
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Change battle damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetValue(200)
    c:RegisterEffect(e1)
end