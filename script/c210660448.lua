--Musashi Miyamoto
--Scripted by Gideon
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card's Summon cannot be negated. You can Special Summon this card from your hand by sending 3 Face-up Equip Spell Card(s) from either side of the field while controlling at least 1 FIRE Warrior monster, then move this card to your Extra Monster Zone.
-- (2) Cannot be returned to hand, tributed, or banished.
-- (3) Each player can only control 1 Attribute of monster. Send all other face-up monsters they control to the GY.
-- (4) Neither player can attack directly.
-- (5) Once per turn (Ignition): You can target 1 Equip spell card in your GY; Add that card to your hand but for the rest of this turn, you cannot activate cards with the same name.
-- (6) If this card is in your GY: You can banish 2 equip cards from your GY; Add this card to your hand. You can only activate this effect of "Musashi Miyamoto" Twice per duel.
-- (7) This card gains the following effect(s), based on the number of Equip Cards equipped to it.
-- * 1+: Your opponent cannot effects during the battle phase.
-- * 2+: Once per turn (Ignition): You can target 1 monster in your opponent's GY; Special Summon it in ATK position.
-- * 3+: At the end of the damage step: If a FIRE Warrior Monster you control battles an opponent's monster, but the opponent's monster was not destroyed by the battle; banish that opponent's monster.
-- * 4+: Monster's you control cannot be targeted by card effects, except during your Main Phase 2.
-- * 5+: You can tribute 1 monster you control and send 2 face-up equip spells to activate this effect; Shuffle your banish and GY zones to your deck, then, draw 5 cards.
local s,id=GetID()
function s.initial_effect(c)
    --(1)Start
    --Makes it unsummonable via normal
    c:EnableUnsummonable()
    --Cannot be SS by other ways other then it's own effect via above and this function
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.FALSE)
    c:RegisterEffect(e0)
    --SS from Hand / GY
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e1:SetCondition(s.ssummoncon)
    c:RegisterEffect(e1)
    --Move to EMZ
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(s.mvop)
    c:RegisterEffect(e2)
    --Summon cannot be disabled (Hopefully)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)
    --(1)Finish
    --(2)Start
    --Cannot be Tributed
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUM)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e5)
    --Cannot be returned to hand
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_TO_HAND)
    c:RegisterEffect(e6)
    --Cannot banish
    local e7=e4:Clone()
    e7:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e7)
    --(2)Finish
	--(3)Start
	--Gozen Match
	--adjust
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetCode(EVENT_ADJUST)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(s.adjustop)
	c:RegisterEffect(e8)
	--cannot summon,spsummon,flipsummon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_FORCE_SPSUMMON_POSITION)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,1)
	e9:SetTarget(s.sumlimit)
	e9:SetValue(POS_FACEDOWN)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e11)
	--(3)end
	--(4)Start
	--Cannot attack directly
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e12)
	--(4)end
	--(5)Start
	--You can target 1 Equip spell card in your GY
	local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(id,0))
    e13:SetCategory(CATEGORY_TOHAND)
    e13:SetType(EFFECT_TYPE_IGNITION)
    e13:SetCode(EVENT_FREE_CHAIN)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCountLimit(1)
    e13:SetTarget(s.recequiptarget)
    e13:SetOperation(s.recequipop)
    c:RegisterEffect(e13)
	--(5)end
	--(6)Start
	--If this card is in your GY: You can banish 2 equip cards from your GY;
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(id,1))
	e14:SetCategory(CATEGORY_TOHAND)
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetRange(LOCATION_GRAVE)
	e14:SetCountLimit(2,EFFECT_COUNT_CODE_DUEL)
	e14:SetCost(s.recovercost)
	e14:SetTarget(s.recoverselftarget)
	e14:SetOperation(s.recoverselfop)
	c:RegisterEffect(e14)
	--(6)end
	--(7)Start
	--Your opponent cannot effects during the battle phase. (1+)
	local e2=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetCode(EFFECT_CANNOT_ACTIVATE)
	e15:SetRange(LOCATION_ONFIELD)
	e15:SetTargetRange(0,1)
	e15:SetCondition(s.effectactcond)
	e15:SetValue(s.effectactlimit)
	c15:RegisterEffect(e15)
	--2+: Once per turn (Ignition): You can target 1 monster in your opponent's GY; Special Summon it in ATK position.
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(id,2))
	e16:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e16:SetType(EFFECT_TYPE_IGNITION)
	e16:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e16:SetCode(EVENT_FREE_CHAIN)
	e16:SetCondition(s.sseactcond)
	e16:SetTarget(s.sptg)
	e16:SetOperation(s.spop)
	c:RegisterEffect(e16)
	--3+: At the end of the damage step: If a Monster you control battles an opponent's monster, but the opponent's monster was not destroyed by the battle; banish that opponent's monster.
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EVENT_DAMAGE_STEP_END)
	e17:SetCondition(s.battlecondition)
	e17:SetTarget(s.battletarget)
	e17:SetOperation(s.battleop)
	c:RegisterEffect(e17)
	--4+: Monster's you control cannot be targeted by card effects, except during your Main Phase 2.
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTargetRange(LOCATION_MZONE,0)
	e18:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e18:SetCondition(s.tgcon)
	e18:SetValue(aux.tgoval)
	c:RegisterEffect(e18)
	--5+: You can tribute 1 monster you control and send 2 face-up equip spells to activate this effect; Shuffle your banish and GY zones to your deck, then, draw 5 cards.
	local e19=Effect.CreateEffect(c)
	e19:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e19:SetType(EFFECT_TYPE_QUICK_O)
	e19:SetCode(EVENT_FREE_CHAIN)
	e19:SetCondition(s.tributerecoverycondition)
	e19:SetCost(s.tributerecoverycost)
	e19:SetTarget(s.tributerecoverytarget)
	e19:SetOperation(s.tributerecoveryoperation)
	c:RegisterEffect(e19)
end
--e1 (1)
function s.FIREfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)
end
function s.EQUIPfilter(c)
	return c:IsFaceup() and c:IsEquipSpell() and c:IsAbleToGraveAsCost()
end
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1))
        and Duel.IsExistingMatchingCard(s.FIREfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.EQUIPfilter,tp,LOCATION_SZONE,0,3,nil)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.EQUIPFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1)) then
		local sg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_TOGRAVE,nil,nil,true)
		Duel.SendtoGrave(sg,REASON_COST)
        local lftezm=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,5) and 0x20 or 0
        local rgtemz=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,6) and 0x40 or 0
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~ZONES_EMZ|(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--e8 (3)
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	s[0]=0
	s[1]=0
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	local at=s.getattribute(Duel.GetMatchingGroup(Card.IsFaceup,targetp or sump,LOCATION_MZONE,0,nil))
	if at==0 then return false end
	return c:GetAttribute()~=at
end
function s.getattribute(g)
	local aat=0
	for tc in g:Iter() do
		aat=(aat|tc:GetAttribute())
	end
	return aat
end
function s.rmfilter(c,at)
	return c:GetAttribute()==at
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	if #g1==0 then s[tp]=0
	else
		local att=s.getattribute(g1)
		if (att&att-1)~=0 then
			if s[tp]==0 or (s[tp]&att)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
				att=Duel.AnnounceAttribute(tp,1,att)
			else att=s[tp] end
		end
		g1:Remove(s.rmfilter,nil,att)
		s[tp]=att
	end
	if #g2==0 then s[1-tp]=0
	else
		local att=s.getattribute(g2)
		if (att&att-1)~=0 then
			if s[1-tp]==0 or (s[1-tp]&att)==0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,0))
				att=Duel.AnnounceAttribute(1-tp,1,att)
			else att=s[1-tp] end
		end
		g2:Remove(s.rmfilter,nil,att)
		s[1-tp]=att
	end
	local readjust=false
	if #g1>0 then
		Duel.SendtoGrave(g1,REASON_RULE,PLAYER_NONE,tp)
		readjust=true
	end
	if #g2>0 then
		Duel.SendtoGrave(g2,REASON_RULE,PLAYER_NONE,1-tp)
		readjust=true
	end
	if readjust then Duel.Readjust() end
end
--e13 (5)
function s.thfilter(c)
	return c:IsSpell() and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.recequiptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.recequipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.aclimt)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
--e14(6)
function s.rcfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.recoverycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rcfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rcfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.graverecoverytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.graverecoveryop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
--(7) Start
--(+1) Effect 
function s.effectactcond(e)
	local c=e:GetHandler()
	return Duel.IsBattlePhase() and c:GetEquipCount()>=1
end
function s.effectactlimit(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
--(+2) Effect 
function s.sseactcond(e)
	local c=e:GetHandler()
	return c:GetEquipCount()>=2
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
end
--(+3) effect
function s.battlecondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
	if not at then return false end
	if at:IsControler(tp) then at=Duel.GetAttacker() end
	return at and at:IsRelateToBattle() and not at:IsStatus(STATUS_BATTLE_DESTROYED) and c:GetEquipCount()>=3
end
function s.battletarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if at:IsControler(tp) then at=Duel.GetAttacker() end
	if chk==0 then return at:IsAbleToRemove() end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,at,1,0,0)
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.Remove(tc,REASON_EFFECT)
	end
end
--(+4) Effect
function s.tgcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() or Duel.GetCurrentPhase()~=PHASE_MAIN2 and and c:GetEquipCount()>=4
end
--(+5) Effect
function s.tributerecoverycondition(e)
	local c=e:GetHandler()
	return c:GetEquipCount()>=5
end
function s.tricfilter(c,tp)
    return Duel.IsExistingMatchingCard(s.tributespellfilter,tp,LOCATION_SZONE,0,2,c:GetEquipGroup())
end
function s.tributespellfilter(c)
    return c:IsFaceup() and c:IsEquipSpell() and c:IsAbleToGraveAsCost()
end
function s.tributerecoverycost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.tricfilter,1,false,nil,nil,tp) end
    local g=Duel.SelectReleaseGroupCost(tp,s.tricfilter,1,1,false,nil,nil,tp)
    Duel.Release(g,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=Duel.SelectMatchingCard(s.tributespellfilter,tp,LOCATION_SZONE,0,2,2,nil)
    Duel.SendtoGrave(sg,REASON_COST)
end
function s.tributerecoverytarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED+LOCATION_GRAVE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED+LOCATION_GRAVE,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.tributerecoveryoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED+LOCATION_GRAVE,0)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.Draw(tp,5,REASON_EFFECT)
end