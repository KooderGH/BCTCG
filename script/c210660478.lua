--Lumina
--Scripted by Gideon
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. You can Special Summon this card from your hand by controling 3 or more Fariy type monsters on the field with different attributes. Then move this card to your Extra Monster Zone.
-- (2) Cannot be returned to hand or banished.
-- (3) Cannot be targeted by card effects.
-- (4) You can only control 1 "Lumina"
-- (5) Once during either players turn (Quick): You can add 1 Fog Counter(s) to all face-up card's on the field.
-- (6) If this card is in your GY or banish (Ignition): You can remove 6 Fog Counters from the field to add this card to your hand. 
-- (7) You can apply the following effects based on the number of Fog Counter(s) on the field:
-- * 3: Monster's you control gain 100 ATK for each Fog Counter(s) on the field.
-- * 5: Once per turn (Igntion), You can remove 5 Fog Counter(s) on the field and Target 1 card on the field: Destroy it.
-- * 10: Once per turn (Igntion), You can remove 10 Fog Counter(s) on the field and Target 1 Card in your GY; Add it to your hand.
-- * 15: Once per turn (Igntion), You can add 4 Fog Counter(s) to this card but you cannot conduct your Battle Phase this turn.
-- * 30: Once per turn (Igntion), You can remove 25 Fog Counter(s) on the field; Shuffle your oppponent's GY and Hand to their deck. 
-- * 90: During your End Phase: If there is 90 or more Fog Counter(s) on the field; You win the duel.
local s,id=GetID()
function s.initial_effect(c)
	--(4) Can only control one
	c:SetUniqueOnField(1,0,id)
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
    e1:SetRange(LOCATION_HAND)
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
    --Cannot be returned to hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Cannot banish
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e5)
    --(2)Finish
    --(3)Start
    --Cannot be targeted (self)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --(3)Finish
    --(4)Start
    --Place 1 fog counter on all face-up's
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,0))
    e7:SetCategory(CATEGORY_COUNTER)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetCountLimit(1)
    e7:SetRange(LOCATION_MZONE)
    e7:SetOperation(s.fcoperation)
    c:RegisterEffect(e7)
    --(4)Finish
    --(5)Start
    --atk def (3 counters)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_UPDATE_ATTACK)
    e8:SetRange(LOCATION_MZONE)
    e8:SetTargetRange(LOCATION_MZONE,0)
    e8:SetCondition(s.atkcon)
    e8:SetValue(s.adval)
    c:RegisterEffect(e8)
    --destroy (5 counters)
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,1))
    e9:SetCategory(CATEGORY_DESTROY)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e9:SetCountLimit(1)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCondition(s.destroycon)
    e9:SetCost(s.destroycost)
    e9:SetTarget(s.destroytarget)
    e9:SetOperation(s.destroyoperation)
    c:RegisterEffect(e9)
    --Recover (10 counters)
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,2))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e10:SetCountLimit(1)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCondition(s.recovercon)
    e10:SetCost(s.recovercost)
    e10:SetTarget(s.recovertarget)
    e10:SetOperation(s.recoveroperation)
    c:RegisterEffect(e10)
    --Add 4 Counters but cannot attack (15 counters)
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(id,3))
    e11:SetCategory(CATEGORY_COUNTER)
    e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetCountLimit(1)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCondition(s.addfourcon)
    e11:SetCost(s.addfourcost)
    e11:SetOperation(s.addfouroperation)
    c:RegisterEffect(e11)
    --Shuffle OP hand and deck (30 counters, 25 to remove)
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id,4))
    e12:SetCategory(CATEGORY_TODECK)
    e12:SetType(EFFECT_TYPE_IGNITION)
    e12:SetCountLimit(1)
    e12:SetRange(LOCATION_MZONE)
    e12:SetCondition(s.shufflecon)
    e12:SetCost(s.shufflecost)
    e12:SetTarget(s.shuffletarget)
    e12:SetOperation(s.shuffleoperation)
    c:RegisterEffect(e12)
    --Win the game (100 counters)
    local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(id,5))
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e13:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
    e13:SetCode(EVENT_PHASE+PHASE_END)
    e13:SetCountLimit(1)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) and Duel.GetCounter(0,1,1,0x1019)>=90 end)
    e13:SetOperation(s.winoperation)
    c:RegisterEffect(e13)
	-- Return to hand
	local e14=Effect.CreateEffect(c)
    e14:SetDescription(aux.Stringid(id,6))
    e14:SetCategory(CATEGORY_TOHAND)
    e14:SetType(EFFECT_TYPE_IGNITION)
    e14:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
    e14:SetCountLimit(1,id)
    e14:SetCost(s.thcost)
    e14:SetTarget(s.thtg)
    e14:SetOperation(s.thop)
    c:RegisterEffect(e14)
end
--Fog counter
s.counter_place_list={0x1019}
--(1) functions
function s.fairyfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(s.fairyfilter,tp,LOCATION_MZONE,0,nil)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and #g>=3 and g:GetClassCount(Card.GetAttribute)>=3
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1))
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local lftezm=Duel.CheckLocation(tp,LOCATION_EMZONE,0) and 0x20 or 0
    local rgtemz=Duel.CheckLocation(tp,LOCATION_EMZONE,1) and 0x40 or 0
    if (lftezm>0 or rgtemz>0) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--(4) functions
function s.fcoperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		tc:AddCounter(0x1019,1)
	end
end
--(5) functions
--e10
function s.atkcon(e,c)
	return Duel.GetCounter(0,1,1,0x1019)>=3
end
function s.adval(e,c)
	return Duel.GetCounter(0,1,1,0x1019)*100
end
--e11
function s.destroycon(e,c)
	return Duel.GetCounter(0,1,1,0x1019)>=5
end
function s.destroycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,5,REASON_COST)
end
function s.destroytarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.destroyoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--e12
function s.recovercon(e,c)
	return Duel.GetCounter(0,1,1,0x1019)>=10
end
function s.recovercost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,10,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,10,REASON_COST)
end
function s.thfilter(c)
	return c:IsAbleToHand()
end
function s.recovertarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.recoveroperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e13
function s.addfourcon(e,c)
	return Duel.GetCounter(0,1,1,0x1019)>=15
end
function s.addfourcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,1),nil)
end
function s.addfouroperation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1019,4)
end
--e14
function s.shufflecon(e,c)
	return Duel.GetCounter(0,1,1,0x1019)>=30
end
function s.shufflecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,25,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1019,25,REASON_COST)
end
function s.shuffletarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND+LOCATION_GRAVE,0)>0 end
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND+LOCATION_GRAVE,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.shuffleoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND+LOCATION_GRAVE,0)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
--e15
function s.winoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,WIN_REASON_LAST_TURN)
end
-- to hand
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1019,6,REASON_COST) end
    Duel.RemoveCounter(tp,1,1,0x1019,6,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end