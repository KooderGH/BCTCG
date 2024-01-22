--Type-K41 Defence
--Scripted by Konstak.
--Effects:
--1 "Mighty Kristul Muu" (Fusion Monster)
--(1) Cannot be used as Fusion Material.
--(2) Must be Special Summoned only (from your Extra Deck) in Defense Position by sending "Mighty Kristul Muu" from your field to the GY. (You do not use "Polymerization") This Card Summon cannot be negated.
--(3) Cannot be returned to hand, Banished, or Tributed.
--(4) This card cannot be targeted by card effects and is unaffected by card effects except from itself.
--(5) This card's Position cannot be changed.
--(6) Neither player takes no battle damage from battles involving this card and other monsters you control cannot declare an attack.
--(7) When this card is Special Summoned, Destroy all card's on the field except this card. Neither player can activate cards or effects in response to this effect. 
--(8) If you would take effect damage, increase your LP by the same amount instead.
--(9) During your End Phase; This card loses 300 DEF.
--(10) If this card is in your GY: You can pay 3000 LP; Add this card to your Extra Deck.
--(11) You can only activate the following effects of "Type-K41 Defense" twice per turn (Igntion):
--* You can lower this card's DEF by 500 to Special Summon 1 "Piledriver K41 Token" (Machine/DARK/Level 2/ATK 0/DEF 1000). These token's cannot be destroyed by battle.
--* You can lower this card's DEF by 500 to Special Summon 1 "Driller K41 Token" (Machine/DARK/Level 2/ATK 1000/DEF 0). These token's cannot be targeted by card effects.
--* You can lower this card's DEF by 500 to Special Summon 1 "Thermae K41 Token" (Machine/DARK/Level 2/ATK 500/DEF 1500). These token's cannot be destroyed by card effects.
--(12) This card gains the following effect(s) of depending on the number of "Piledriver K41 Token" you control.
--*+1: Once per turn (Ignition): You can move one "Piledriver K41 Token" to a unoccupied Card Zone.
--*+2: During each player's Standby Phase: This card gains 1000 DEF.
--*+3: Once per turn (Ignition): You can Tribute one Token on the field; Add one card from your GY to your hand.
--*+4: Your opponent cannot Set cards.
--(13) This card gains the following effect(s) of depending on the number of "Driller K41 Token" you control.
--*+1: Once per turn (Ignition): You can move one "Driller K41 Token" to a unoccupied Card Zone.
--*+2: During each player's Standby Phase: Discard the top of your opponent's deck equal to the amount of monster's you control.
--*+3: Once per turn (Ignition): You can target cards in your opponent's GY based on the number of "Driller K41 Token"'s you control; Banish those targets.
--*+4: During your End Phase; Draw 1 card.
--(14) This card gains the following effect(s) of depending on the number of "Thermae K41 Token" you control.
--*+1: Once per turn (Ignition): You can move one "Thermae K41 Token" to a unoccupied Card Zone.
--*+2: During your Opponent's End Phase: Roll a six-sided die. Treat your opponent's Zone Columns as numbers 1-5, counting from your right and destroy the cards that are in the same Column as the result. If the result is 6, roll again.  
--*+3: Once per turn (Ignition): You can choose 1 of your opponent's unused Zones. Those zones cannot be used while "Type-K41 Defense" is face-up on the field.
--*+4: Once per turn (Ignition): You can activate this effect; Your opponent discards as many cards as possible from their hand, then, draws the same number of cards they discarded.
--(15) When this card is destroyed by battle; Destroy all cards you control. It is now the End Phase of this turn.

local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--Fusion.AddProcMix(c,true,true,210660463)
	Fusion.AddProcMixRep(c,true,true,s.fil,1,4)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
    --cannot be fusion material (1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Summon cannot be negated (2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--Cannot be Tributed (3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4)
	--Cannot be returned to hand (3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e5)
	--Cannot banish (3)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e6)
	--Cannot be targeted (Self) (4)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
    --This card is uneffected by card effects except from itself. (4)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_IMMUNE_EFFECT)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(s.efilter)
    c:RegisterEffect(e8)
	--This card's Position cannot be changed. (5)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_POSITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(POS_FACEUP_DEFENSE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e9)
	--No battle damage (6)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
    --opponent no battle damage (6)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e11)
	--cannot announce (6)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetTarget(s.antarget)
	c:RegisterEffect(e12)
    --destroy all spells/traps/monsters (7)
    local e13=Effect.CreateEffect(c)
    e13:SetCategory(CATEGORY_DESTROY)
    e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e13:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e13:SetCode(EVENT_SPSUMMON_SUCCESS)
    e13:SetTarget(s.smtg)
    e13:SetOperation(s.smop)
    c:RegisterEffect(e13)
	--effect damage to lp (8)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_REVERSE_DAMAGE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,0)
	e14:SetValue(s.rev)
	c:RegisterEffect(e14)
	--Remove 300 Def each end phase (9)
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(id,0))
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCode(EVENT_PHASE+PHASE_END)
	e15:SetCountLimit(1)
	e15:SetCondition(s.defcon)
	e15:SetOperation(s.defop)
	c:RegisterEffect(e15)
	--If this card is in your GY: You can pay 3000 LP to send this card to your extra deck (10)
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(id,1))
	e16:SetCategory(CATEGORY_TODECK)
	e16:SetType(EFFECT_TYPE_IGNITION)
	e16:SetRange(LOCATION_GRAVE)
	e16:SetCost(s.graverecoverycost)
	e16:SetTarget(s.graverecoverytg)
	e16:SetOperation(s.graverecoveryop)
	c:RegisterEffect(e16)
	--lower this card's DEF by 500 to Special Summon 1 "Piledriver K41 Token" (11)
	local e17=Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(id,2))
	e17:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCountLimit(2,{id,1},EFFECT_COUNT_CODE_OATH)
	e17:SetTarget(s.ssttg)
	e17:SetOperation(s.sstpop)
	c:RegisterEffect(e17)
	--1+ (12)
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(id,3))
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
	e20:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e20:SetRange(LOCATION_MZONE)
	e20:SetLabel(1)
	e20:SetCondition(s.pilecountcondition)
	e20:SetTarget(s.cardzonetarget)
	e20:SetOperation(s.cardzoneop)
	c:RegisterEffect(e20)
	--2+ (12)
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(id,4))
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e22:SetLabel(2)
	e22:SetCountLimit(1)
	e22:SetCondition(s.pilecountcondition)
	e22:SetOperation(s.defop2)
	c:RegisterEffect(e22)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsType(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsFaceup() and c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
end
function s.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function s.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
--(6) This card is uneffected by card effects except from itself.
function s.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
--(6) cannot announce
function s.antarget(e,c)
	return c~=e:GetHandler()
end
--(7) Destroy all S/T/M on the field
function s.summonfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function s.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.summonfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(s.summonfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function s.smop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.summonfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
--(8) effect damage to LP function
function s.rev(e,re,r,rp,rc)
	return (r&REASON_EFFECT)~=0
end
--(9) Def -300 function
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
--(10) GY to extra deck function
function s.graverecoverycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function s.graverecoverytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.graverecoveryop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
--Special Summon Piledriver K41 function
s.listed_names={210668001}
function s.ssttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.sstpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,210668001,0,TYPES_TOKEN,0,1000,2,RACE_MACHINE,ATTRIBUTE_DARK) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		local token1=Duel.CreateToken(tp,210668001)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
	    --Cannot be destroyed (1)
        local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
        token1:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function s.cardzonetarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.pilefilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.pilefilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=Duel.GetFirstTarget()
	local op=Duel.SelectEffect(tp,
		{tc,aux.Stringid(id,5)},
		{tc,aux.Stringid(id,6)})
	e:SetLabel(op)
	local g=(op==1 and g1 or g2)
end
function s.cardzoneop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 then
		Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2))
	else
	--Move to S/T
	Duel.MoveToField(tc,tp,tp,math.log(Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0),2),POS_FACEUP,true)
	end
end
function s.pilefilter(c)
    return c:IsFaceup() and c:IsCode(210668001)
end
function s.pilecountcondition(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.pilefilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
function s.defop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end