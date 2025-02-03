-- Herme
-- Scripted by poka-poka
-- Effects :
-- (1) If you control Calette on the field, you can Special Summon this card from your hand.
-- (2) This card is treated as a Ritual Monster while in the GY.
-- (3) Once per turn: You can discard the top 3 cards in your deck; Change all monsters your opponent controls to face-up Defense Position.
-- (4) If this card is banished; Banish 1 monster your opponent control's. You can only use this effect of "Herme" once per turn.
-- (5) If you have 15 or more cards in your GY and this card is in your GY, you can activate this effect (Ignition); Special Summon this card from your GY. You can only activate this effect of "Herme" once per duel.

local s,id=GetID()
function s.initial_effect(c)
    -- (1) Special Summon if you control "Calette"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    -- (2) Treated as a Ritual Monster in the GY
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CHANGE_TYPE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetValue(TYPE_RITUAL)
    c:RegisterEffect(e2)
    -- (3) Change all opponent's monsters to face-up Defense Position
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DECKDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id)
    e3:SetCost(s.defcost)
    e3:SetOperation(s.defop)
    c:RegisterEffect(e3)
    -- (4) If banished, banish 1 opponent’s monster
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_REMOVE)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1,{id,1})
    e4:SetTarget(s.rmtg)
    e4:SetOperation(s.rmop)
    c:RegisterEffect(e4)
    -- (5) Special Summon from GY if 15+ cards in GY (Once per Duel)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e5:SetCondition(s.gyspcon)
    e5:SetTarget(s.gysptg)
    e5:SetOperation(s.gyspop)
    c:RegisterEffect(e5)
end

-- (1) Special Summon condition
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,210660485),c:GetControler(),LOCATION_MZONE,0,1,nil)
end

-- (3) Discard 3 cards to change opponent's monsters to Defense Position
function s.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
    Duel.DiscardDeck(tp,3,REASON_COST)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    if #g>0 then
        Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
    end
end

-- (4) If banished, banish 1 opponent’s monster
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end

-- (5) Special Summon if 15+ cards in GY (Once per Duel)
function s.gyspcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=15
end
function s.gysptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.gyspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
