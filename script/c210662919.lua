-- Marionette Meow-skeeter
--Scripted by Konstak
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
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetLabel(1)
    e1:SetCondition(s.ccon)
    e1:SetValue(s.adval)
    c:RegisterEffect(e1)
    --Wave on Ignition
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1,id)
    e2:SetLabel(3)
    e2:SetCondition(s.ccon)
    e2:SetTarget(s.wavetg)
    e2:SetOperation(s.waveop)
    c:RegisterEffect(e2)
end
function s.filter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PSYCHIC)
end
function s.ccon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Atk lose
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-100
end
--Wave on Ignition Function
function s.wavetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.waveop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local d1=6
    while d1>3 do
        d1=Duel.TossDice(tp,1)
    end
    local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,d1)
    if tc then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end