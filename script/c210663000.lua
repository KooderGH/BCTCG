--Type-80T support
--Scripted by Konstak. Summoning effect, Tribute effect and Cannot be destroyed/Targeted by effects by Gideon.
--Effects:
--2+ Machine Monster(s) (Fusion Monster)
--(1) Cannot be used as Fusion Material.
--(2) Must first be Special Summoned (from your Extra Deck) by sending the above cards from either field to the GY. The original ATK and DEF of this card becomes 800 x the number of materials used for its Special Summon.
--(3) Cannot be Banished or Tributed.
--(4) Once per turn (Igntion): You can Special Summon 1 "Type 10 Token" (Cyverse/EARTH/Level 4/ATK 2000/DEF 2000). These's token's cannot attack.
--(5) While you control a Token, this card cannot be destroyed by battle and cannot be targeted by card effects.
--(6) You can Tribute 2 "Type 10 Token" monster's; Halve your opponent's LP.
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,s.fil,2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
    --cannot be fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --Cannot be Tributed
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
	--Cannot banish
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e4)
	--Special summon 1 token to your field
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	--Cannot be destroyed
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetCondition(s.indcon)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    c:RegisterEffect(e7)
	--Halve opponent's LP
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,1))
	e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
	e8:SetCost(s.lpcost)
	e8:SetOperation(s.lpop)
	c:RegisterEffect(e8)
end
--Special Summon Functions
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
--Special Summon Token Function
s.listed_names={210668000}
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,210668000,0,TYPES_TOKEN,2000,2000,4,RACE_MACHINE,ATTRIBUTE_EARTH) then
		local token1=Duel.CreateToken(tp,210668000)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        token1:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
--Cannot be destroyed/Targeted by effects condition
function s.indcon(e)
    return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
--Halve Opponent's LP function
function s.tokenFilter(c)
    return c:IsCode(210668000)
end
  function s.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.tokenFilter,2,false,nil,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectReleaseGroupCost(tp,s.tokenFilter,2,2,false,nil,nil)
    Duel.Release(sg,REASON_COST)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end
