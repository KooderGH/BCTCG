--Yamii
--Scripted by Gideon
-- (1) Monster's on your opponent side of the field with Fog Counter(s) cannot attack.
-- (2) During each end phase; Add 2 Fog Counter to each face-up monster that is Level 4 or higher.
-- (3) If this card would be destroyed; You can remove 3 Fog Counter(s) on the field instead.
-- (4) Fairy monster's you control cannot be returned to the hand.
-- (5) You can only control one "Yamii"
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --Opp monster with counters cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetTarget(s.stopfilter)
    c:RegisterEffect(e1)
    --End phase add 2 counter (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetOperation(s.fcoperation)
    c:RegisterEffect(e2)
    --If this card would be destroyed; You can remove 3 Fog Counter(s) on the field instead.
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.desreptg)
    e3:SetOperation(s.desrepop)
    c:RegisterEffect(e3)
    --Cannot return to hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(s.fairyfilter)
    c:RegisterEffect(e4)
end
--Fog counter
s.counter_place_list={0x1019}
--e1
function s.stopfilter(e,c)
    return c:GetCounter(0x1019)~=0
end
--e2
function s.levelfilter(c)
    return c:IsLevelAbove(4) and c:IsFaceup()
end
function s.fcoperation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(s.levelfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    for tc in aux.Next(g) do
        tc:AddCounter(0x1019,2)
    end
end
--e3
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
        and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x1019,3,REASON_COST) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RemoveCounter(tp,1,1,0x1019,3,REASON_EFFECT)
end
--e4
function s.fairyfilter(e,c)
    return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end