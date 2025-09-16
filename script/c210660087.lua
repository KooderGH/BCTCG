--Raiden
--Scripted by Konstak e1-6 Poka e7
--Effect
-- (1) When this card is Tributed Summoned; Destroy all monster's on the field except "Raiden".
-- (2) If you control no monsters; You can Special Summon this card from your hand. If Summoned this way, your opponent's monster's cannot be destroyed by battle this turn.
-- (3) Cannot be tributed.
-- (4) Does piercing damage.
-- (5) When this card is destroyed by a card effect: You can target one card in your hand; Destroy it.
-- (6) When this card is destroyed by battle: You can target one card your opponent controls: Destroy it.
-- (7) You can normal summon/set this card without tribute but your opponent cannot take battle damage from Raiden this turn.
local s,id=GetID()
function s.initial_effect(c)
    --once tributed summon (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    --Special Summon this card (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.spcon)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    --cannot be tributed (3)
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
    --pierce (4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e5)
    --When destroyed by card effect (5)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(s.descon)
    e3:SetTarget(s.destg2)
    e3:SetOperation(s.desop2)
    c:RegisterEffect(e3)
    --When destroyed by battle (6)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(s.descon2)
    e4:SetTarget(s.destg3)
    e4:SetOperation(s.desop3)
    c:RegisterEffect(e4)
	--(7)normal summon / set without tribute but your opponent cannot take battle damage from Raiden this turn.
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,3))
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SUMMON_PROC)
	e6:SetCountLimit(1,id)
	e6:SetCondition(s.ntcon)
	e6:SetOperation(s.ntop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e7)
end
--Destroy all except this card
function s.destroyfilter(c)
    return c:IsMonster() and not c:IsCode(id)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.destroyfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(s.destroyfilter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(s.destroyfilter,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
--Special Summon Function
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
end
--Add when destroyed by effect function (5)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,c)
    if chk==0 then return #g>=1 and aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),0) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,c)
    if #g<1 then return end
    local dg=aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_DESTROY)
    Duel.Destroy(dg,REASON_EFFECT)
end
--Add when destroyed by battle function (6)
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.destg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop3(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--summon & set with no tribute (7)
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--opponent takes no battle damage from this card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END-RESET_TOFIELD)
	e1:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e1)
end