--Metal Cat
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
    --cannot be fusion material (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Summon cannot be negated (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsType(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsFaceup() and c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
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