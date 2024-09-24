--Doktor Heaven
--Scripted by Gideon with a LOT of Naim's help. Credit to Larry for the Summon condition. Special thanks to Naim for EMZ move ooperation.
--Effect
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect. If your LP are 1000 or higher than your opponent's and you control a DARK Warrior monster, you can Special Summon this card (from your hand), then move this card to your Extra Monster Zone. This card Summon cannot be negated.
-- (2) Cannot be returned to hand or banished.
-- (3) Cannot be targeted by card effects.
-- (4) You can only control 1 "Doktor Heaven".
-- (5) Each player must pay 500 LP for each monster they Normal Summon, Special Summon, Set and for each card they activate from their hand.
-- (6) If this card is in your GY: you can pay 1000 LP; add this card to your hand. You cannot Special Summon monster's the turn you activate this effect.
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
    --Cannot be returned to hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Cannot banish
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e5)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --(3)Finish
    --(5)Start
    --activate cost
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_ACTIVATE_COST)
    e7:SetRange(LOCATION_MZONE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetTargetRange(1,1)
    e7:SetTarget(s.payactarget)
    e7:SetCost(s.paycostchk)
    e7:SetOperation(s.paycostop)
    c:RegisterEffect(e7)
    --summon cost
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_SUMMON_COST)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
    e8:SetCost(s.paycostchk)
    e8:SetOperation(s.paycostop)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EFFECT_SPSUMMON_COST)
    c:RegisterEffect(e9)
    --set cost
    local e10=e8:Clone()
    e10:SetCode(EFFECT_MSET_COST)
    c:RegisterEffect(e10)
    local e11=e8:Clone()
    e11:SetCode(EFFECT_SSET_COST)
    c:RegisterEffect(e11)
    --accumulate
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(id)
    e12:SetRange(LOCATION_MZONE)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetTargetRange(1,1)
    c:RegisterEffect(e12)
    --(5)Finish
    --(6)Start
    local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(id,1))
    e13:SetCategory(CATEGORY_TOHAND)
    e13:SetType(EFFECT_TYPE_IGNITION)
    e13:SetRange(LOCATION_GRAVE)
    e13:SetCost(s.graverecoverycost)
    e13:SetTarget(s.graverecoverytg)
    e13:SetOperation(s.graverecoveryop)
    c:RegisterEffect(e13)
    --(6)Finish
    --(7)Start
    --Disable attack +1
    local e14=Effect.CreateEffect(c)
    e14:SetDescription(aux.Stringid(id,2))
    e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e14:SetRange(LOCATION_MZONE)
    e14:SetCode(EVENT_ATTACK_ANNOUNCE)
    e14:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
    e14:SetLabel(1)
    e14:SetOperation(function() Duel.NegateAttack() end)
    e14:SetCondition(s.dwarcondition)
    c:RegisterEffect(e14)
    --Recover DARK Warrior in grave +2
    local e15=Effect.CreateEffect(c)
    e15:SetDescription(aux.Stringid(id,3))
    e15:SetType(EFFECT_TYPE_IGNITION)
    e15:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e15:SetRange(LOCATION_MZONE)
    e15:SetCountLimit(1,{id,2},EFFECT_COUNT_CODE_OATH)
    e15:SetLabel(2)
    e15:SetCondition(s.dwarcondition)
    e15:SetTarget(s.darkwargravetarget)
    e15:SetOperation(s.darkwargraveoperation)
    c:RegisterEffect(e15)
    --LP gain +3
    local e16=Effect.CreateEffect(c)
    e16:SetDescription(aux.Stringid(id,4))
    e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e16:SetCategory(CATEGORY_RECOVER)
    e16:SetCode(EVENT_DAMAGE)
    e16:SetRange(LOCATION_MZONE)
    e16:SetLabel(3)
    e16:SetCondition(s.lpgaincondition)
    e16:SetOperation(s.lpgainop)
    c:RegisterEffect(e16)
    --Negate spell +4
    local e17=Effect.CreateEffect(c)
    e17:SetDescription(aux.Stringid(id,5))
    e17:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e17:SetType(EFFECT_TYPE_QUICK_O)
    e17:SetRange(LOCATION_MZONE)
    e17:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e17:SetCode(EVENT_CHAINING)
    e17:SetLabel(4)
    e17:SetCountLimit(1,{id,3},EFFECT_COUNT_CODE_OATH)
    e17:SetCondition(s.negatecondition)
    e17:SetTarget(s.negatetarget)
    e17:SetOperation(s.negateoperation)
    c:RegisterEffect(e17)
    --Cannot be destroyed +5
    local e18=Effect.CreateEffect(c)
    e18:SetType(EFFECT_TYPE_FIELD)
    e18:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e18:SetRange(LOCATION_MZONE)
    e18:SetTargetRange(LOCATION_MZONE,0)
    e18:SetTarget(aux.TRUE)
    e18:SetLabel(5)
    e18:SetValue(1)
    e18:SetCondition(s.dwarcondition)
    c:RegisterEffect(e18)
    --(7) Finished. IE's done
end
--(1) functions
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return (Duel.GetLP(tp)-Duel.GetLP(1-tp))>=1000
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(c:GetControler(),LOCATION_EMZONE,0) or Duel.CheckLocation(c:GetControler(),LOCATION_EMZONE,1))
        and Duel.IsExistingMatchingCard(s.dwarriorfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local lftezm=Duel.CheckLocation(tp,LOCATION_EMZONE,0) and 0x20 or 0
    local rgtemz=Duel.CheckLocation(tp,LOCATION_EMZONE,1) and 0x40 or 0
    if (lftezm>0 or rgtemz>0) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~(lftezm|rgtemz))
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
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetTargetRange(1,0)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
        e2:SetDescription(aux.Stringid(id,1))
        e2:SetReset(RESET_PHASE+PHASE_END)
        e2:SetTargetRange(1,0)
        Duel.RegisterEffect(e2,tp)
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