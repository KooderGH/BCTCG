-- Yakisoba U.F.O. Cat
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
	aux.AddNormalSetProcedure(c)
    --self destroy
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    c:RegisterEffect(e1)
end