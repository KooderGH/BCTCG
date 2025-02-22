-- Cat God the forbidden limbs
-- Scripted by poka-poka
-- Knee cap if drawn by effect
local s,id=GetID()
function s.initial_effect(c)
    -- If drawn by a card effect (not a search effect), banish itself and return to hand after 2 turn
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DRAW)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetCondition(s.bancon)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.bancon(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler()~=e:GetHandler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end 
    Duel.SetChainLimit(s.chainLimitFunction)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,tp,LOCATION_HAND)
end
    -- allow chain if the card being chained is one of limb
function s.chainLimitFunction(e,tp,p)
    local cardID = e:GetHandler():GetCode()
    if cardID == 210668004 or cardID == 210668005 or cardID == 210668006 or cardID == 210668007 then
        return false 
    end
    return true
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetCondition(s.thcon)
    e1:SetOperation(s.thop)
    e1:SetLabel(0)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
    Duel.RegisterEffect(e1,tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp 
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    e:GetHandler():SetTurnCounter(ct+1) 
    if ct==1 then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,e:GetHandler())
    else
        e:SetLabel(1)
    end
end
