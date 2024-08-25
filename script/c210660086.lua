--Kamukura
--Scripted by The Weetizen
--poka-poka and & 9th Effect by konstak
--(1) If you control a Dragon monster on the field: You can Normal Summon this card without tributing.
--(2) If you Tribute Summon this card; You can return all card's your opponent controls.
--(3) This card cannot be destroyed by card effect's while on the field.
--(4) Each time monster(s) are destroyed by a card effect; This card gain's a Counter (max 6).
--(5) If this card has 3 counter(s) on it, this card can no longer attack. 
--(6) You can remove 3 counter(s) from this card and Target one Dragon monster from your GY; Special Summon it.
--(7) If this card is destroyed by a card effect: You can Target up to 2 Dragon monster's in your GY: Special Summon those target's.
--(8) When this card is destroyed by battle: You can Target 1 monster in your opponent's GY; Special Summon it to your side of the field.
--(9) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.

local s,id=GetID()
local COUNTER_FW=0x14c

function s.initial_effect(c)
    -- Enable counters and set counter limit
    c:EnableCounterPermit(COUNTER_FW)
    c:SetCounterLimit(COUNTER_FW, 6)
    -- (1) Normal Summon without tributing if you control a Dragon monster
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(s.ntcon)
    c:RegisterEffect(e1)
    -- (2) Return all opponent's cards to hand if Tribute Summoned
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(s.retcon)
    e2:SetTarget(s.rettg)
    e2:SetOperation(s.retop)
    c:RegisterEffect(e2)
    -- (3) Cannot be destroyed by card effects
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    -- (4) Gain counters when monster(s) are destroyed by a card effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(s.ctcon)
    e4:SetOperation(s.ctop)
    c:RegisterEffect(e4)
    -- (5) Lose the ability to attack when it has 3 counters
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_ATTACK)
    e5:SetCondition(s.atkcon)
    c:RegisterEffect(e5)
    -- (6) Remove 3 counters to Special Summon a Dragon from the player's own GY
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCost(s.spcost3)
    e6:SetTarget(s.sptg3)
    e6:SetOperation(s.spop3)
    c:RegisterEffect(e6)
    -- (7) Special Summon 2 Dragon monsters from GY when destroyed by card effect
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,2))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetCondition(s.spcon2)
    e7:SetTarget(s.sptg2)
    e7:SetOperation(s.spop2)
    c:RegisterEffect(e7)
    -- (8) Special Summon 1 opponent's monster from GY when destroyed by battle
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,3))
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_BATTLE_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(s.spcon)
    e8:SetTarget(s.sptg)
    e8:SetOperation(s.spop)
    c:RegisterEffect(e8)
    -- (9) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e9:SetValue(s.condition)
    c:RegisterEffect(e9)
end

-- (1) Normal Summon without tributing if you control a Dragon monster
function s.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_DRAGON),c:GetControler(),LOCATION_MZONE,0,1,nil)
end
-- (2) Return all opponent's cards to hand if Tribute Summoned
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
end
-- (4) Gain counters when monster(s) are destroyed by a card effect
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsType(TYPE_MONSTER) and eg:IsExists(function(c) return c:IsPreviousLocation(LOCATION_MZONE) end,1,nil)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    if c:GetCounter(COUNTER_FW) < 6 then
        c:AddCounter(COUNTER_FW, 1) 
    end
end
-- (5) Lose the ability to attack when it has 3 counters
function s.atkcon(e)
    return e:GetHandler():GetCounter(COUNTER_FW) >= 3
end
-- (6) Remove 3 counters to Special Summon a Dragon from the player's own GY
function s.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetCounter(COUNTER_FW) >= 3 end
    e:GetHandler():RemoveCounter(tp,COUNTER_FW,3,REASON_COST)
end
-- Filter function to check for Dragon monsters that can be Special Summoned from the own GY
function s.spfilter3(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- Target function to check if there is a Dragon monster in the own GY
function s.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
-- Operation function to Special Summon a Dragon monster from the own GY
function s.spop3(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter3, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end
-- (7) Special Summon 2 Dragon monsters from GY when destroyed by card effect
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,math.min(2,ft),tp,LOCATION_GRAVE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,math.min(2,ft),nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- (8) Special Summon 1 opponent's monster from GY when destroyed by battle
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE)
end
function s.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local g=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_GRAVE,nil,e,tp)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- (9) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster
function s.condition(e,c)
    return c:IsRace(RACE_DRAGON)
end
