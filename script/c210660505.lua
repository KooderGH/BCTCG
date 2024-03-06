--Relentless Gladios
--Scripted by Konstak
--Effect
-- (1) You can Special Summon this card by Targeting 1 monster you control (Igntion); Destroy that monster and Special Summon this card from your hand. You cannot conduct the battle phase the turn you use this effect. You can only use this effect of "Relentless Gladios" once per turn.
-- (2) When this card is Tribute Summoned; Your opponent cannot Normal Summon or Set monsters on their next turn. 
-- (3) When this card is destroyed by card effect: Target 1 Dragon monster in your GY; Add it to your hand.
-- (4) When this card is destroyed by battle; Add one Dragon monster from your deck to your hand.
-- (5) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --special summon (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --once tributed summon your opponent cannot normal summon/set on their next turn (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(s.trcon)
    e2:SetOperation(s.trop)
    c:RegisterEffect(e2)
    --When destroyed by card effect (3)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(s.descon)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
    --When destroyed by battle (4)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(s.descon2)
    e4:SetTarget(s.destg2)
    e4:SetOperation(s.desop2)
    c:RegisterEffect(e4)
    --Double tribute for the Tribute Summon of Dragon monsters (5)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e5:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e5)
end
--Special Summon function (1)
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_ONFIELD)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    if c:IsRelateToEffect(e) then
		Duel.Destroy(g,REASON_EFFECT)
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_BP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE|PHASE_END)
        Duel.RegisterEffect(e1,tp)
        Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
    end
end
--Tribute summon function (2)
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    e1:SetCondition(s.efcon)
    e1:SetLabel(Duel.GetTurnCount())
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_MSET)
    Duel.RegisterEffect(e2,tp)
end
function s.efcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
--Add when destroyed by effect function (3)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.addfilter(c)
	return c:IsMonster() and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	    Duel.ConfirmCards(1-tp,g)
	end
end
--Add when destroyed by battle function (4)
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	    Duel.ConfirmCards(1-tp,g)
	end
end