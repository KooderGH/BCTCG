--Nurse Cat
--Scripted by Gideon & 6,7 by poka-poka
-- (1) During either player's turn (Quick): You can banish this card from your hand; Gain 500 LP for each card in your hand.
-- (2) Once per turn(ignition): you can activate this effect: Gain 400 LP for each card on the field.
-- (3) You take no Battle Damage from Battles involving this card.
-- (4) You can banish this card from your GY (Quick); Gain 300 LP for each card in your GY.
-- (5) If a monster(s) you control would be destroyed by battle or card effect, you can discard this card instead. You can only use this effect of "Nurse Cat" once per duel.
-- (6) effect that cannot be destroyed by battle. If opponent controls 4 or more monsters, negate this effect. 
-- (7) if this card destroy's a monster by battle, add 1 card from gy to hand.

local s,id=GetID()
function s.initial_effect(c)
	--recover banish hand (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(aux.selfbanishcost)
	e1:SetTarget(s.btarget)
	e1:SetOperation(s.boperation)
	c:RegisterEffect(e1)
	--Once per turn 400 recovery (2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.rtarget)
	e2:SetOperation(s.roperation)
	c:RegisterEffect(e2)
	--No battle damage (3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Banish recovery (4)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.selfbanishcost)
	e4:SetTarget(s.gravetarget)
	e4:SetOperation(s.graveoperation)
	c:RegisterEffect(e4)
	--Replace (5)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_HAND)
	e5:SetTarget(s.reptg)
	e5:SetValue(s.repval)
	e5:SetOperation(s.repop)
	e5:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e5)
	-- Cannot be destroyed by battle
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.indcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--destroy opponents monster, sent 1 card from gy to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCountLimit(1)
	e7:SetCondition(s.atkcon2)
	e7:SetTarget(s.atktg2)
	e7:SetOperation(s.atkop2)
	c:RegisterEffect(e7)
end
--e1
function s.btarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_HAND,0):FilterCount(aux.TRUE,e:GetHandler())>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.boperation(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
--e2
function s.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.roperation(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*400
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
--e4
function s.gravetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):FilterCount(aux.TRUE,e:GetHandler())>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function s.graveoperation(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)*300
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
--e5
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
end
--e6
function s.indcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)<4
end
--e7
function s.filter2(c)
    return c:IsAbleToHand()
end
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsMonster()
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end