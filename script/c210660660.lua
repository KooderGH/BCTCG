--Sea Serpent Daliasan
--Scripted by poka-poka
--Effect
--(1) You can Normal Summon this card without Tributing. If this card is Normal Summoned without Tributing, or is Special Summoned, its Level becomes 4 and its original ATK becomes 1800.
--(2) During your Main Phase, you can Normal Summon 1 Dragon type monster in addition to your Normal Summon (but not Set). (You can only gain this effect once per turn)
--(3) Before the damage step: If this card battle a monster with a lower level then it; Destroy that opposing monster.
--(4) When this card is destroyed by a card effect; You can add 1 FIRE Dragon monster from your GY to your hand.
--(5) When this card is destroyed by battle; You can add 1 FIRE Dragon monster from your deck to your hand.
local s,id=GetID()
function s.initial_effect(c)
    -- (1) Normal Summon without Tributing
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(s.ntcon)
    e1:SetOperation(s.ntop)
    c:RegisterEffect(e1)
    -- (2) Additional Normal Summon
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE, 0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(function(e, c) return c:IsRace(RACE_DRAGON) end)
	c:RegisterEffect(e2)  
    -- (3) Destroy monster with lower Level before damage step
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e3:SetCondition(s.descon)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
    -- (4) Add FIRE Dragon from GY when destroyed by card effect
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(s.gycon)
    e4:SetTarget(s.gytg)
    e4:SetOperation(s.gyop)
    c:RegisterEffect(e4)
    -- (5) Add FIRE Dragon from Deck when destroyed by battle
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCondition(s.battlecon)
    e5:SetTarget(s.battletg)
    e5:SetOperation(s.battleop)
    c:RegisterEffect(e5)
end
-- Normal Summon without Tributing condition
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>7 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack and level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1800)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(4)
	c:RegisterEffect(e2)
end
-- Destroy monster with lower Level before damage step condition
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local bc = c:GetBattleTarget()
    return bc and bc:IsFaceup() and bc:GetLevel() < c:GetLevel()
end
-- Destroy monster with lower Level operation
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local bc = e:GetHandler():GetBattleTarget()
    if bc then Duel.Destroy(bc,REASON_EFFECT) end
end
-- Add FIRE Dragon from GY when destroyed by card effect condition
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
-- Add FIRE Dragon from GY target
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
-- Add FIRE Dragon from GY operation
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp,s.gyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g > 0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- Filter for FIRE Dragon monsters in the Graveyard
function s.gyfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
-- Add FIRE Dragon from Deck when destroyed by battle condition
function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE)
end
-- Add FIRE Dragon from Deck target
function s.battletg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.battlefilter,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
-- Add FIRE Dragon from Deck operation
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp,s.battlefilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g > 0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- Filter for FIRE Dragon monsters in the Deck
function s.battlefilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end