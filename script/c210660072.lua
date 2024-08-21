-- Maeda Keiji
--Scripted By poka-poka
local s,id=GetID()
function s.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
    -- Cannot be Special Summoned
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    
	-- Cannot be Set
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_MSET)
    e1:SetCondition(aux.TRUE)
    c:RegisterEffect(e1)
    
	-- Cannot be returned or banished
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_CANNOT_TO_HAND)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EFFECT_CANNOT_TO_DECK)
    c:RegisterEffect(e4)
	
	-- Gain ATK when taking LP damage
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_DAMAGE)
    e5:SetCondition(s.atkcon)
    e5:SetOperation(s.atkop)
    c:RegisterEffect(e5)
	-- Sent to Graveyard if non-FIRE Warrior is controlled
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_SELF_TOGRAVE)
    e6:SetCondition(s.tgcon)
    c:RegisterEffect(e6)
	
	-- Cannot be Normal Summoned unless you control a face-up FIRE Warrior monster
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_SUMMON)
    e7:SetCondition(s.sumcon)
    c:RegisterEffect(e7)
	
    -- Gain ATK when any monster is destroyed by battle
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_BATTLE_DESTROYED)
    e8:SetCondition(s.batcon)
    e8:SetOperation(s.batop)
    c:RegisterEffect(e8)
    
    -- Gain ATK for each equip card
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetValue(s.eqatk)
    c:RegisterEffect(e9)
    
    -- Destroy equip card instead of this card
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_DESTROY_REPLACE)
    e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
    e10:SetRange(LOCATION_MZONE)
    e10:SetTarget(s.desreptg)
    e10:SetOperation(s.desrepop)
    c:RegisterEffect(e10)
end

-- Sent to Graveyard if non-FIRE Warrior is controlled
function s.nonfirewarriorfilter(c)
    return c:IsMonster() and (not c:IsAttribute(ATTRIBUTE_FIRE) or not c:IsRace(RACE_WARRIOR))
end
function s.tgcon(e)
    return Duel.IsExistingMatchingCard(s.nonfirewarriorfilter, e:GetHandlerPlayer(), LOCATION_MZONE, 0, 1, nil)
end

-- Cannot be Set
function s.setcon(e, c, minc)
    return false
end

-- Gain ATK when taking LP damage
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() then
        c:UpdateAttack(400)
    end
end

-- Gain ATK when any monster is destroyed by battle
function s.batcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsType, 1, nil, TYPE_MONSTER) and eg:IsExists(Card.IsReason, 1, nil, REASON_BATTLE)
end

function s.batop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() then
        local ct=eg:FilterCount(Card.IsType, nil, TYPE_MONSTER)
        c:UpdateAttack(ct * 400)
    end
end

-- Gain ATK for each equip card
function s.eqatk(e,c)
    return c:GetEquipCount()*400
end

-- Destroy equip card instead of this card
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
            and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_SZONE,0,1,nil)
    end
    return true
end
function s.desrepop(e,tp,eg,ep,ev,re,rp)
    local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_SZONE,0,1,1,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
    end
end
function s.eqfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsDestructable()
end

-- Condition function to check if the player controls a face-up FIRE Warrior monster
function s.sumcon(e)
    return not Duel.IsExistingMatchingCard(s.cfilter, e:GetHandlerPlayer(), LOCATION_MZONE, 0, 1, nil)
end

-- Filter function to identify FIRE Warrior monsters
function s.cfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)
end