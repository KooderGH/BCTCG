-- Metal One Horn
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --to defense
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.deftg)
    e1:SetOperation(s.defop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --Metal Mechanic
    local e4=Effect.CreateEffect(c)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(s.desatktg)
    c:RegisterEffect(e4)
    --self destroy
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_SELF_DESTROY)
    e5:SetCondition(s.sdcon)
    c:RegisterEffect(e5)
    --Add lv4 Monster
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetTarget(s.drtg)
    e6:SetOperation(s.drop)
    c:RegisterEffect(e6)
end
--to Defence
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAttackPos() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
--Metal Ability function
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsFaceup() end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetValue(-50)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
    c:RegisterEffect(e1)
    return true
end
function s.sdcon(e)
    local c=e:GetHandler()
    return c:GetDefense()<=0
end
--Destroy and add function
function s.drfilter(c)
    return c:IsLevel(5) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.drfilter,tp,LOCATION_DECK,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.drfilter,tp,LOCATION_DECK,0,2,2,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end