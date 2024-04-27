--Neo Saw Cat
--Scripted By Konstak
--Effect:
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,s.machinefilter,2,2,s.lcheck)
end
--lcheck
function s.machinefilter(c,scard,sumtype,tp)
    return c:IsRace(RACE_MACHINE,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_EARTH,scard,sumtype,tp) and not c:IsType(TYPE_TOKEN)
end
function s.lcheck(g,lc,sumtype,tp)
    return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end