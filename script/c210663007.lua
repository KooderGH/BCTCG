--Snow-Sledder Lucia (full rework)
--Scripted by Konstak
--Effect
--(1) If you control A WIND Machine monster(s), you can reveal this card in your hand (Ignition); Negate the effects of all WIND monster's you control until the end phase, then, special summon this card.
--(2) WIND Machine monster(s) you control cannot be destroyed by their own effects.
--(3) You can only use 1 of these effects of "Snow-Sledder Lucia" per turn, and only once that turn.
--(3.1) Once per turn (Ignition): You can send 3 * the number of WATER monster's you control from the top of your opponent's deck to the GY. (Deck mill effect)
--(3.2) Once per turn, during your end phase: You can gain 500 LP per WIND monster you control.
--(3.3) If you control another "Lost & Found" monster except "Snow-Sledder Lucia", you can activate this effect (Quick): Target 1 monster you control; That monster can attack twice this turn.
--(3.4) When this card is sent to the GY, you can add 1 "Lost & Found" monster except "Snow-Sledder Lucia" from your deck to your hand but for the rest of this turn, you cannot Normal Summon/Set or Special Summon monsters with that name, nor activate their monster effects.
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon from hand by negating WIND monsters (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --WIND Machine monsters cannot be destroyed by their own effects (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.indtg)
    e2:SetValue(s.indval)
    c:RegisterEffect(e2)
    --Deck mill effect (3.1)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DECKDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,{id,0})
    e3:SetTarget(s.milltg)
    e3:SetOperation(s.millop)
    c:RegisterEffect(e3)
    --Gain LP during end phase (3.2)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_RECOVER)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,{id,0})
    e4:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
    e4:SetTarget(s.lptg)
    e4:SetOperation(s.lpop)
    c:RegisterEffect(e4)
    --Double attack (3.3)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,{id,0})
    e5:SetCondition(s.atkcon)
    e5:SetTarget(s.atktg)
    e5:SetOperation(s.atkop)
    e5:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_PHASE)
    c:RegisterEffect(e5)
    --Add Lost & Found monster when sent to GY (3.4)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,4))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetCountLimit(1,{id,0})
    e6:SetTarget(s.thtg)
    e6:SetOperation(s.thop)
    c:RegisterEffect(e6)
end
--Functions for effect 1 (Special Summon from hand)
function s.spfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    Duel.ConfirmCards(1-tp,e:GetHandler())
    Duel.ShuffleHand(tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_WIND)
    for tc in aux.Next(g) do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Functions for effect 2 (Protection from self-destruction)
function s.indtg(e,c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE)
end
function s.indval(e,re)
    return re:GetOwner()==re:GetHandler() and re:IsActiveType(TYPE_MONSTER)
end
--Functions for effect 3.1 (Deck mill)
function s.waterfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetMatchingGroupCount(s.waterfilter,tp,LOCATION_MZONE,0,nil)*3
    if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function s.millop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(s.waterfilter,tp,LOCATION_MZONE,0,nil)*3
    if ct>0 then
        Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
    end
end
--Functions for effect 3.2 (Gain LP)
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_WIND)*500
    if chk==0 then return ct>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_WIND)*500
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,ct,REASON_EFFECT)
end
--Functions for effect 3.3 (Double attack)
function s.atkfilter(c)
    return c:IsFaceup() and (c:IsCode(210663010) or c:IsCode(210663005) or c:IsCode(210663009) or c:IsCode(210663008) or c:IsCode(210663004)) and not c:IsCode(id) -- Lost & Found cards
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
--Functions for effect 3.4 (Add Lost & Found monster)
function s.thfilter(c)
    return (c:IsCode(210663010) or c:IsCode(210663005) or c:IsCode(210663009) or c:IsCode(210663008) or c:IsCode(210663004)) and not c:IsCode(id) and c:IsMonster() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        Duel.ConfirmCards(1-tp,g)
        local tc=g:GetFirst()
        if tc then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_CANNOT_SUMMON)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetTargetRange(1,0)
            e1:SetTarget(s.sumlimit)
            e1:SetLabel(tc:GetCode())
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
            Duel.RegisterEffect(e2,tp)
            local e3=e1:Clone()
            e3:SetCode(EFFECT_CANNOT_MSET)
            Duel.RegisterEffect(e3,tp)
            local e4=e1:Clone()
            e4:SetCode(EFFECT_CANNOT_ACTIVATE)
            e4:SetValue(s.aclimit)
            Duel.RegisterEffect(e4,tp)
        end
    end
end
function s.sumlimit(e,c)
    return c:IsCode(e:GetLabel())
end
function s.aclimit(e,re,tp)
    return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end