--Type-K41 Defence
--Scripted by Konstak.
--Effects:
--2 "Mighty Katapult" (Fusion Monster)
--(1) Cannot be used as Fusion Material.
--(2) Must be Special Summoned only (from your Extra Deck) in Defense Position by sending 2 "Mighty Katapult" from your field to the GY. This Card Summon cannot be negated.
--(3) Cannot be returned to hand or Tributed.
--(4) This card's Position cannot be changed.
--(5) Once per turn (Igntion): You can Special Summon 2 "Piledriver K41 Token" (Machine/DARK/Level 2/ATK 1000/DEF 2000).
--(6) Once per turn; You can Tribute 1 "Piledriver K41 Token" monster; You can choose 1 unused Main Monster Zone or Spell & Trap Zone; it cannot be used while this monster is face-up on the field.
--(7) You can only activate one of the following effects of "Type-K41 Defence" once per turn (Ignition):
--* You can Tribute 1 "Piledriver K41 Token" monster; Special Summon 1 "Driller K41 Token" (Machine/DARK/Level 2/ATK 1500/DEF 1500). These token's can attack your opponent directly.
--* You can Tribute 1 "Driller K41 Token" monster; Special Summon 1 "Thermae K41 Token" (Machine/DARK/Level 2/ATK 2500/DEF 3000). These token's can attack your opponents monsters once each.
--(8) While you control a Token, this card cannot be targeted for attacks and cannot be targeted by card effects.

local s,id=GetID()
function s.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    --Fusion.AddProcMix(c,true,true,210660463)
    Fusion.AddProcMixRep(c,true,true,s.fil,1,4)
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
    --Cannot be Tributed (3)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_UNRELEASABLE_SUM)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e4)
    --Cannot be returned to hand (3)
    local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_TO_HAND)
    c:RegisterEffect(e5)
    --This card's Position cannot be changed. (4)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_SET_POSITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(POS_FACEUP_DEFENSE)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e6)
	--Special summon 1 token to your field (5)
	--local e7=Effect.CreateEffect(c)
	--e7:SetDescription(aux.Stringid(id,0))
	--e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	--e7:SetType(EFFECT_TYPE_IGNITION)
	--e7:SetRange(LOCATION_MZONE)
	--e7:SetCountLimit(1)
	--e7:SetTarget(s.sptg)
	--e7:SetOperation(s.spop)
	--c:RegisterEffect(e7)
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