--Akira
--Scripted by Gideon. Help from Naim.
--Effect
-- Does piercing damage.
-- Gains 700 atk during your turn only.
-- When this card Destroy's a Monster by Battle; You can Special Summon one DARK monster from your hand.
-- Cannot be returned to hand or tributed while on the field.
local s,id=GetID()
function s.initial_effect(c)
	--pierce
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e1)
	--Raise ATK during turn only
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
	--e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    --e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.atkcon)
    e2:SetValue(700)
    c:RegisterEffect(e2)
	--Destroy Monster SS Dark
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(s.target)
	e3:SetOperation(s.soperation)
	c:RegisterEffect(e3)
	--Cannot be Tributed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--Cannot be returned to hand
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
end

--e2
function s.atkcon(e)
    return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
--e3
function s.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_DARK)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.soperation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
