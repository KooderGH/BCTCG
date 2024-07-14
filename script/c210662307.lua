-- Icy Doge
--Scripted by Konstak
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
    --Damage Control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetOperation(s.dcop)
    c:RegisterEffect(e4)
    --This card's Position cannot be changed.
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_SET_POSITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(POS_ATTACK)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e5)
end
function s.damval(e,re,val,r,rp,rc)
    if (r&REASON_EFFECT)~=0 then return 0
    else return val end
end
--Damage Control effect
function s.dcop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end