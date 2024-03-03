--Momotaro
--Scripted by Konstak
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) If you control no monster(s), you can Special Summon this card from your hand.
-- (3) You can only use 1 of these effects of "Momotaro" per turn, and only once that turn.
-- * If this card is Special Summoned; Add 1 Lv8 or lower WIND Machine monster from your Deck to your hand.
-- * If this card is sent to the GY: For each WIND monster you control, Target 1 Spell/Trap your opponent controls; Destroy those targets.
local s,id=GetID()
function s.initial_effect(c)
    --self destroy
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    e1:SetCondition(s.sdcon)
    c:RegisterEffect(e1)
    --Special Summon this card
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.spcon)
    c:RegisterEffect(e2)
    --summon and add one WIND machine monster from your deck to your hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(s.sstg)
    e3:SetOperation(s.ssop)
    e3:SetCountLimit(1,id)
    c:RegisterEffect(e3)
    --once sent to the graveyard destroy S/T based on the number of WIND machine you control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,id)
    e4:SetTarget(s.rmtg)
    e4:SetOperation(s.rmop)
    c:RegisterEffect(e4)
end
--Self Destroy Function
function s.sdfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.sdcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--Special Summon Function
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--Special Summon Search function
function s.spfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsLevelBelow(8) and c:IsAbleToHand()
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Destoy Spell/trap function
function s.rmfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE)
end
function s.stfilter(c)
	return c:IsSpellTrap() and c:IsDestructable()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    local gt=Duel.GetMatchingGroupCount(s.rmfilter,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return gt>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,gt,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.stfilter,tp,0,LOCATION_ONFIELD,gt,gt,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if #tg>0 then
        Duel.Destroy(tg,REASON_EFFECT)
    end
end