--By Tungnon
--Deep-Diver Kanna
--Scripted by senorpizza E1 - poka-poka E 2-5 
--You can target 1 LIGHT or DARK monster in either GY; banish it, and if you do, Special Summon this card from your hand. This is a Quick Effect if your opponent controls a monster. You can only activate this effect of "Deep-Diver Kanna" once per turn.
--Once per turn (Ignition): You can reveal 1 WATER monster in your hand and target 1 card on the field; Destroy that target, then player who controlled that card draws 1 card.
--If this card battles a WIND monster, this card gains 1000 ATK during the Damage Step only.
--If this card is destroyed by battle; Add 2 cards from the bottom of your deck to your hand.
--If this card is destroyed by a card effect; Draw 1 card. You can only use this effect of "Adventurer Kanna" once per turn.
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon itself from the hand (Ignition)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(aux.NOT(s.spquickcon))
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Special Summon itself from the hand (Quick if the opponent controls monsters)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(s.spquickcon)
	c:RegisterEffect(e2)
	-- Ignition effect to destroy and draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_DESTROY + CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(s.drcost)
    e3:SetTarget(s.drtg)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
    -- Gain ATK against WIND monsters
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(s.atkcon)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
    -- Add cards to hand if destroyed by battle
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCondition(s.battlecon)
    e5:SetTarget(s.battletg)
    e5:SetOperation(s.battleop)
    c:RegisterEffect(e5)
    -- Draw a card if destroyed by card effect
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id, 3))
    e6:SetCategory(CATEGORY_DRAW)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCondition(s.drawcon)
    e6:SetOperation(s.drawop)
    e6:SetCountLimit(1)
    c:RegisterEffect(e6)
end
function s.spfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
		and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and s.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spquickcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
-- Destroy and draw effect (Reveal WATER monster as cost)
function s.drcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttribute, tp, LOCATION_HAND, 0, 1, nil, ATTRIBUTE_WATER) end
    local g = Duel.SelectMatchingCard(tp, Card.IsAttribute, tp, LOCATION_HAND, 0, 1, 1, nil, ATTRIBUTE_WATER)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
-- Destroy target for draw effect
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 end
    local g = Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end
-- Draw effect operation
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local g = Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    if #g>0 then
        local tc=g:GetFirst()
        if Duel.Destroy(tc, REASON_EFFECT) ~= 0 then
            Duel.Draw(tc:GetPreviousControler(),1, REASON_EFFECT)
        end
    end
end
-- ATK gain condition
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsAttribute(ATTRIBUTE_WIND)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
	end
end
-- Add cards from deck to hand
function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.battletg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end

function s.battleop(e,tp,eg,ep,ev,re,r,rp)
    local g = Duel.GetDeckbottomGroup(tp, 2)
    if #g > 0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
    end
end
-- Draw
function s.drawcon(e)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end