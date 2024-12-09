--Izanagi
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	c:EnableCounterPermit(0x4006)
	-- SP Summon by banishing Level 12 or higher monster or Link-3 or higher monster from GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
    e2:SetCondition(s.spcon)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
	--unaffected by other card effect
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(s.efilter)
    c:RegisterEffect(e3)
	--Cannot be targeted by card effects
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	--Change battle damage
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e5:SetRange(LOCATION_MZONE) 
    e5:SetValue(aux.ChangeBattleDamage(1,100))
    c:RegisterEffect(e5)
	--Attack per card in either GY
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(s.atkval)
    c:RegisterEffect(e6)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DAMAGE)
	e7:SetCondition(s.ctcon)
	e7:SetOperation(s.ctop)
	c:RegisterEffect(e7)
	--win
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetOperation(s.winop)
	c:RegisterEffect(e8)
end
s.counter_place_list={0x4006}
-- Special Summon
function s.spfilter(c,tp)
    return (c:IsLevelAbove(12) or (c:IsType(TYPE_LINK) and c:GetLink()>=3)) 
        and c:IsAbleToRemoveAsCost() and not c:IsCode(id)
end
function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local code=c:GetCode()
    -- Exclude the card itself that is attempting to be Special Summoned
    return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),code)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local code=c:GetCode()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    -- Select a Level 12 or higher monster from the Graveyard, including this card copies but not the one activating the effect (prevent derp moment)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),code)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
-- Unafected other effect Filter
function s.efilter(e,te)
    return te:GetHandler()~=e:GetHandler()
end
-- Update Attack
function s.atkval(e,c)
    local gy_count = Duel.GetFieldGroupCount(c:GetControler(), LOCATION_GRAVE, 0) + 
                     Duel.GetFieldGroupCount(c:GetControler(), 0, LOCATION_GRAVE)
    return gy_count * 100
end
-- Counter
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x4006,1)
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x4006)==3 then
		Duel.Win(tp,WIN_REASON_VENNOMINAGA)
	end
end
