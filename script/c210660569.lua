--Gravi
--Scripted by Gideon. Help with naim on (4)
-- (1) Once during either player's turn (Quick): You can remove 3 Fog Counter on the field; You take no battle damage and your monsters cannot be destroyed by battle the turn you use this effect.
-- (2) If there is 3 or more Fog Counter(s) on the field; This card can attack directly.
-- (3) After this card deals direct battle damage: You can remove 3 Fog Counter(s) on the field; Draw 1 card.  
-- (4) Monster's you control with 4 or more Fog Counter(s) cannot be targeted for effects.
-- (5) During your end phase: If this card did not attack this turn; Add 3 Fog Counter(s) on this card.
-- (6) You can only control one "Gravi"
local s,id=GetID()
function s.initial_effect(c)
	--Can only control one
	c:SetUniqueOnField(1,0,id)
	--Remove 3 counter, waboku (1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.wabocost)
	e1:SetOperation(s.wabopop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--direct attack (2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(s.dircon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Draw direct atk (3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.drawcondition)
	e3:SetCost(s.drawcost)
	e3:SetTarget(s.drawtarget)
	e3:SetOperation(s.drawoperation)
	c:RegisterEffect(e3)
	--4 or more fog counters, cannot be targeted for effects (4)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(s.fogtarget)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	--If did not atk, Add 3 Fog (5)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetCondition(s.placecon)
	e5:SetOperation(s.placeop)
	c:RegisterEffect(e5)
end
--Fog counter
s.counter_place_list={0x1019}
--e1
function s.wabocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,3,REASON_COST)
end
function s.wabopop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
--e2
function s.dircon(e,c)
	return Duel.GetCounter(0,1,1,0x1019)>=3
end
--e3
function s.drawcondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function s.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,3,REASON_COST)
end
function s.drawtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drawoperation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--e4
function s.fogtarget(e,c)
    return c:GetCounter(0x1019)>=4
end
--e5
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetAttackedCount()==0
end
function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1019,3)
end