--Emperor Cat's Greed
--Scripted by poka-poka
--Effect :Activate only if the only monster you control is "Emperor Cat". Destroy all monsters on the field except for "Emperor Cat". For each monster destroyed this way, "Emperor Cat" gains 1000 ATK. You cannot attack directly the turn you use this effect.
local s,id=GetID()
function s.initial_effect(c)
    -- Activation condition
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
    return #g==1 and g:GetFirst():IsCode(210660586)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    g:RemoveCard(Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,nil,210660586))
    if chk==0 then return #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ec=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,nil,210660586)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    g:RemoveCard(ec)

    if #g>0 and Duel.Destroy(g,REASON_EFFECT) > 0 and ec and ec:IsFaceup() then
        local ct=#g
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ct*1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        ec:RegisterEffect(e1)
    end
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
