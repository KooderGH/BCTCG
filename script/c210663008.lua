--Wrong Item Cat
--Scripted by Konstak
--Effect
--(1) This card can only be Summoned 3 times a duel.
--(2) Neither player can activate effects in response to this card's summon.
--(3) When this card is Summoned; Roll a six-sided die and apply the result.
--* 1 or 2: After this effect resolves, you can add 1 card from your GY to your hand but that card's name cannot be activated or summoned/placed on the field this turn.
--* 3 or 4: After this effect resolves, special summon 1 monster from your deck. It's effects are negated and cannot attack this turn.
--* 5: After this effect resolves, add 1 Level 7 or lower monster from your deck to your hand.
--* 6: Set both player's LPs to 8000, then shuffle all cards from their hand, field, and GY into the Deck except "Wrong Item Cat", then each player draws 5 cards.
--(4) Each time your opponent Special Summons a monster(s): Roll a six sided die, and return all those Summoned monster(s) to the hand with a current Level that's the same as the result
--(5) At the start of the Battle Phase (Mandatory); Each player rolls a six-sided die and applies the result to all monsters they control until the end of this turn.
--* 1: Lose 1000 ATK
--* 2: Gain 1000 ATK
--* 3: Lose 500 ATK
--* 4: Gain 500 ATK
--* 5: Halve their ATK
--* 6: Gain 2000 ATK
--(6) This card cannot be targeted by effects or attacks as long as you control a level 6 or higher monster on the field.
local s,id=GetID()
function s.initial_effect(c)
    --Can only be summoned 3 times per duel (1)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(s.splimit)
    c:RegisterEffect(e0)
    --Cannot be responded to (2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetOperation(function() Duel.SetChainLimitTillChainEnd(function() return false end) end)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --Roll die when summoned (3)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,0))
    e6:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DRAW)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_SUMMON_SUCCESS)
    e6:SetTarget(s.drtg)
    e6:SetOperation(s.drop)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e7)
    local e8=e6:Clone()
    e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e8)
    --Roll die when opponent special summons (4)
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,1))
    e9:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCondition(s.thcon)
    e9:SetTarget(s.thtg)
    e9:SetOperation(s.thop)
    c:RegisterEffect(e9)
    --Roll die at start of Battle Phase (5)
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,2))
    e10:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
    e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e10:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCountLimit(1)
    e10:SetTarget(s.atktg)
    e10:SetOperation(s.atkop)
    c:RegisterEffect(e10)
    --Cannot be targeted if you control level 6+ monster (6)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e11:SetCondition(s.tgcon)
    e11:SetValue(1)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e12:SetCondition(s.tgcon)
    e12:SetValue(aux.imval1)
    c:RegisterEffect(e12)
    --Count summons
    if not s.global_check then
        s.global_check=true
        s.summon_count={}
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge1:SetOperation(s.clear)
        Duel.RegisterEffect(ge1,0)
    end
end
--Functions for effect 1 (Summon limit)
function s.clear(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnCount()==1 then
        s.summon_count[0]=0
        s.summon_count[1]=0
    end
end
function s.splimit(e,se,sp,st)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_HAND) then
        if not s.summon_count[c:GetControler()] then
            s.summon_count[c:GetControler()]=0
        end
        return s.summon_count[c:GetControler()]<3
    end
    return true
end
--Functions for effect 3 (Roll die when summoned)
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.thfilter(c)
    return c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter2(c)
    return c:IsMonster() and c:IsLevelBelow(7) and c:IsAbleToHand()
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    --Count this summon
    if not s.summon_count[c:GetControler()] then
        s.summon_count[c:GetControler()]=0
    end
    s.summon_count[c:GetControler()]=s.summon_count[c:GetControler()]+1
    --Roll die and apply effect
    local d=Duel.TossDice(tp,1)
    if d==1 or d==2 then
        --Add 1 card from GY to hand
        if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
            if #g>0 then
                Duel.SendtoHand(g,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g)
                --Cannot activate, summon or place
                local tc=g:GetFirst()
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e1:SetCode(EFFECT_CANNOT_ACTIVATE)
                e1:SetTargetRange(1,0)
                e1:SetValue(s.aclimit)
                e1:SetLabel(tc:GetCode())
                e1:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e1,tp)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_FIELD)
                e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e2:SetCode(EFFECT_CANNOT_SUMMON)
                e2:SetTargetRange(1,0)
                e2:SetTarget(s.sumlimit)
                e2:SetLabel(tc:GetCode())
                e2:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e2,tp)
                local e3=e2:Clone()
                e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
                Duel.RegisterEffect(e3,tp)
                local e4=e2:Clone()
                e4:SetCode(EFFECT_CANNOT_MSET)
                Duel.RegisterEffect(e4,tp)
                local e5=e2:Clone()
                e5:SetCode(EFFECT_CANNOT_SSET)
                Duel.RegisterEffect(e5,tp)
            end
        end
    elseif d==3 or d==4 then
        --Special Summon 1 monster from deck
        if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
            if #g>0 then
                local tc=g:GetFirst()
                Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                --Negate effects
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
                --Cannot attack
                local e3=Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_SINGLE)
                e3:SetCode(EFFECT_CANNOT_ATTACK)
                e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                tc:RegisterEffect(e3)
            end
        end
    elseif d==5 then
        --Add 1 Level 7 or lower monster from deck to hand
        if Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
            if #g>0 then
                Duel.SendtoHand(g,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g)
            end
        end
    elseif d==6 then
        --Reset LP, shuffle all cards, draw 5
        Duel.SetLP(tp,8000)
        Duel.SetLP(1-tp,8000)
        local rg=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0)
        rg:RemoveCard(c)
        Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        local rg2=Duel.GetFieldGroup(1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0)
        Duel.SendtoDeck(rg2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        Duel.ShuffleDeck(1-tp)
        Duel.BreakEffect()
        Duel.Draw(tp,5,REASON_EFFECT)
        Duel.Draw(1-tp,5,REASON_EFFECT)
    end
end
function s.aclimit(e,re,tp)
    return re:GetHandler():IsCode(e:GetLabel())
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsCode(e:GetLabel())
end
--Functions for effect 4 (Roll die when opponent special summons)
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local d=Duel.TossDice(tp,1)
    local g=eg:Filter(Card.IsControler,nil,1-tp):Filter(function(c) return c:HasLevel() and c:IsLevel(d) end,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
--Functions for effect 5 (Roll die at start of Battle Phase)
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local d1=Duel.TossDice(tp,1)
    local d2=Duel.TossDice(1-tp,1)
    --Apply effect for player 1
    local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g1) do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        if d1==1 then
            e1:SetValue(-1000)
        elseif d1==2 then
            e1:SetValue(1000)
        elseif d1==3 then
            e1:SetValue(-500)
        elseif d1==4 then
            e1:SetValue(500)
        elseif d1==5 then
            e1:SetValue(function(e,c) return math.floor(-c:GetAttack()/2) end)
        elseif d1==6 then
            e1:SetValue(2000)
        end
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
    --Apply effect for player 2
    local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    for tc in aux.Next(g2) do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        if d2==1 then
            e1:SetValue(-1000)
        elseif d2==2 then
            e1:SetValue(1000)
        elseif d2==3 then
            e1:SetValue(-500)
        elseif d2==4 then
            e1:SetValue(500)
        elseif d2==5 then
            e1:SetValue(function(e,c) return math.floor(-c:GetAttack()/2) end)
        elseif d2==6 then
            e1:SetValue(2000)
        end
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
--Functions for effect 6 (Cannot be targeted)
function s.tgcon(e)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsLevelAbove,6),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end