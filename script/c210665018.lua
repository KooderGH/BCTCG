--Hanzo’s Colossus Slaying Sword
--Scripted by poka-poka
--Effect :
--(1) Equip only to a FIRE Warrior monster.
--(2) It gains 300 ATK. If this card is equipped to "Hanzo", it gains 1000 ATK instead.
--(3) During damage calculation, if the equipped monster battles a monster with a higher level then it, Gain 300 ATK per difference of level.
--(4) During your Main Phase, if this card is in your GY: You can banish 2 FIRE Warrior monsters from your GY; Add this card to your hand.
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
    -- (3) ATK boost based on lvl difference
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.batkcon)
	e2:SetValue(s.batkval)
	c:RegisterEffect(e2)
    -- (4) Return to hand
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetCost(s.retcost)
    e3:SetTarget(s.rettg)
    e3:SetOperation(s.retop)
    c:RegisterEffect(e3)

end
-- (1) Equip only to a FIRE Warrior monster
function s.eqfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end
-- (2) ATK Boost Function
function s.atkval(e,c)
    if c:IsCode(210660649) then 
        return 1000
    else
        return 300
    end
end
-- (3) ATK boost based on lvl difference
function s.batkcon(e)
    local ec=e:GetHandler():GetEquipTarget()
    local bc=ec:GetBattleTarget()
    return bc and ec:IsLevelBelow(bc:GetLevel()-1)
end
function s.batkval(e,c)
    local ec=e:GetHandler():GetEquipTarget()
    local bc=ec:GetBattleTarget()
    return (bc:GetLevel()-ec:GetLevel())*300
end
-- (4) To hand 
function s.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_WARRIOR),tp,LOCATION_GRAVE,0,2,nil) end
    local g=Duel.SelectMatchingCard(tp,aux.FaceupFilter(Card.IsRace,RACE_WARRIOR),tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end

