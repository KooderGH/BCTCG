-- Mini Angel Cyclone
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Attack all each time
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ATTACK_ALL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
end
