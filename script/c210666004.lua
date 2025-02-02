--MOMOCO Fan's From a Different Dimension
--Scripted by poka-poka
--Effect : Can only activate this by paying half your LPs while controlling "Wonder MOMOCO". Special Summon as many of your banished monsters as possible. During the End Phase, banish all monsters that were Special Summoned by this effect.
local s,id=GetID()
function s.initial_effect(c)
    -- Activate: Pay half LP and Special Summon all banished monsters
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.cost)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
-- Condition: You must control "Wonder MOMOCO"
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,210660455),tp,LOCATION_MZONE,0,1,nil)
end
-- Cost: Pay half LP
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)//2)
end
-- Target: All your banished monsters.
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
            and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
    end
end
-- Activation: Special Summon all banished monsters & set up End Phase effect
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_REMOVED,0,nil,e,0,tp,false,false)
    if #g==0 then return end
    if #g>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=g:Select(tp,ft,ft,nil)
    end

    if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        local summonedGroup=Group.CreateGroup()
        summonedGroup:KeepAlive()
        summonedGroup:Merge(g)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetLabelObject(summonedGroup)
        e1:SetOperation(s.banish_op)
        Duel.RegisterEffect(e1,tp)
    end
end

-- Banish all summoned monsters at the End Phase
function s.banish_op(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if g and #g>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        g:DeleteGroup()
    end
end