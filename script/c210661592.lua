--Neko Rin
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon this card
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    --Warrior player controls gain 200 DEF
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
    e2:SetValue(s.adval)
    c:RegisterEffect(e2)
    --Cannot Target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(function(e,c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) end)
    c:RegisterEffect(e3)
end
--Special summon function
function s.specialfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--Def update function
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsRace,RACE_WARRIOR),c:GetControler(),LOCATION_MZONE,0,nil)*200
end