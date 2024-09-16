--Tekachi
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    --Effect 4: Only control 1 "Tekachi"
    c:SetUniqueOnField(1,0,id)
    --Effect 1: Negate Spell activation and destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.negcon)
    e1:SetCost(s.negcost)
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.negop)
    c:RegisterEffect(e1)
    --Effect 2: Activate Trap from hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(s.trapcon)
    e2:SetOperation(s.trapop)
    c:RegisterEffect(e2)
    --Effect 3: Add Trap from deck when sent to GY
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,{id,2})
    e3:SetCondition(s.thcon)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end
--Fog counter
s.counter_place_list={0x1019}
--(1) Negate Spell activation and destroy
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1019,3,REASON_COST) and e:GetHandler():IsAbleToGraveAsCost() end
    Duel.RemoveCounter(tp,1,0,0x1019,3,REASON_COST)
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsChainNegatable(ev) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
--(2) Activate Trap from hand
function s.trapcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsTurnPlayer(1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=3 and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_FAIRY),tp,LOCATION_MZONE,0,3,nil)
end
function s.trapop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e1:SetTargetRange(LOCATION_HAND,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
--(3) Add Trap from deck when sent to GY
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
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
        -- Cannot activate or set Spell/Trap for the rest of the turn
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_SSET)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetCode(EFFECT_CANNOT_ACTIVATE)
        e2:SetTargetRange(1,0)
        e2:SetValue(s.aclimit)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
    end
end
function s.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
