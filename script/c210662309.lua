-- Coffin Zoge
local s,id=GetID()
function s.initial_effect(c)
    --Revive
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCost(s.sumcost)
    e1:SetCondition(s.sumcon)
    e1:SetTarget(s.sumtg)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)
    --Opponent No Battle Damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Avoid Battle damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Damage Control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetOperation(s.dcop)
    c:RegisterEffect(e4)
end
function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,250) end
    Duel.PayLPCost(tp,250)
end
function s.sumcon(e,tp,c)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	end
end
--Damage Control effect
function s.dcop(e,tp,eg,ep,ev,re,r,rp)
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end