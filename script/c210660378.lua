--Dark Mitama
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
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
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
    -- Restrict activation of monster effects in Grave or in banish zone
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
	--Necrovalley Monster Version
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetCode(EFFECT_NECRO_VALLEY)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(LOCATION_GRAVE,0)
    e9:SetCondition(s.contp)
    c:RegisterEffect(e9)
    local e10=e9:Clone()
    e10:SetTargetRange(0,LOCATION_GRAVE)
    e10:SetCondition(s.conntp)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_NECRO_VALLEY)
    e11:SetRange(LOCATION_MZONE)
    e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e11:SetTargetRange(1,0)
    e11:SetCondition(s.contp)
    c:RegisterEffect(e11)
    local e12=e11:Clone()
    e12:SetTargetRange(0,1)
    e12:SetCondition(s.conntp)
    c:RegisterEffect(e12)
    -- Negate an effect when it resolves if it would move a card in the GY
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
	e13:SetCondition(s.selfnegcon)
    e13:SetOperation(s.disop)
    c:RegisterEffect(e13)
    -- Prevent non-activated effects from Special Summoning from the GY (e.g., unclassified summoning effects or delayed effects)
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(1,1)
	e14:SetCondition(s.selfnegcon)
    e14:SetTarget(s.cannotsptg)
    c:RegisterEffect(e14)
	--Cannot be special summoned from the GY
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e15:SetCode(EFFECT_SPSUMMON_CONDITION)
	e15:SetCondition(s.splimcon)
	e15:SetValue(aux.FALSE)
	c:RegisterEffect(e15)
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
    return (rc and (rc:IsLocation(LOCATION_REMOVED) or rc:IsLocation(LOCATION_GRAVE))) and re:IsMonsterEffect()
end
-- Disable above effect if opponents control 5 or more monster
function s.selfnegcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)<5
end
-- Necrovalley
function s.contp(e)
    local tp=e:GetHandlerPlayer()
    return not Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)
	and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)<5
end
function s.conntp(e)
    local tp=e:GetHandlerPlayer()
    return not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)
	and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)<5
end
function s.disfilter(c,not_im0,not_im1,re)
    if c:IsControler(0) then return not_im0 and c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsRelateToEffect(re)
    else return not_im1 and c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsRelateToEffect(re) end
end
function s.discheck(ev,category,re,not_im0,not_im1)
    local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,category)
    if not ex then return false end
    if (category==CATEGORY_LEAVE_GRAVE or v==LOCATION_GRAVE) and ct>0 and not tg then
        if p==0 then return not_im0
        elseif p==1 then return not_im1
        elseif p==PLAYER_ALL then return not_im0 or not_im1
        elseif p==PLAYER_EITHER then return not_im0 and not_im1
        end
    end
    if tg and #tg>0 then
        return tg:IsExists(s.disfilter,1,nil,not_im0,not_im1,re)
    end
    return false
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local tc=re:GetHandler()
    if not Duel.IsChainDisablable(ev) or tc:IsHasEffect(EFFECT_NECRO_VALLEY_IM) then return end
    local res=false
    local not_im0=not Duel.IsPlayerAffectedByEffect(0,EFFECT_NECRO_VALLEY_IM)
    local not_im1=not Duel.IsPlayerAffectedByEffect(1,EFFECT_NECRO_VALLEY_IM)
    if not res and s.discheck(ev,CATEGORY_SPECIAL_SUMMON,re,not_im0,not_im1) then res=true end
    if not res and s.discheck(ev,CATEGORY_REMOVE,re,not_im0,not_im1) then res=true end
    if not res and s.discheck(ev,CATEGORY_TOHAND,re,not_im0,not_im1) then res=true end
    if not res and s.discheck(ev,CATEGORY_TODECK,re,not_im0,not_im1) then res=true end
    if not res and s.discheck(ev,CATEGORY_TOEXTRA,re,not_im0,not_im1) then res=true end
    if not res and s.discheck(ev,CATEGORY_EQUIP,re,not_im0,not_im1) then res=true end
    if not res and s.discheck(ev,CATEGORY_LEAVE_GRAVE,re,not_im0,not_im1) then res=true end
    if res then Duel.NegateEffect(ev) end
end

function s.cannotsptg(e,c,sp,sumtype,sumpos,target_p,sumeff)
    return c:IsLocation(LOCATION_GRAVE) and sumeff and not sumeff:IsActivated() and not sumeff:IsHasProperty(EFFECT_FLAG_CANNOT_DISABLE)
        and not Duel.IsPlayerAffectedByEffect(c:GetControler(),EFFECT_NECRO_VALLEY_IM) and not c:IsHasEffect(EFFECT_NECRO_VALLEY_IM)
        and not sumeff:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY_IM)
end
--no sp GY
function s.splimcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end