--Boulder Cat
--Scripted by Konstak.
--Effects:
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixRep(c,true,true,s.fil,2,2)
    Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
    --cannot be fusion material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --cannot be tributed
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UNRELEASABLE_SUM)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e3)
    --Cannot be returned to hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Cannot banish
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e5)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsFaceup() and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
end
function s.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function s.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end