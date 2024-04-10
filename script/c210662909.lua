-- King Crab
--Scripted by ""
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetLabel(1)
    e1:SetCondition(s.crabcountcondition)
    e1:SetValue(s.adval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --Add Monster
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetLabel(2)
    e3:SetCondition(s.crabcountcondition)
    e3:SetTarget(s.addtg)
    e3:SetOperation(s.addop)
    c:RegisterEffect(e3)
    --Add Monster2
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetLabel(3)
    e4:SetCondition(s.crabcountcondition)
    e4:SetTarget(s.addtg2)
    e4:SetOperation(s.addop2)
    c:RegisterEffect(e4)
end
function s.crabfilter(c)
    return c:IsFaceup() and (c:IsCode(210662910) or c:IsCode(210662911) or c:IsCode(210662912) or c:IsCode(210662913) or c:IsCode(210662914) or c:IsCode(210662915) or c:IsCode(210662916) or c:IsCode(210662917) or c:IsCode(210662918))
end
function s.crabcountcondition(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.crabfilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Atk Def gain
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(s.crabfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*50
end
--Add function
function s.crabfilteradd(c)
    return (c:IsCode(210662910) or c:IsCode(210662911) or c:IsCode(210662912) or c:IsCode(210662913) or c:IsCode(210662914) or c:IsCode(210662915) or c:IsCode(210662916) or c:IsCode(210662917) or c:IsCode(210662918)) and c:IsAbleToHand()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.crabfilteradd,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.crabfilteradd,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--Add function2
function s.addtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.crabfilteradd,tp,0,LOCATION_DECK,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.addop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.crabfilteradd,tp,0,LOCATION_DECK,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end