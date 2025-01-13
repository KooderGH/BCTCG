--Miko Mitama
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
	-- Can Only control 1
	c:SetUniqueOnField(1,0,id)
    -- Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    -- To Defense Position
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetOperation(s.defop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    -- Cannot be targeted by card effects
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    -- Cannot be destroyed by card effects
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    -- Restrict activation of monster effects in hand or on the field
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetCode(EFFECT_CANNOT_ACTIVATE)
    e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.selfnegcon)
    e7:SetTargetRange(1,1)
    e7:SetValue(s.aclimit)
    c:RegisterEffect(e7)
    -- Banish when leaving the field
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e8:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e8)
	--Cannot be special summoned from the GY
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetCondition(s.splimcon)
	e9:SetValue(aux.FALSE)
	c:RegisterEffect(e9)
end
-- Special Summon condition
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
-- To Defense Position
function s.defop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
-- Restrict activation of monster effects in hand or field
function s.aclimit(e,re,tp)
    local rc=re:GetHandler()
    return (rc and (rc:IsLocation(LOCATION_HAND) or rc:IsLocation(LOCATION_MZONE))) and re:IsMonsterEffect()
end
-- Disable above effect if opponents control 5 or more monster
function s.selfnegcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)<5
end
--no sp GY
function s.splimcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
