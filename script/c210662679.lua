-- Dogenstein
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Reveal
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(2)
    e1:SetTarget(s.cftg)
    e1:SetOperation(s.cfop)
    c:RegisterEffect(e1)
end
function s.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.cfop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if #g==0 then return end
    local sg=g:RandomSelect(tp,1)
    Duel.ConfirmCards(tp,sg)
    Duel.ShuffleHand(1-tp)
end