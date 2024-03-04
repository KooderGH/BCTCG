--Shitakiri Sparrow
--Scripted by Konstak
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) When your opponent activates a monster effect; Add 1 Spell Counter(s) to this card (Max. 3).
-- (3) Cannot be destroyed by battle.
-- (4) When summoned, place in defense. 
-- (5) You can only use 1 of these effects of "Shitakiri Sparrow" per turn, and only once that turn.
-- * You can remove 3 Spell Counter(s) from this card to add 1 WIND monster from your Deck or GY to your hand.
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
    --Add counter (2)
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
    e3:SetCondition(s.acon)
    e3:SetOperation(s.acop)
    c:RegisterEffect(e3)
    --Cannot be destroyed by battle (3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --to defense (4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetCategory(CATEGORY_POSITION)
    e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetTarget(s.deftg)
    e5:SetOperation(s.defop)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e7)
    --add one wind monster from your deck or GY to hand
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,1))
    e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e8:SetType(EFFECT_TYPE_QUICK_O)
    e8:SetCode(EVENT_FREE_CHAIN)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1,id)
    e8:SetCost(s.srcost)
    e8:SetTarget(s.srtg)
    e8:SetOperation(s.srop)
    c:RegisterEffect(e8)
    --once sent to the graveyard add S/T from GY based on the number of 2 WIND monsters you control
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,2))
    e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e9:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e9:SetCode(EVENT_TO_GRAVE)
    e9:SetCountLimit(1,id)
    e9:SetTarget(s.addtg)
    e9:SetOperation(s.addop)
    c:RegisterEffect(e9)
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
function s.acon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(COUNTER_SPELL,1)
	end
end
--To defense
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
--Special Summon Search function
function s.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_SPELL,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,COUNTER_SPELL,3,REASON_COST)
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