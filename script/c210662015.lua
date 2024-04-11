-- Squire Rel
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    aux.AddUnionProcedure(c,s.monsterfilter)
end
--Union filter
function s.monsterfilter(c)
    return c:IsFaceup()
end