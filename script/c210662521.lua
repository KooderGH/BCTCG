-- Johnnyleon
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Can target 1 S/T (Long Distance Attack)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    --Also treated as a WATER monster on the field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_ATTRIBUTE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(ATTRIBUTE_WATER)
    c:RegisterEffect(e2)
    --Also treated as a Zombie monster on the field
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_ADD_RACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(RACE_ZOMBIE+RACE_AQUA)
    c:RegisterEffect(e3)
    --Zombie monsters cannot be banished by card effects
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EFFECT_CANNOT_REMOVE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(s.rmlimit)
    c:RegisterEffect(e4)
end
--Can target 1 S/T (Long Distance Attack) Function
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_SZONE+LOCATION_FZONE,LOCATION_SZONE+LOCATION_FZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_SZONE+LOCATION_FZONE,LOCATION_SZONE+LOCATION_FZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--Cannot remove
function s.rmlimit(e,c,tp,r)
    return c:IsRace(RACE_ZOMBIE) and c:IsFaceup() and not c:IsImmuneToEffect(e) and r&REASON_EFFECT>0
end