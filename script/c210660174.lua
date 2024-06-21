--Mola King
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be destroyed by battle
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Cannot be destroyed by card effects
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --When Special Summoned
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(s.srtg)
    e3:SetOperation(s.srop)
    c:RegisterEffect(e3)
    --Gains 4000 ATK
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetLabel(3)
    e4:SetCondition(s.molacountcondition)
    e4:SetValue(4000)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e5)
end
--When SP add function
function s.dfilter(c)
    return c:IsAbleToHand() and c:IsCode(id)
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
    end
end
--Add 4000 ATK
function s.molafilter(c)
    return c:IsFaceup() and c:IsCode(id)
end
function s.molacountcondition(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.molafilter,tp,LOCATION_MZONE,0,nil)>=e:GetLabel()
end