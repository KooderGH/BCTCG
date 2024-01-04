--Type-80T Support
--Scripted by Gideon and Kon. Summon fusion by Gideon
-- 2+ Machine Monster(s) (Fusion Monster)
-- (1) Cannot be used as Fusion Material.
-- (2) Must first be Special Summoned (from your Extra Deck) by sending the above cards from either field to the GY. The original ATK and DEF of this card becomes 800 x the number of materials used for its Special Summon.
-- (3) Cannot be Banished or Tributed.
-- (4) Once per turn (Igntion): You can Special Summon 1 "Type 10 Token" (Cyverse/EARTH/Level 4/ATK 2000/DEF 2000). These's token's cannot attack.
-- (5) While you control a Token, this card cannot be destroyed by battle and cannot be targeted by card effects.
-- (6) You can Tribute 2 "Type 10 Token" monster's; Halve your opponent's LP.
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,s.fil,2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
end
function s.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function s.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetValue(#g*800)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end