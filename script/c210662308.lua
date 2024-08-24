-- Snowball
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    aux.AddNormalSetProcedure(c)
    --self destroy
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    c:RegisterEffect(e1)
    --Death Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetTarget(s.sstg)
    e2:SetOperation(s.ssop)
    c:RegisterEffect(e2)
end
function s.specialfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.specialfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    end
    --Return To Hand
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
    e1:SetLabel(Duel.GetTurnCount())
    e1:SetReset(RESET_PHASE+PHASE_MAIN1,5)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetOperation(s.returnop)
    Duel.RegisterEffect(e1,tp)
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==4 then
        ct=0
        c:SetTurnCounter(ct)
        Duel.Hint(HINT_CARD,0,id)
        Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
    end
end