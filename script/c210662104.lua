-- Ecto Snache
local s,id=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c,nil,s.filter)
    --Def update
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetValue(300)
    c:RegisterEffect(e1)
end
function s.filter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_WIND) or c:IsAttribute(ATTRIBUTE_WATER)
end