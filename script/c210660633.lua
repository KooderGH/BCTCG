--Shitakiri Sparrow
--Scripted by Konstak
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) When a Spell card is activated; Add 1 Spell Counter(s) to this card.
-- (3) You can only use 1 of these effects of "Shitakiri Sparrow" per turn, and only once that turn.
-- * You can remove 2 Spell Counter(s) from this card to add 1 WIND monster from your Deck or GY to your hand.
-- * If this card is sent to the GY; For every 2 WIND monsters you control, add 1 Spell card from your GY to your hand.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(COUNTER_SPELL)
    --self destroy (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    e1:SetCondition(s.sdcon)
    c:RegisterEffect(e1)
    --Add counter
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(aux.chainreg)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(s.acop)
    c:RegisterEffect(e3)
    --add one wind monster from your deck or GY to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,id)
    e4:SetCost(s.srcost)
    e4:SetTarget(s.srtg)
    e4:SetOperation(s.srop)
    c:RegisterEffect(e4)
    --once sent to the graveyard add S/T from GY based on the number of 2 WIND monsters you control
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1,id)
    e5:SetTarget(s.addtg)
    e5:SetOperation(s.addop)
    c:RegisterEffect(e5)
end
s.counter_place_list={COUNTER_SPELL}
--Self Destroy Function
function s.sdfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.sdcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--add counter
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(COUNTER_SPELL,1)
	end
end
--Special Summon Search function
function s.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_SPELL,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,COUNTER_SPELL,2,REASON_COST)
end
function s.srfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--add Spell from GY function
function s.addfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.spellfilter(c)
	return c:IsSpell()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    local gt=Duel.GetMatchingGroupCount(s.addfilter,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return gt>1 and Duel.IsExistingMatchingCard(s.spellfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local g=Duel.SelectTarget(tp,s.spellfilter,tp,LOCATION_GRAVE,0,math.floor(gt/2),math.floor(gt/2),nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg=Duel.GetTargetCards(e)
    if #tg>0 then
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(tp,tg)
    end
end