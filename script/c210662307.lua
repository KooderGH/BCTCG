-- Icy Doge
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be destroyed by battle
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CHANGE_DAMAGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1,0)
    e2:SetValue(s.damval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e3)
end
function s.damval(e,re,val,r,rp,rc)
    if (r&REASON_EFFECT)~=0 then return 0
    else return val end
end
