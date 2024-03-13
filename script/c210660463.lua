--Mighty Kristual Muu
--Scripted by Gideon
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. If your LP are 3000 or lower than your opponent's and you control a EARTH Machine monster, You can Special Summon this card from your hand in Defense Position, then move this card to your Extra Monster Zone. 
-- (2) Cannot be returned to hand or banished.
-- (3) Cannot be targeted by card effects.
-- (4) This card's Position cannot be changed.
-- (5) Card's you control cannot be returned to hand or banished.
-- (6) If this card is in your GY: You can set your LP to the same LPs your opponent has; Add this card to your hand. You can only activate this effect once per duel.
-- (7) This card gains the following effect(s), based on the number of Earth Machine Monster(s) you control except "Mighty Kristul Muu":
-- * 1+: Monsters your opponent control can only target this card for attacks. During each End Phase; This card gains 1000 DEF.
-- * 2+: This card becomes uneffected by card effects except from itself.
-- * 3+: All monsters you control gain 500 ATK/DEF for each Machine type monster you control.
-- * 4+: Once per turn (Ignition): You can draw 2 cards.
-- * 5+: Machine type monsters you control can attack your opponents LP directly.
local s,id=GetID()
function s.initial_effect(c)
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
    --(4)Start
    --This card's Position cannot be changed.
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_SET_POSITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(POS_FACEUP_DEFENSE)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e7)
    --(4)Finish
    --(5)Start
    --Card's you control cannot be returned to hand or banished.
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_CANNOT_TO_HAND)
    e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTargetRange(LOCATION_ONFIELD,0)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e9)
    --(5)Finish
    --(6)Start
    --If this card is in your GY: You can set your LP to the same LPs your opponent has; Add this card to your hand.
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,0))
    e10:SetCategory(CATEGORY_TOHAND)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_GRAVE)
    e10:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e10:SetCost(s.graverecoverycost)
    e10:SetTarget(s.graverecoverytg)
    e10:SetOperation(s.graverecoveryop)
    c:RegisterEffect(e10)
    --(6)Finish
    --(7)Start
    --1+: Monsters your opponent control can only target this card for attacks. During each End Phase; This card gains 1000 DEF.
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0,LOCATION_MZONE)
    e11:SetValue(s.atlimit)
    e11:SetLabel(1)
    e11:SetCondition(s.emachcountcondition)
    c:RegisterEffect(e11)
    --Add 1000 DEF each turn +1 effect
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id,1))
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCode(EVENT_PHASE+PHASE_END)
    e12:SetLabel(1)
    e12:SetCountLimit(1)
    e12:SetCondition(s.defcon)
    e12:SetOperation(s.defop)
    c:RegisterEffect(e12)
    --2+: This card becomes uneffected by card effects except from itself.
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE)
    e13:SetCode(EFFECT_IMMUNE_EFFECT)
    e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetLabel(2)
    e13:SetCondition(s.emachcountcondition)
    e13:SetValue(s.imcon)
    c:RegisterEffect(e13)
    --3+: All monsters you control gain 500 ATK/DEF for each Machine type monster on the field
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_UPDATE_ATTACK)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_MZONE,0)
    e14:SetLabel(3)
    e14:SetCondition(s.emachcountcondition)
    e14:SetValue(s.adval)
    c:RegisterEffect(e14)
    local e15=e14:Clone()
    e15:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e15)
    --4+: Once per turn (Ignition): You can draw 2 cards.
    local e16=Effect.CreateEffect(c)
    e16:SetDescription(aux.Stringid(id,2))
    e16:SetCategory(CATEGORY_DRAW)
    e16:SetType(EFFECT_TYPE_IGNITION)
    e16:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e16:SetCode(EVENT_FREE_CHAIN)
    e16:SetCondition(s.emachcountcondition)
    e16:SetLabel(4)
    e16:SetCountLimit(1)
    e16:SetTarget(s.drawtarget)
    e16:SetOperation(s.drawop)
    c:RegisterEffect(e16)
    --5+: Machine type monsters you control can attack your opponents LP directly.
    local e17=Effect.CreateEffect(c)
    e17:SetType(EFFECT_TYPE_FIELD)
    e17:SetCode(EFFECT_DIRECT_ATTACK)
    e17:SetRange(LOCATION_MZONE)
    e17:SetTargetRange(LOCATION_MZONE,0)
    e17:SetLabel(5)
    e17:SetCondition(s.emachcountcondition)
    e17:SetTarget(s.dirtg)
    c:RegisterEffect(e17)
end
--1
function s.emachfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return (Duel.GetLP(1-tp)-Duel.GetLP(tp))>=3000
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(c:GetControler(),LOCATION_EMZONE,0) or Duel.CheckLocation(c:GetControler(),LOCATION_EMZONE,1))
        and Duel.IsExistingMatchingCard(s.emachfilter,tp,LOCATION_MZONE,0,1,nil)
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
--(6)
function s.graverecoverycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)~=Duel.GetLP(1-tp) end
	Duel.SetLP(tp,Duel.GetLP(1-tp))
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
--(7)Core
function s.emachfiltertwo(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and not c:IsCode(id)
end
function s.emachcountcondition(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.emachfiltertwo,tp,LOCATION_MZONE,0,nil)>=e:GetLabel()
end
--Can only ATK
function s.atlimit(e,c)
	return c:IsFacedown() or not c:IsCode(id)
end
--Def 1000 function 
function s.defcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and s.emachcountcondition(e)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
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
--Immune
function s.imcon(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--Atk Def gain
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsRace,RACE_MACHINE),c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*500
end
--direct attack
function s.easymechfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function s.dirtg(e,c)
	return Duel.IsExistingMatchingCard(s.easymechfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--draw
function s.drawtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end