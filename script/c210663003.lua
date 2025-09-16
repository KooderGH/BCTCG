--Type-URR Support
--Scripted by Konstak.
--Effects:
--2 "Mighty Katapult" (Fusion Monster)
--(1) Cannot be used as Fusion Material.
--(2) Must be Special Summoned only (from your Extra Deck) in Defense Position by sending 2 "Mighty Katapult" from your field to the GY. (You do not use "Polymerization")
--(3) Cannot be returned to hand.
--(4) When a card or effect is activated (Quick Effect): You can Tribute this card; negate the activation, and if you do, destroy it. During the End Phase, if this effect was activated this turn (and was not negated): Special Summon this card from your GY and gain 2 Warfare Counter.
--(5) You can tribute 1 Monster you control; Gain 1 Warfare counter.
--(6) If this card battles a Zombie type monster; Banish it at the start of the damage step.
--(7) If this card battles a Fairy type monster; negate the attack and negate its effects while this card is face-up on the field at the start of the damage step.
--(8) If this card battles a Machine type monster; Take control of it at the start of the damage step.
--(9) If this card is in your GY: You can pay half your LP; Special Summon this card from your GY
--(10) You can only control one "Type-URR Support".
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
    --Cannot be returned (3)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Negate (4)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.negcon)
    e3:SetCost(aux.StardustCost)
    e3:SetTarget(s.negtg)
    e3:SetOperation(s.negop)
    c:RegisterEffect(e3)
    --Revive (4)
    c:EnableCounterPermit(0x4001)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetTarget(s.sumtg)
    e4:SetOperation(s.sumop)
    c:RegisterEffect(e4)
    --Tribute other monster gain warfare counter
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_COUNTER)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(s.countcost)
    e5:SetOperation(s.countop)
    c:RegisterEffect(e5)
    --Can banish zombie monsters
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,3))
    e6:SetCategory(CATEGORY_REMOVE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_BATTLE_START)
    e6:SetTarget(s.bntg)
    e6:SetOperation(s.bnop)
    c:RegisterEffect(e6)
    --Can Negate fairy monsters
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,4))
    e7:SetCategory(CATEGORY_DISABLE)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_BATTLE_START)
    e7:SetTarget(s.negtg2)
    e7:SetOperation(s.negop2)
    c:RegisterEffect(e7)
    --Can Take control machine monsters
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,5))
    e8:SetCategory(CATEGORY_CONTROL)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_BATTLE_START)
    e8:SetTarget(s.tctg)
    e8:SetOperation(s.tcop)
    c:RegisterEffect(e8)
    --Special Summon from GY by paying half of your LP
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,6))
    e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_GRAVE)
    e9:SetCost(s.graverecoverycost)
    e9:SetTarget(s.graverecoverytg)
    e9:SetOperation(s.graverecoveryop)
    c:RegisterEffect(e9)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsType(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsFaceup() and c:IsCode(210660304) and c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
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
--Negate functions
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
--SS from 4th effect function
s.counter_list={0x4001}
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(id)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
        e:GetHandler():AddCounter(0x4001,2)
	end
end
--Counter function
function s.counterfilter(c)
	return c:IsMonster() and c:IsFaceup() and not c:IsCode(id)
end
function s.countcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.counterfilter,1,false,nil,c) end
	local g=Duel.SelectReleaseGroupCost(tp,s.counterfilter,1,1,false,nil,c)
	Duel.Release(g,REASON_COST)
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x4001,1)
	end
end
--Banish Zombies function
function s.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_ZOMBIE) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
    Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
    end
end
--negate Fairy function
function s.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_FAIRY) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() and bc:IsFaceup() and not bc:IsImmuneToEffect(e) then
        Duel.NegateAttack()
        c:SetCardTarget(bc)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetCondition(s.atkcon)
        bc:RegisterEffect(e1)
    end
end
function s.atkcon(e)
    return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
--Take control Machine function
function s.tctg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_MACHINE) and bc:IsControlerCanBeChanged() end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,bc,1,0,0)
end
function s.tcop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
        Duel.GetControl(bc,tp)
    end
end
--(10) GY to extra deck function
function s.graverecoverycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.graverecoverytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.graverecoveryop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	    Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
