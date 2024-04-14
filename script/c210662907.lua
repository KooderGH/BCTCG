-- Dictactor Wizadron
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --No Normal Summon
    c:EnableUnsummonable()
    --special summon tribute
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Add Monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.addtg)
    e2:SetOperation(s.addop)
    c:RegisterEffect(e2)
    --Long Distance Ability
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetCondition(s.ldcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function s.dictactorwizadronfilter(c)
    return c:IsFaceup() and c:IsCode(210662906)
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.dictactorwizadronfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.dictactorwizadronfilter,1,1,false,true,true,c,nil,nil,false,nil,nil)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
    return true
    end
    return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Release(g,REASON_COST)
    g:DeleteGroup()
end
--Add function
function s.addfilter(c)
    return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--Long Distance Function
function s.ldfilter(c)
    return not c:IsCode(id)
end
function s.ldcon(e,c)
    if c==nil then end
    return Duel.IsExistingMatchingCard(s.ldfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end