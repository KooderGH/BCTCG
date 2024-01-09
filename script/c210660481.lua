--Doktor Heaven
--Scripted by Gideon with a LOT of Naim's help. Credit to Larry for the Summon condition. Special thanks to Naim for EMZ move ooperation.
--Effect
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect. If your LP are 2000 or higher than your opponent's and you control a DARK Warrior monster, you can Special Summon this card (from your hand), then move this card to your Extra Monster Zone. This card Summon cannot be negated.
-- (2) Cannot be returned to hand, banished, or tributed.
-- (3) Cannot be targeted by card effects.
-- (4) You can only control 1 "Doktor Heaven".
-- (5) Each player must pay 500 LP for each monster they Normal Summon, Special Summon, Set and for each card they activate from their hand.
-- (6) If this card is in your GY: you can pay 1000 LP; add this card to your hand. You cannot Special Summon monster's the turn you activate this effect. You can only activate this effect of "Doktor Heaven" once per turn.
-- (7) This card gains the following effect(s), based on the number of DARK Warrior Monster(s) you control:
-- ● 1+: When a monster declares an attack (Quick Effect); You can negate the attack. You can only use this effect of "Doktor Heaven" once per turn.
-- ● 2+: Once per turn: You can target one DARK Warrior monster in your GY; add it to your hand.
-- ● 3+: When you inflict effect damage to your opponent, gain LP equal to the same amount.
-- ● 4+: During your opponent's turn, when your opponent activates a Spell Card: you can negate the activation and if you do, destroy it. You can only use this effect of "Doktor Heaven" once per turn.
-- ● 5+: Monsters you control cannot be destroyed by card effects.
local s,id=GetID()
function s.initial_effect(c)
	--(4)Effect part right here
	c:SetUniqueOnField(1,0,id)
	--(1)Start
	--Makes it unsummonable via normal
	c:EnableUnsummonable()
	--Cannot be SS by other ways other then it's own effect via above and this function
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--SS from Hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.ssummoncon)
	c:RegisterEffect(e1)
	--Move to EMZ
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(s.mvop)
    c:RegisterEffect(e2)
	--Summon cannot be disabled (Hopefully)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--(1)Finish
	--(2)Start
	--Cannot be Tributed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--Cannot be returned to hand
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	--Cannot banish
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e7)
	--(2)Finish
	--(3)Start
	--Cannot be targeted (self)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--(3)Finish
	--(5)Start
	--activate cost
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_ACTIVATE_COST)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,1)
	e9:SetTarget(s.payactarget)
	e9:SetCost(s.paycostchk)
	e9:SetOperation(s.paycostop)
	c:RegisterEffect(e9)
	--summon cost
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SUMMON_COST)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e10:SetCost(s.paycostchk)
	e10:SetOperation(s.paycostop)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e11)
	--set cost
	local e12=e10:Clone()
	e12:SetCode(EFFECT_MSET_COST)
	c:RegisterEffect(e12)
	local e13=e10:Clone()
	e13:SetCode(EFFECT_SSET_COST)
	c:RegisterEffect(e13)
	--accumulate
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(id)
	e14:SetRange(LOCATION_MZONE)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,1)
	c:RegisterEffect(e14)
	--(5)Finish
	--(6)Start
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(id,1))
	e15:SetCategory(CATEGORY_TOHAND)
	e15:SetType(EFFECT_TYPE_IGNITION)
	e15:SetRange(LOCATION_GRAVE)
	e15:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e15:SetCost(s.graverecoverycost)
	e15:SetTarget(s.graverecoverytg)
	e15:SetOperation(s.graverecoveryop)
	c:RegisterEffect(e15)
	--(6)Finish
	--(7)Start
	--Disable attack +1
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(id,2))
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCode(EVENT_ATTACK_ANNOUNCE)
	e16:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e16:SetLabel(1)
	e16:SetOperation(function() Duel.NegateAttack() end)
	e16:SetCondition(s.dwarcondition)
	c:RegisterEffect(e16)
	--Recover DARK Warrior in grave +2
	local e17=Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(id,3))
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
	e17:SetLabel(2)
	e17:SetCondition(s.dwarcondition)
	e17:SetTarget(s.darkwargravetarget)
	e17:SetOperation(s.darkwargraveoperation)
	c:RegisterEffect(e17)
	--LP gain +3
	local e18=Effect.CreateEffect(c)
	e18:SetDescription(aux.Stringid(id,4))
	e18:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e15:SetCategory(CATEGORY_RECOVER)
	e18:SetCode(EVENT_DAMAGE)
	e18:SetRange(LOCATION_MZONE)
	e18:SetLabel(3)
	e18:SetCondition(s.lpgaincondition)
	e18:SetOperation(s.lpgainop)
	c:RegisterEffect(e18)
	--Negate spell +4
	local e19=Effect.CreateEffect(c)
	e19:SetDescription(aux.Stringid(id,5))
	e19:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e19:SetType(EFFECT_TYPE_QUICK_O)
	e19:SetRange(LOCATION_MZONE)
	e19:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e19:SetCode(EVENT_CHAINING)
	e19:SetLabel(4)
	e19:SetCountLimit(1,{id,3},EFFECT_COUNT_CODE_OATH)
	e19:SetCondition(s.negatecondition)
	e19:SetTarget(s.negatetarget)
	e19:SetOperation(s.negateoperation)
	c:RegisterEffect(e19)
	--Cannot be destroyed +5
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e20:SetRange(LOCATION_MZONE)
	e20:SetTargetRange(LOCATION_MZONE,0)
	e20:SetTarget(aux.TRUE)
	e20:SetLabel(5)
	e20:SetValue(1)
	e20:SetCondition(s.dwarcondition)
	c:RegisterEffect(e20)
	--(7) Finished. IE's done
end
--(1) functions
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return (Duel.GetLP(tp)-Duel.GetLP(1-tp))>=2000
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(c:GetControler(),LOCATION_EMZONE,0) or Duel.CheckLocation(c:GetControler(),LOCATION_EMZONE,1))
        and Duel.IsExistingMatchingCard(s.dwarriorfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    if (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1)) then
        local lftezm=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,5) and 0x20 or 0
        local rgtemz=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,6) and 0x40 or 0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~ZONES_EMZ|(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--(5) functions
function s.payactarget(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_HAND)
end
function s.paycostchk(e,te_or_c,tp)
	local ct=#{Duel.GetPlayerEffect(tp,id)}
	return Duel.CheckLPCost(tp,ct*500)
end
function s.paycostop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.PayLPCost(tp,500)
end
--(6) functions
function s.graverecoverycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
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
--(7) functions core
function s.dwarriorfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
end
function s.dwarcondition(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.dwarriorfilter,tp,LOCATION_MZONE,0,nil)>=e:GetLabel()
end
--(7) Dark warrior grave functions +2
function s.darkwarfiltergrave(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function s.darkwargravetarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.darkwarfiltergrave(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.darkwarfiltergrave,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.darkwarfiltergrave,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.darkwargraveoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--(7) LP gain functions +3
function s.lpgaincondition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and r&REASON_EFFECT>0 and rp==tp and s.dwarcondition(e)
end
function s.lpgainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
--(7) Negate functions +4
function s.negatecondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp) and s.dwarcondition(e) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.negatetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negateoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end