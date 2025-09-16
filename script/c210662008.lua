-- Sir Seal
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Damage LP
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,3))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1)
    e1:SetOperation(s.lpop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --Attack Up Ability
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetCondition(s.con)
    e4:SetTarget(s.tg)
    e4:SetValue(250)
    c:RegisterEffect(e4)
    --Damage LP
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCountLimit(1)
    e5:SetOperation(s.lpop)
    c:RegisterEffect(e5)
end
--Damage LP Function
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.Damage(1-tp,250,REASON_EFFECT)
    end
end
--Attack Up function
function s.con(e)
	return e:GetHandler():IsAttackPos()
end
function s.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_PYRO)
end