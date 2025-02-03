-- HMS Princess
-- Scripted by poka-poka
-- Effects : (1) (Ignition) You can discard the top 5 cards of your deck to Special Summon this card from your hand or GY. If summoned this way, cannot be used as link material except for the monster "Manic Princess Punt". You can only use this effect of "HMS Princess" once per turn.
--			 (2) While this card is in your GY, it is treated as a Ritual Monster.
--    		 (3) If you control "Caletee" and "Herme", you can activate this effect (Ignition); Send the top 5 cards of both player's deck to the gy: Then draw 2 cards. You can only use this effect of "HMS Princess" once per turn.
--			 (4) If you have 15 or more cards in your GY, you can activate this effect (Ignition); Add 1 card from your GY to your hand. You can only use this effect of "HMS Princess" once per turn.
--			 (5) If this card on the field is banished; Draw 1 card.
local s,id=GetID()
function s.initial_effect(c)
    -- Effect 1: Discard top 5 cards to Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptarget)
    e1:SetOperation(s.spoperation)
    c:RegisterEffect(e1)
    -- Effect 2: Treated as a Ritual Monster while in GY
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CHANGE_TYPE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(TYPE_RITUAL)
    c:RegisterEffect(e2)
    -- Effect 3: Send 5 cards from both players' deck to GY, then draw 2
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
    e3:SetCondition(s.drawcon)
    e3:SetCost(s.drawcost)
    e3:SetTarget(s.drawtarget)
    e3:SetOperation(s.drawoperation)
    c:RegisterEffect(e3)
    -- Effect 4: Add 1 card from GY to hand if 15+ cards in GY
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,{id,2})
    e4:SetCondition(s.thcon)
    e4:SetCost(s.thcost)
    e4:SetTarget(s.thtarget)
    e4:SetOperation(s.thoperation)
    c:RegisterEffect(e4)
    -- Effect 5: Draw 1 card if this card is banished
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCondition(s.drawcondition3)
    e5:SetTarget(s.drawtarget3)
    e5:SetOperation(s.drawoperation3)
    c:RegisterEffect(e5)
end

-- Effect 1: Discard top 5 cards to Special Summon from hand or GY
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_DECK,0,5,nil) end
    local g=Duel.GetDecktopGroup(tp,5)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spoperation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
        -- Cannot be used as Link Material except for "Manic Princess Punt"
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(s.linklimit)
        e:GetHandler():RegisterEffect(e1)
    end
end
function s.linklimit(e,c)
    return not c:IsCode(210660161)
end
-- Effect 3: Send 5 cards from both decks to GY, then draw 2
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,210660485) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,210660530)
end
function s.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.drawtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,10,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drawoperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoGrave(Duel.GetDecktopGroup(1-tp,5),REASON_EFFECT)
    Duel.SendtoGrave(Duel.GetDecktopGroup(tp,5),REASON_EFFECT)
    Duel.Draw(tp,2,REASON_EFFECT)
end
-- Effect 4: Add 1 card from GY to hand if 15+ cards in GY
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=15
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thoperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- Effect 5: Draw 1 card if this card is banished
function s.drawcondition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.drawtarget3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drawoperation3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
