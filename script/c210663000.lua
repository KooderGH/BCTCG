--Type-80T support
--Scripted by Konstak. Summoning effect, Tribute effect and Cannot be destroyed/Targeted by effects by Gideon.
--Effects:
--2+ Earth Machine Monster(s) (Fusion Monster)
--(1) Cannot be used as Fusion Material.
--(2) Must first be Special Summoned (from your Extra Deck) by sending the above cards from either field to the GY. (You do not use "Polymerization") The original ATK and DEF of this card becomes 750 x the number of materials used for its Special Summon.
--(3) Cannot be Banished or Tributed.
--(4) Once per turn (Igntion): You can Special Summon 1 "Type 10 Token" (Cyverse/EARTH/Level 4/ATK 2000/DEF 2000)
--(5) While you control a Token, this card cannot be destroyed by battle and cannot be targeted by card effects.
--(6) You can Tribute 1 "Type 10 Token" monster's; Gain 1 Junk Counter.
--(7) Monsters you control gain 750 ATK for each Junk Counter on the field.
--(8) You can Tribute 2 "Type 10 Token" monster's; Decrease your opponent's LP by a quarter of their LP.
--(9) You can only control one "Type-80T support".
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x1d)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
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
    --Place one counter when tribute Type 10
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,2))
    e8:SetCategory(CATEGORY_COUNTER)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCost(s.addccost)
    e8:SetTarget(s.addct)
    e8:SetOperation(s.addc)
    c:RegisterEffect(e8)
    --Monsters player controls gain 750 ATK
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(LOCATION_MZONE,0)
    e9:SetValue(s.atkval)
    c:RegisterEffect(e9)
    --Decrease Opp LP by a quarter
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,1))
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCost(s.lpcost)
    e10:SetOperation(s.lpop)
    c:RegisterEffect(e10)
end
s.counter_list={0x1d}
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsRace(RACE_MACHINE,fc,sumtype,tp) and c:IsFaceup() and c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
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
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetValue(#g*750)
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
		Duel.SpecialSummonComplete()
	end
end
--addcounter
function s.indcon(e)
    return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function s.type10Filter(c)
    return c:IsCode(210668000)
end
  function s.addccost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.type10Filter,1,false,nil,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectReleaseGroupCost(tp,s.type10Filter,1,1,false,nil,nil)
    Duel.Release(sg,REASON_COST)
end
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1d)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x1d,1)
	end
end
--Counter
function s.atkval(e,c)
	return Duel.GetCounter(0,1,0,0x1d)*750
end
--decrease a quarter of your Opponent's LP function
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
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/1.25)
end
