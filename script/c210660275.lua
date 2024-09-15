--Midsummer Rabbit
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    -- (1) Special Summon from GY when discarded
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    -- (2) Add WATER monster from GY and deal LP damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.watertg)
    e2:SetOperation(s.waterop)
    c:RegisterEffect(e2)
    -- (3) Special Summon DARK monster from GY and self LP-damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.darktg)
    e3:SetOperation(s.darkop)
    c:RegisterEffect(e3)
    -- (4) Treated as 2 Tributes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e4:SetValue(s.ttval)
    c:RegisterEffect(e4)
end

-- (1) Special Summon condition
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DISCARD)
end
function s.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and not c:IsCode(210660212) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- (2) Add WATER monster and deal damage
function s.waterfilter(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function s.watertg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.waterfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.waterop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.waterfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
        Duel.ConfirmCards(1-tp,g)
        local dam=g:GetFirst():GetAttack()//2
        Duel.Damage(1-tp,dam,REASON_EFFECT)
    end
end
-- (3) Special Summon DARK monster and self-damage
function s.darktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.darkfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function s.darkfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.darkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.darkfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
        if Duel.GetLP(tp)>0 then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
-- (4) Double Tribute
function s.ttval(e,c)
    return c:IsLevelAbove(4)
end