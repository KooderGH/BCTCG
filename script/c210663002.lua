--Type-K41 Defence
--Scripted by Konstak.
--Effects:
--2 "Mighty Aethur Ltd." (Fusion Monster)
--(1) Cannot be used as Fusion Material.
--(2) Must be Special Summoned only (from your Extra Deck) in Defense Position by sending 2 "Mighty Aethur Ltd." from your field to the GY. (You do not use "Polymerization") This Card Summon cannot be negated.
--(3) Cannot be returned to hand or Tributed.
--(4) This card's Position cannot be changed.
--(5) Once per turn (Igntion): You can Special Summon up to 2 "Piledriver K41 Token" (Machine/DARK/Level 2/ATK 1000/DEF 1500).
--(6) Once per turn; You can Tribute 1 "Piledriver K41 Token" monster; You can choose 1 unused Main Monster Zone or Spell & Trap Zone; it cannot be used while this monster is face-up on the field.
--(7) You can only activate two of the following effects of "Type-K41 Defence" once per turn (Ignition):
--* You can Tribute 2 "Piledriver K41 Token" monster; Special Summon 1 "Driller K41 Token" (Machine/DARK/Level 2/ATK 1500/DEF 2000). These token's can attack your opponent directly.
--* You can Tribute 1 "Driller K41 Token" monster; Special Summon 1 "Thermae K41 Token" (Machine/DARK/Level 2/ATK 2000/DEF 2500). These token's can attack your opponents monsters once each.
--* You can Tribute 1 "Driller K41 Token" monster; Gain 1 Warfare Counter.
--* You can Tribute 1 "Thermae K41 Token" monster; Gain 2 Warfare Counter.
--(8) Monsters you control gain 1000 DEF for each Warfare Counter on the field.
--(9) While you control a "Type-K41 Defence" Token, this card cannot be targeted for attacks and cannot be targeted by card effects.
--(10) You can only control one "Type-K41 Defence".
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
    --Special summon 1 token to your field
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,0))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetTarget(s.sptg)
    e7:SetOperation(s.spop)
    c:RegisterEffect(e7)
    --Make Zone unusable after tributing piledriver
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,1))
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)
    e8:SetCost(s.zcost)
    e8:SetTarget(s.ztg)
    e8:SetOperation(s.zop)
    c:RegisterEffect(e8)
    --Special summon 1 token to your field
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,2))
    e9:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(2,{id,1},EFFECT_COUNT_CODE_OATH)
    e9:SetCost(s.zcost)
    e9:SetTarget(s.sptg2)
    e9:SetOperation(s.spop2)
    c:RegisterEffect(e9)
    --Special summon 1 token to your field
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,3))
    e10:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCountLimit(2,{id,1},EFFECT_COUNT_CODE_OATH)
    e10:SetCost(s.zcost2)
    e10:SetTarget(s.sptg3)
    e10:SetOperation(s.spop3)
    c:RegisterEffect(e10)
    --Place one counter when tribute Driller
    c:EnableCounterPermit(0x4001)
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(id,4))
    e11:SetCategory(CATEGORY_COUNTER)
    e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCountLimit(2,{id,1},EFFECT_COUNT_CODE_OATH)
    e11:SetCost(s.zcost2)
    e11:SetTarget(s.addct)
    e11:SetOperation(s.addc)
    c:RegisterEffect(e11)
    --Place two counters when tribute Thermae
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id,5))
    e12:SetCategory(CATEGORY_COUNTER)
    e12:SetType(EFFECT_TYPE_IGNITION)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCountLimit(2,{id,1},EFFECT_COUNT_CODE_OATH)
    e12:SetCost(s.zcost3)
    e12:SetTarget(s.addct2)
    e12:SetOperation(s.addc2)
    c:RegisterEffect(e12)
    --Monsters player controls gain 1000 DEF
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_UPDATE_DEFENSE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_MZONE,0)
    e13:SetValue(s.defval)
    c:RegisterEffect(e13)
    --Cannot be destroyed
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_SINGLE)
    e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e14:SetRange(LOCATION_MZONE)
    e14:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e14:SetCondition(s.indcon)
    e14:SetValue(1)
    c:RegisterEffect(e14)
    local e15=e14:Clone()
    e15:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    c:RegisterEffect(e15)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsType(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsFaceup() and c:IsCode(210660594) and c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
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
--Special Summon Piledriver Function
s.listed_names={210668001}
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,210668001,0,TYPES_TOKEN,1000,1500,2,RACE_MACHINE,ATTRIBUTE_DARK) then
		local token1=Duel.CreateToken(tp,210668001)
        local token2=Duel.CreateToken(tp,210668001)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
--Remove Zone Function
function s.tokenFilter(c)
    return c:IsFaceup() and c:IsCode(210668001)
end
  function s.zcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.tokenFilter,1,false,nil,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectReleaseGroupCost(tp,s.tokenFilter,1,1,false,nil,nil)
    Duel.Release(sg,REASON_COST)
end
function s.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0)
	Duel.Hint(HINT_ZONE,tp,dis)
	Duel.SetTargetParam(dis)
end
function s.zop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	--Disable the chosen zone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(function(e) return e:GetLabel() end)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	e1:SetLabel(Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))
	c:RegisterEffect(e1)
end
--Special Summon Driller Function
s.listed_names={210668002}
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tokenFilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,210668002,0,TYPES_TOKEN,1500,2000,2,RACE_MACHINE,ATTRIBUTE_DARK) then
        local token1=Duel.CreateToken(tp,210668002)
        Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
        --direct attack
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        token1:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
	end
end
--Special Summon thermae Function
s.listed_names={210668003}
function s.drillerFilter(c)
    return c:IsCode(210668002)
end
  function s.zcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.drillerFilter,1,false,nil,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectReleaseGroupCost(tp,s.drillerFilter,1,1,false,nil,nil)
    Duel.Release(sg,REASON_COST)
end
function s.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.drillerFilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,210668003,0,TYPES_TOKEN,2000,2500,2,RACE_MACHINE,ATTRIBUTE_DARK) then
        local token1=Duel.CreateToken(tp,210668003)
        Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
        --direct attack
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetValue(1)
        token1:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
	end
end
--Driller Guard Counter 
s.counter_list={0x4001}
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x4001)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x4001,1)
	end
end
--Thermae Guard Counter
function s.thermaeFilter(c)
    return c:IsFaceup() and c:IsCode(210668003)
end
  function s.zcost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.thermaeFilter,1,false,nil,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectReleaseGroupCost(tp,s.thermaeFilter,1,1,false,nil,nil)
    Duel.Release(sg,REASON_COST)
end
function s.addct2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x4001)
end
function s.addc2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x4001,2)
	end
end
--Counter
function s.defval(e,c)
    return Duel.GetCounter(0,1,1,0x4001)*1000
end
--Cannot be Attacked/Targeted by effects condition
function s.TokenFilter(c)
    return c:IsFaceup() and c:IsCode(210668001) or c:IsCode(210668002) or c:IsCode(210668003)
end
function s.indcon(e)
    return Duel.IsExistingMatchingCard(s.TokenFilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end