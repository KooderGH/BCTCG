-- Hattori Hanzo
-- Scripted By poka-poka

local s,id=GetID()
function s.initial_effect(c)
    -- 1. Cannot be Normal Summoned/Set if you control no monster or control a non-FIRE Warrior Monster
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetCondition(s.sumcon)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e2)
    -- 2. When Normal Summoned: Special Summon 1 FIRE Warrior from hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
    -- 3. When Special Summoned: Add 1 Equip Card from Deck to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)
    -- 4. Cannot be returned (to Hand or Deck)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_TO_HAND)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_CANNOT_TO_DECK)
    c:RegisterEffect(e6)
    -- 5. Monsters this card destroys are banished
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
    e7:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e7)
    -- 6. When destroyed: Add 1 FIRE Warrior from GY to hand except "Hattori Hanzo"
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,2))
    e8:SetCategory(CATEGORY_TOHAND)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetCondition(s.thcon2)
    e8:SetTarget(s.thtg2)
    e8:SetOperation(s.thop2)
    c:RegisterEffect(e8)
	-- 7. Quick Effect: Anti Gaia
    local e15=Effect.CreateEffect(c)
    e15:SetDescription(aux.Stringid(id,4))
    e15:SetCategory(CATEGORY_DESTROY)
    e15:SetType(EFFECT_TYPE_QUICK_O)
    e15:SetCode(EVENT_FREE_CHAIN)
    e15:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e15:SetRange(LOCATION_MZONE)
    e15:SetCountLimit(1,id)
    e15:SetCondition(s.descon)
    e15:SetTarget(s.destg)
    e15:SetOperation(s.desop)
    c:RegisterEffect(e15)
    -- 8. Effect based on the number of Equip Cards equipped to it
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCondition(s.effcon1)
	e9:SetValue(s.atkval)
	e9:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e9)
    -- b. 2+: Opponent cannot activate monster effects during Battle Phase
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_CANNOT_ACTIVATE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e10:SetTargetRange(0, 1)
    e10:SetValue(s.aclimit)
    e10:SetCondition(s.effcon2)
    c:RegisterEffect(e10)
    -- c. 3+: Gain 1000 ATK for each Equip Card equipped to it
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(s.effcon3)
    e11:SetValue(s.atkup)
    c:RegisterEffect(e11)
    -- d. 4+: Double Battle Damage
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e12:SetCondition(s.effcon4)
    e12:SetValue(aux.ChangeBattleDamage(1, DOUBLE_DAMAGE))
    c:RegisterEffect(e12)
    -- e. 5+: Add all Equip Cards from GY to hand when removed
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(id,3))
	e13:SetCategory(CATEGORY_TOHAND)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e13:SetProperty(EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_TO_GRAVE)
	e13:SetCondition(s.effcon5)
	e13:SetTarget(s.rettg2)
	e13:SetOperation(s.retop2)
	c:RegisterEffect(e13)
	-- Track if this card was equipped with 5 or more Equip Cards when sent to GY
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e14:SetCondition(s.equipcheckcon)
	e14:SetValue(LOCATION_GRAVE)
	c:RegisterEffect(e14)
end

-- 1. Summon Condition
function s.sumcon(e)
    local c = e:GetHandler()
    -- Check if there are no monsters on the field
    local no_monsters = Duel.GetFieldGroupCount(e:GetHandlerPlayer(), LOCATION_MZONE, 0) == 0
    -- Check if there is any monster that is not both FIRE attribute and Warrior type
    local non_fire_warrior = Duel.IsExistingMatchingCard(s.nonfirewarriorfilter, e:GetHandlerPlayer(), LOCATION_MZONE, 0, 1, nil)
    return no_monsters or non_fire_warrior
end
-- Filter for monsters that are not both FIRE attribute and Warrior type
function s.nonfirewarriorfilter(c)
    return c:IsFaceup() and not (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR))
end
-- 2. Special Summon from hand
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- Filter for FIRE Warrior monsters in hand
function s.spfilter(c,e,tp)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- 3. Add Equip Card from Deck to hand
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- 6. When destroyed, add 1 FIRE Warrior from GY to hand except "Hattori Hanzo"
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.fwfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.fwfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- Filter for FIRE Warrior monsters in the Graveyard, excluding this card
function s.fwfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand() and not c:IsCode(id)
end
-- 7. Qucik Effect : Anti Gaia
function s.desfilter(c)
    return c:IsFaceup() and c:IsCode(210660493)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
-- 8. Effect based on Equip Cards
-- a. 1+: Gain ATK based on level difference during battle
function s.effcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipCount()>=1
end
function s.atkval(e,c)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if bc and bc:IsFaceup() and bc:GetLevel()>0 then
        return (bc:GetLevel() - c:GetLevel()) * 300
    else
        return 0
    end
end
-- b. 2+: Opponent cannot activate monster effects during Battle Phase
function s.effcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipCount()>=2 and Duel.IsBattlePhase()
end
function s.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER)
end
-- c. 3+: Gain 1000 ATK for each Equip Card equipped to it
function s.effcon3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipCount()>=3
end
function s.atkup(e,c)
    return e:GetHandler():GetEquipCount()*1000
end
-- d. 4+: Double Battle Damage
function s.effcon4(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipCount()>=4
end
-- (5) Add all Equip Cards from GY to hand if this card had 5 or more Equip Cards when sent to GY
function s.effcon5(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) 
        and c:IsReason(REASON_EFFECT+REASON_BATTLE) 
        and c:GetFlagEffect(id)>0
end
function s.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_GRAVE,0,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
    -- Apply effect to ignore hand size limit
    local e15=Effect.CreateEffect(e:GetHandler())
    e15:SetType(EFFECT_TYPE_FIELD)
    e15:SetCode(EFFECT_HAND_LIMIT)
    e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e15:SetTargetRange(1,0)
    e15:SetValue(99)
    e15:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
    Duel.RegisterEffect(e15,tp)
end
-- Track if this card was equipped with 5 or more Equip Cards when sent to GY
function s.equipcheckcon(e)
    local c=e:GetHandler()
    if c:GetEquipGroup():IsExists(Card.IsType,5,nil,TYPE_EQUIP) then
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE,0,1)
        return true
    end
    return false
end
-- Filter for Equip Spell Cards
function s.eqfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end