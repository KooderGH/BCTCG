--Type-K41 Defense
--Scripted by Konstak.
--Effects:
--"Mighty Kristul Muu" (Fusion Monster)
--(1) Cannot be used as Fusion Material.
--(2) Must first be Special Summoned (from your Extra Deck) in Defense Position by sending the above card from your field to the GY. This Card Summon cannot be negated.
--(3) Cannot be returned to hand, Banished, or Tributed.
--(4) This card cannot be targeted by card effects.
--(5) This card's Position cannot be changed.
--(6) During your End Phase; This card loses 300 DEF.
--(7) If this card is in your GY: You can pay 3000 LP; Add this card to your Extra Deck.
--(8) This card is uneffected by card effects except from itself.
--(9) You take no battle damage from battles involving this card.
--(10) While you control this face-up card, you must skip your draw phase.
--(11) While you control this face-up card, ATK and DEF of Non-Dark Machine monsters you control becomes 0.
--(12) While you control this face-up card, you cannot activate T/S.
--(13) When this card is special summoned, Destroy all Monsters, Spells and Trap cards you currently control.
--(14) If you would take effect damage, decrease this card's DEF by that damage, instead.
-- (WIP)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,210660463)
	--Fusion.AddProcMixRep(c,true,true,s.fil,1,4)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
    --cannot be fusion material (1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Summon cannot be disabled (2)
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
	--This card's Position cannot be changed. (5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SET_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(POS_FACEUP_DEFENSE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e8)
	--Remove 200 Def each end phase (6)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,1))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetCountLimit(1)
	e9:SetCondition(s.defcon)
	e9:SetOperation(s.defop)
	c:RegisterEffect(e9)
	--If this card is in your GY: You can pay 3000 LP to send this card to your extra deck (7)
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetCategory(CATEGORY_TODECK)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_GRAVE)
	e10:SetCost(s.graverecoverycost)
	e10:SetTarget(s.graverecoverytg)
	e10:SetOperation(s.graverecoveryop)
	c:RegisterEffect(e10)
	--This card is uneffected by card effects except from itself. (8)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCondition(s.imcon)
    e11:SetValue(1)
    c:RegisterEffect(e11)
	--No battle damage (9)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e12:SetValue(1)
	c:RegisterEffect(e12)
	--Skip Draw Phase (10)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(1,0)
	e13:SetCode(EFFECT_SKIP_DP)
	c:RegisterEffect(e13)
    --opponent no battle damage (11)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e14)
	--The ATK of non-Dark Machine monsters on the field becomes 0. (12)
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(id,0))
	e15:SetCategory(CATEGORY_ATKCHANGE)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetCode(EFFECT_SET_ATTACK)
	e15:SetRange(LOCATION_MZONE)
	e15:SetTarget(s.atktarget)
	e15:SetTargetRange(LOCATION_MZONE,0)
	e15:SetValue(0)
	c:RegisterEffect(e15)
	local e16=e15:Clone()
	e16:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e16)
	--disable traps and spells
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_DISABLE)
	e17:SetRange(LOCATION_MZONE)
	e17:SetTargetRange(LOCATION_SZONE,0)
	e17:SetTarget(s.distg)
	c:RegisterEffect(e17)
	--disable activating effects Chain
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e18:SetCode(EVENT_CHAIN_SOLVING)
	e18:SetRange(LOCATION_MZONE)
	e18:SetOperation(s.disop)
	c:RegisterEffect(e18)
    --destroy all spells/traps
    local e19=Effect.CreateEffect(c)
    e19:SetDescription(aux.Stringid(id,0))
    e19:SetCategory(CATEGORY_DESTROY)
    e19:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e19:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e19:SetCode(EVENT_SPSUMMON_SUCCESS)
    e19:SetTarget(s.smtg)
    e19:SetOperation(s.smop)
    c:RegisterEffect(e19)
	--You take no effect damage and apply it into the def
    local e20=Effect.CreateEffect(c)
    e20:SetType(EFFECT_TYPE_FIELD)
    e20:SetCode(EFFECT_CHANGE_DAMAGE)
    e20:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e20:SetRange(LOCATION_MZONE)
    e20:SetTargetRange(1,0)
    e20:SetValue(s.dmgvalue2)
    c:RegisterEffect(e20)
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
--Def -300 function 
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
--(7) GY to extra deck function
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
--(8) uneffected by card effects
function s.imcon(e,re)
    local c=e:GetHandler()
    return c~=re:GetOwner() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
--(9) non-dark machine monsters function
function s.atktarget(e,c)
	return not (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK))
end
--(12) Negate all S/T you control function
function s.distg(e,c)
	return c~=e:GetHandler() and c:IsTrap() or c:IsSpell()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (tl&LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
--(13) Destroy all S/T you control function
function s.summonfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function s.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.summonfilter,tp,LOCATION_ONFIELD,0,1,c) end
	local sg=Duel.GetMatchingGroup(s.summonfilter,tp,LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.smop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.summonfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
--(14) You take no effect damage function
function s.dmgvalue2(e,re,val,r,rp,rc)
    if (r&REASON_EFFECT)==0 then return val end
    local c=e:GetHandler()
    local def=c:GetDefense()
    if def>val then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD)
        e1:SetValue(-val)
        c:RegisterEffect(e1)
        return 0
    else
        return val
    end
end