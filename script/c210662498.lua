-- Owlbrow
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --No battle damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    c:RegisterEffect(e2)
	--cannot be attacked
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetCondition(s.cbdcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function s.owlbrowfilter(c)
	return not c:IsCode(id)
end
function s.cbdcon(e,c)
	if c==nil then end
    return Duel.IsExistingMatchingCard(s.owlbrowfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
