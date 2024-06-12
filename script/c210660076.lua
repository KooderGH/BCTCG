--Thundia
--Scripted By Gideon
-- (1) If your opponent controls more monsters then you while you control at least 1 LIGHT Spellcaster monster: You can Special Summon this card from your hand.
-- (2) When this card is Summoned; You can Tribute 1 monster you control except "Thundia"; Send 1 card your opponent controls to the GY. (Does not target)
-- (3) You can Target 1 DARK monster on the field; Banish it.
-- (4) When this card is Tributed; Add up to 3 LIGHT monsters from your GY to your hand except "Thundia", then raise their level by 2.
-- (5) You can only use each effect of "Thundia" once per turn and used only once while it is face-up on the field.
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
end