--Hevijak the Wicked
--Scripted by The Weetizen
--poka-poka & 7th effect by Konstak
--Effect
--(1) If you control no monsters while your opponent controls a monster: You can Special Summon this card from your hand.
--(2) When this card is Tribute Summoned; Destroy all monsters in Defense Position.
--(3) When this card is Special Summoned; Add one Dragon monster from your deck to your hand.
--(4) Once while this card is on the field (Quick): You can target 1 card your opponent controls and one card you control; Destroy those target's
--(5) When this card is destroyed by a card effect: You can Target one Spell or Trap in your GY; Add it to your hand. You can only use this effect of "Hevijak the Wicked" once per duel.
--(6) When this card is destroyed by battle; You can Special Summon one Dragon monster from your hand.
--(7) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --(1) Special Summon from hand When enemy control at least 1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    --(2) Destroy all Defense Position monsters
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)
    --(3) Add 1 Dragon monster from Deck to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
    --(4) Quick Effect: Destroy 1 card on both sides
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1)
    e4:SetTarget(s.destg2)
    e4:SetOperation(s.desop2)
    c:RegisterEffect(e4)
	--(5) Add 1 Spell/Trap from GY to hand when destroyed by effect. Can only be activated once per Duel
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg2)
	e5:SetOperation(s.thop2)
	e5:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL) -- This limits the effect to once per Duel ( I hope )
	c:RegisterEffect(e5)
    --(6) Special Summon 1 Dragon monster from hand when destroyed by battle
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,5))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_BATTLE_DESTROYED)
    e6:SetCondition(s.spcon2)
    e6:SetTarget(s.sptg2)
    e6:SetOperation(s.spop2)
    c:RegisterEffect(e6)
    --(7) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e7:SetValue(s.condition)
    c:RegisterEffect(e7)
end

-- (1) Special Summon from enemy control at least 1	
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
        and Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
-- (2) Destroy all Defense Position monsters
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(g,REASON_EFFECT)
end
-- (3) Add 1 Dragon monster from Deck to hand
function s.thfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
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
-- (4) Quick Effect: Destroy 1 card on both sides
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
        and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
-- (5) Add 1 Spell/Trap from GY to hand when destroyed by effect
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and (r&REASON_EFFECT)~=0
end
function s.thfilter2(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- (6) Special Summon 1 Dragon monster from hand when destroyed by battle
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
    -- Check if the card was destroyed by battle
    return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.spfilter2(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- (7) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster
function s.condition(e,c)
    return c:IsRace(RACE_DRAGON)
end