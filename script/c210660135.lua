--The Grateful Crane
--Scripted by Konstak
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) You take no battle damage involving this card.
-- (3) Cannot be used as Link Material.
-- (4) You can only use 1 of these effects of "The Grateful Crane" per turn, and only once that turn.
-- * When this card is Normal Summoned; Special Summon as many "The Grateful Crane" from your Deck, Hand, and/or GY as possible.
-- * If this card is sent to the GY; Add 1 WIND monster from your GY except "The Grateful Crane" for each WIND monster you control, you can only summon 1 more monster this turn after activating this effect.
-- * Once per turn (Ignition), if you control 3 "The Graceful Crane"s, you can add 3 WIND monsters from your deck or GY to your hand.
local s,id=GetID()
function s.initial_effect(c)
    --self destroy (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    e1:SetCondition(s.sdcon)
    c:RegisterEffect(e1)
    --No Battle damage (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --once normal summoned, Special summon as many grateful cranes as possible (4 *1)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCountLimit(1,id)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --once sent to the graveyard destroy S/T based on the number of WIND machine you control (4 *2)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1,id)
    e5:SetTarget(s.rmtg)
    e5:SetOperation(s.rmop)
    c:RegisterEffect(e5)
	--ignition if control 3 crane add 3 wind machine from deck or gy to hand (4.3)
	local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,2))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1,id)
    e6:SetCondition(s.thcon)
    e6:SetTarget(s.thtg)
    e6:SetOperation(s.thop)
    c:RegisterEffect(e6)
	--cannot link material (3)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e7:SetValue(1)
    c:RegisterEffect(e7)
end
s.listed_names={210660135}
--Self Destroy Function
function s.sdfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.sdcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--Special summon
function s.spfilter(c,e,tp)
	return c:IsCode(210660135) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,ft,ft,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--once sent to GY add Wind monsters from GY
function s.rmfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE)
end
function s.addfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and not c:IsCode(id)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsOnField() end
    local gt=Duel.GetMatchingGroupCount(s.rmfilter,tp,LOCATION_ONFIELD,0,nil)
    if chk==0 then return gt>0 and Duel.IsExistingTarget(nil,tp,LOCATION_GRAVE,0,gt,nil) end
    local g=Duel.SelectTarget(tp,s.addfilter,tp,LOCATION_GRAVE,0,gt,gt,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg=Duel.GetTargetCards(e)
    if #tg > 0 then
        Duel.SendtoHand(tg, nil, REASON_EFFECT)
        Duel.ConfirmCards(1-tp, tg)
        -- Apply the "Summon Limit" effect for the rest of the turn
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetCondition(s.sumcon)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        Duel.RegisterEffect(e2,tp)
        -- Register the "1 more summon" counter
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_SUMMON_SUCCESS)
        e3:SetOperation(s.sumop)
        e3:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e3,tp)
        local e4=e3:Clone()
        e4:SetCode(EVENT_SPSUMMON_SUCCESS)
        Duel.RegisterEffect(e4,tp)
    end
end
-- Summon limit condition: only allow summons if the counter is 0
function s.sumcon(e)
    return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>=1
end
-- Summon tracking operation: increment summon counter
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
--tohand 3 crane
function s.cranefilter(c) 
    return c:IsCode(210660135) and c:IsFaceup()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(s.cranefilter,tp,LOCATION_MZONE,0,nil) == 3
end
function s.thfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,3,3,nil)
    if #g > 0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end