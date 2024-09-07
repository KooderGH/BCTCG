--Scripted By poka-poka
--Radiant Aphrodite
local s,id=GetID()
function s.initial_effect(c)
    -- Effect 1 : Special summon from hand by Tributing 1 monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0)) 
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
	-- Effect 2 : Cannot be attacked when you control other monster
	 local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCondition(s.atkcon)
    e2:SetTarget(s.atktg)
    e2:SetValue(aux.imval1)
    c:RegisterEffect(e2)
	 -- Effect 3 : Cannot attack the turn it is Special Summoned
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.atklimit)
	c:RegisterEffect(e3)
	-- Effect 4 : Can attack directly
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e4)
	-- Effect 5 : Destroy all Spell and Trap cards after direct attack
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DAMAGE_STEP_END)
    e5:SetCondition(s.descon)
    e5:SetTarget(s.destg)
    e5:SetOperation(s.desop)
    c:RegisterEffect(e5)
	-- Effect 6 : Neither player can set or activate set Spell/Trap cards
	-- cannot set spell/trap
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_SSET)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(1,1)
    e6:SetCondition(s.szcon)
    c:RegisterEffect(e6)
	-- cannot activate set spell/trap
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_CANNOT_ACTIVATE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(1,1)
    e7:SetCondition(s.szcon)
    e7:SetValue(s.aclimit)
    c:RegisterEffect(e7)
end
-- E1
-- SP summon 1 tribute
function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.CheckReleaseGroup(tp,nil,1,false,nil,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectReleaseGroup(tp,nil,1,1,false,nil,nil)
    Duel.Release(g,REASON_COST)
end
-- E2
-- Cannot be attacked when you control other monster
function s.atkcon(e)
    return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.atktg(e,c)
    return c==e:GetHandler()
end
-- E3
-- Cannot attack the turn it is Special Summoned
function s.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
-- E5
-- Condition: This card attacked directly
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()==nil and Duel.GetAttackTarget()==nil
end
-- Target: All Spell and Trap cards on the field
function s.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
-- Operation: Destroy all Spell and Trap cards on the field
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end
-- E6
-- Condition: You control no Set Spell/Trap cards
function s.szcon(e)
    return Duel.GetMatchingGroupCount(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)==0
end
-- Prevent the activation of Set Spell/Trap cards
function s.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsFacedown() and re:GetHandler():IsLocation(LOCATION_SZONE)
end