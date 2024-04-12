--Vars
--Scripted by Senor Pizza. Help by Konstak
--Effect
--(1) You can Normal Summon this card without tribute if you control no monsters OR only control Dragon type monsters.
--(2) When this card is Special Summoned: You can target one monster your opponent controls, return it.
--(3) Neither player can Special Summon monsters while this card is face-up on the field.
--(4) If you control a non-dragon monster on the field: Banish this card. (Mandatory)
--(5) If this face-up card on the field is destroyed by a card effect; Destroy all Normal Summoned monster's on the field.
--(6) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --You can Normal Summon this card without tribute if you control no monsters OR only control Dragon type monsters.(1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(s.nscon)
    c:RegisterEffect(e1)
    --Once SS: return 1 card (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.retg)
    e2:SetOperation(s.reop)
    c:RegisterEffect(e2)
    --disable spsummon (3)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,1)
    c:RegisterEffect(e3)
    --self banish (4)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_ADJUST)
    e4:SetCondition(s.sbcon)
    e4:SetOperation(s.sbop)
    c:RegisterEffect(e4)
    --When destroyed by card effect (5)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(s.descon)
    e5:SetTarget(s.destg)
    e5:SetOperation(s.desop)
    c:RegisterEffect(e5)
    --Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.(6)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e6:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e6)
end
function s.nscon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_DRAGON),c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--e2
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
--e4
function s.sdfilter(c)
    return c:IsFaceup() and not c:IsRace(RACE_DRAGON)
end
function s.sbcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.sbop(e)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--e5
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.desfilter(c)
    return c:IsFaceup() and (c:GetSummonType()&SUMMON_TYPE_NORMAL)~=0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end