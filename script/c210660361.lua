--Aer
--Scripted by Gideon. Aid from Ignis Staff.
-- (1) During your Main phase, You can reveal this card in your hand until your opponent's End Phase: Each time your opponent activate's a monster effect, spell, and/or trap; Place 1 Fog Counter on the card that activated. You cannot Summon "Aer" while this card is revealed. You can only activate this effect of "Aer" once per turn.
-- (2) While you control 2 or more non-WIND Fairy monsters; This card cannot be destroyed by battle and you take no battle damage involving this card.
-- (3) When a Spell/Trap card is activated; place 1 Fog Counter(s) on this card.
-- (4) You can remove 2 Fog Counter(s) on the field and target 1 card on the field (Quick); Return that target to the owners hand. You can only use this effect of "Aer" once per turn.
-- (5) You can only control one "Aer"
local s,id=GetID()
function s.initial_effect(c)
	--Can only control one
	c:SetUniqueOnField(1,0,id)
	--Reveal (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(function(e,_,_,_,_,_,_,_,chk)if chk==0 then return not e:GetHandler():IsPublic()end end)
	e1:SetOperation(s.revop)
	c:RegisterEffect(e1)
	--Cannot be destroyed by battle (2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.battlecon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Avoid damage (2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetCondition(s.battlecon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--When a Spell/Trap card is activated add counter (3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.stacounter)
	c:RegisterEffect(e5)
	--Remove counters and Return
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(s.returncost)
	e6:SetTarget(s.returnst)
	e6:SetOperation(s.returnop)
	e6:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e6)
end
--E1 operation
function s.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Register flag effect
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	--Reveal until the end of opponent's turn.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(aux.chainreg)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_HAND)
	e3:SetOperation(s.acop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e3)
	--Cannot Summon Aer while revealed
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e4:SetRange(LOCATION_HAND)
    e4:SetTargetRange(1,0)
    e4:SetTarget(s.handlimit)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6)
end
--0x1019 = Fog Counter
s.counter_place_list={0x1019}
--E1 reveal part E2 E3
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local c=e:GetHandler()
	 if (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and p~=tp and loc&LOCATION_ONFIELD~=0 and c:GetFlagEffect(1)>0 then
		re:GetHandler():AddCounter(0x1019,1)
	end
end
--E1 reveal part E4
function s.handlimit(e,c)
	return c:IsCode(id)
end
--E2
function s.fairyfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_FAIRY) and not c:IsAttribute(ATTRIBUTE_WIND)
end
function s.battlecon(e)
    return Duel.IsExistingMatchingCard(s.fairyfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
--E3
function s.stacounter(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 if re:IsSpellTrapEffect() and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1019,1)
	end
end
--E6
function s.returncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,2,REASON_COST)
end
function s.returnst(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end