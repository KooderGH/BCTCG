-- Sa-Bat
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
	aux.AddUnionProcedure(c,s.floatingfilter)
end
--Union filter
function s.crabfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end