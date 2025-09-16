-- Ecto Doge
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c,nil,s.filter)
    --Atk update
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(300)
    c:RegisterEffect(e1)
end
function s.filter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_WIND) or c:IsAttribute(ATTRIBUTE_FIRE)
end