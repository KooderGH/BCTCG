-- Owlbrow
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    aux.AddUnionProcedure(c,s.floatingfilter)
    --Atk up
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(200)
    e1:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e1)
    --Add Monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetTarget(s.addtg)
    e2:SetOperation(s.addop)
    c:RegisterEffect(e2)
end
--Union filter
function s.floatingfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
--Destroy and add function
function s.addfilter(c)
    return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end