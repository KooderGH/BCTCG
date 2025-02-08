-- MOMOCO's Twitch Stream
-- Scripted by poka-poka
-- Effect : Activate only if there are 3 or more monster's in your banish zone; Add 1 "Wonder MOMOCO" from your deck to your hand. You can only activate "MOMOCO's Twitch Stream" once per turn.
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.thcon)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
end
function s.banfilter (c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
	end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(s.banfilter,tp,LOCATION_REMOVED,0,nil)>=3
end
function s.thfilter(c)
    return c:IsCode(210660455) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
