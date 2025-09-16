--Uesugi Kenshin
--Scripted By poka-poka
local s,id=GetID()
function s.initial_effect(c)
    -- (1) Trigger when this card attacks while equipped, before damage step, return battling monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.retcon)
    e1:SetOperation(s.retop)
    c:RegisterEffect(e1)
    
    -- (2) Opponent must discard a card after Special Summoning
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.discardcon)
    e2:SetOperation(s.discardop)
    c:RegisterEffect(e2)

    -- (3) Special Summon FIRE Warrior from GY if this card was equipped when sent to GY
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)

    -- Track if this card was equipped when sent to GY
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCondition(s.equipcheckcon)
    e4:SetValue(LOCATION_GRAVE)
    c:RegisterEffect(e4)
end

-- (1) Trigger when this card attacks while equipped, before damage step, return battling monster
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetAttacker()==c and c:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_EQUIP) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
        Duel.NegateAttack() -- Cancels the battle after returning the monster
        -- Search and add a FIRE Warrior from the GY to the hand (Optional)
        if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) then
            if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
                if #g>0 then
                    Duel.SendtoHand(g,nil,REASON_EFFECT)
                    Duel.ConfirmCards(1-tp,g)
                end
            end
        end
    end
end

function s.thfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end

-- (2) Opponent must discard a card after Special Summoning
function s.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(id)
end

function s.discardcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.discardop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
        local sg=g:Select(1-tp,1,1,nil)
        Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
    end
end

-- (3) Special Summon FIRE Warrior from GY if this card was equipped when sent to GY
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) 
        and c:IsReason(REASON_EFFECT+REASON_BATTLE) 
        and c:GetFlagEffect(id)>0
end

function s.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

-- Check if this card was equipped when sent to GY
function s.equipcheckcon(e)
    local c=e:GetHandler()
    if c:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_EQUIP) then
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE,0,1)
        return true
    end
    return false
end
