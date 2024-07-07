-- Owlbrow
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetCategory(CATEGORY_DRAW)	
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetOperation(s.drop)
    c:RegisterEffect(e1)
    --No battle damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
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
    --Avoid Battle damage
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_DARK),c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--Draw Function
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsPlayerCanDraw(1-tp,1) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetCode(EVENT_PHASE+PHASE_DRAW)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        e1:SetCountLimit(1)
        e1:SetOperation(s.drawop)
        c:RegisterEffect(e1)
    end
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end
--Long Distance Function
function s.ldfilter(c)
    return not c:IsCode(id)
end
function s.ldcon(e,c)
    if c==nil then end
    return Duel.IsExistingMatchingCard(s.ldfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end