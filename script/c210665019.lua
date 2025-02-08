--The Immortal’s Tekko-Kagi
--Scripted by poka-poka
--Effect :
--(1) Equip only to a FIRE Warrior monster.
--(2) It gains 300 ATK. If this card is equipped to "Sanada Yukimura", it gains 2000 ATK instead.
--(3) The monster equipped with this card gains piercing battle damage.
--(4) When the equipped monster destroys a Defense Position monster, negate that monster's effects.
--(5) During your Main Phase, if this card is in your GY: You can banish this card; Add 1 Equip spell from your deck to your hand except for "The Immortal's Tekko-Kagi".
local s,id=GetID()
function s.initial_effect(c)
    -- (1) Equip only to a FIRE Warrior monster
    aux.AddEquipProcedure(c,nil,s.eqfilter)
    -- (2) ATK boost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)
    -- (3) Piercing battle damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
    -- (4) Negate effect of destroyed Defense Position monsters
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.negcon)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
    -- (5) Search an Equip Spell from Deck if in GY
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1)
    e5:SetCost(aux.bfgcost)
    e5:SetTarget(s.thtg)
    e5:SetOperation(s.thop)
    c:RegisterEffect(e5)

end
-- (1) Equip only to a FIRE Warrior monster
function s.eqfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end
-- (2) ATK Boost Function
function s.atkval(e,c)
    if c:IsCode(210660071) then 
        return 2000
    else
        return 300
    end
end
-- (4) Negate the effect of destroyed Defense Position monsters
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ec=c:GetEquipTarget()
    local at=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return ec and at==ec and d and d:IsControler(1-tp) and d:IsPosition(POS_DEFENSE)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d then
        d:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
    end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc and tc:GetFlagEffect(id)>0
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if tc then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end
-- (5) Search an Equip Spell from Deck
function s.thfilter(c)
    return c:IsType(TYPE_EQUIP) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
