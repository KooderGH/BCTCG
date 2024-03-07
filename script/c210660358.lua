--Graveflower Verbena
--Scripted by Konstak
--Effect
-- (1) When you take battle damage: You can Special Summon this card from your hand or GY.
-- (2) Cannot be returned.
-- (3) Gains 100 ATK/DEF for each card in your GY.
-- (4) This card an attack all monsters your opponent controls once each.
-- (5) When this card is Banished; draw 1 card.
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon itself from the hand (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCondition(function(_,tp,_,ep) return ep==tp end)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Cannot be returned (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --ATK based on Wind machines on your GY (3)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(s.atkval)
    c:RegisterEffect(e3)
    --This card can attack your opponents monsters once each. (4)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_ATTACK_ALL)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Draw 1 card (5)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_REMOVE)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_REMOVED)
    e5:SetOperation(s.bnop)
    c:RegisterEffect(e5)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--ATK gain (3)
function s.filter(c,e)
    return c:IsFaceup()
end
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
--Draw 1 card (5)
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end