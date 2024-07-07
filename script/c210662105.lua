-- Ecto Baa Baa
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Loses 200 ATK
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_EQUIP)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(-200)
	c:RegisterEffect(e0)
end