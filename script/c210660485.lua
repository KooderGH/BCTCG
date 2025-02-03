-- Calette
-- Scripted by poka-poka
-- Effects :
--(1) If you control Herme on the field, you can Special Summon this card from your hand.
--(2) This card is treated as a Synchro Monster while in the GY.
--(3) Once per turn: You can discard top 3 cards in your deck; Change the DEF of all monster's your opponent's control to 0.
--(4) If this card is banished; Draw 1 card. You can only use this effect of "Calette" once per turn.
--(5) If you have 15 or more cards in your GY and this card is in your GY, you can activate this effect (Ignition); Special Summon this card from your GY. You can only activate this effect of "Calette" once per duel.
local s,id=GetID()
function s.initial_effect(c)
    -- Special Summon from hand if you control "Herme"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    -- Treated as a Synchro Monster in the GY
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CHANGE_TYPE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetValue(TYPE_SYNCHRO)
    c:RegisterEffect(e2)
    -- Change opponent's monster DEF to 0
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DECKDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(s.defcost)
    e3:SetOperation(s.defop)
    c:RegisterEffect(e3)
    -- Draw 1 if banished
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_REMOVE)
    e4:SetCountLimit(1,{id,1})
    e4:SetTarget(s.drtg)
    e4:SetOperation(s.drop)
    c:RegisterEffect(e4)
    -- Special Summon from GY if 15+ cards in GY (once per duel)
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

-- Special Summon whenControl "Herme"
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,210660530),c:GetControler(),LOCATION_MZONE,0,1,nil)
end

-- Cost for effect 3: Discard top 3 cards
function s.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
    Duel.DiscardDeck(tp,3,REASON_COST)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,TYPE_MONSTER),tp,0,LOCATION_MZONE,nil)
    for tc in aux.Next(g) do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end

-- Draw 1 card if banished
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end

-- Special Summon from GY if 15+ cards in GY (once per duel)
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
