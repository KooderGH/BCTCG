--Strike Unit R.E.I.
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    -- Effect 3: Only control 1 "Strike Unit R.E.I."
	c:SetUniqueOnField(1,0,id)
    -- Effect 1: Special Summon if opponent controls 3 or more Dragon/Spellcaster monsters
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))  
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon1)
    e1:SetOperation(s.spop1)
    c:RegisterEffect(e1)
    -- If summoned this way, destroy all cards.
    local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.descon)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	c:RegisterEffect(e0)
    -- Effect 2: Special Summon by discarding 2 cards
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))  
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
    e2:SetCondition(s.spcon2)
    e2:SetTarget(s.sptg2)
    e2:SetOperation(s.spop2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.recovcon)
	e3:SetTarget(s.recovtg)
	e3:SetOperation(s.recovop)
	c:RegisterEffect(e3)
    -- Effect 4: Controller Effect Damage becomes LP gain
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_REVERSE_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(1,0)
	e4:SetValue(s.rev)
	c:RegisterEffect(e4)
    -- Effect 5: Add 1 card from GY if you control 3 or more Machine monsters
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,4))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(s.thcon)
    e5:SetTarget(s.thtg)
    e5:SetOperation(s.thop)
    c:RegisterEffect(e5)
    -- Effect 6: Send 1 monster from Deck to GY, then draw 1 card if you control 3 or more Warrior monsters
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,5))
    e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(s.warcon)
    e6:SetTarget(s.wartg)
    e6:SetOperation(s.warop)
    c:RegisterEffect(e6)
    -- Effect 7: During damage calculation, ATK becomes 5000
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,6))
    e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e7:SetCountLimit(1,id,EFFECT_COUNT_CODE_CHAIN)
    e7:SetCondition(s.atkcon)
    e7:SetCost(s.atkcost)
    e7:SetOperation(s.atkop)
    c:RegisterEffect(e7)
end
-- Effect 1 condition: Opponent controls 3 or more Dragon/Spellcaster monsters
function s.spcon1(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.dragon_spellcaster_filter,c:GetControler(),0,LOCATION_MZONE,3,nil)
end
function s.dragon_spellcaster_filter(c)
    return c:IsRace(RACE_DRAGON+RACE_SPELLCASTER)
end
-- Effect 1 operation: SS
function s.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
-- Effect 1 Check if ss this way and if true, do rest of effect (destroy, draw, prevent damage)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    local ct=Duel.Destroy(sg,REASON_EFFECT)
            if ct>0 then
            Duel.BreakEffect()
            Duel.Draw(1-tp,ct,REASON_EFFECT)
        end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CHANGE_DAMAGE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        e1:SetValue(0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
end
-- Effect 2 condition: Discard 2 cards to Special Summon
function s.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	return aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0,c)
end
-- Effect 2 operation: Discard and add 1 card from GY to hand
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_DISCARD,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
--If Summoned this way, Add to hand.
function s.recovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+2
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,0,REASON_EFFECT)
	end
end
-- Effect 4 : Filter effect damage
function s.rev(e,re,r,rp,rc)
	return (r&REASON_EFFECT)>0
end
-- Effect 5 condition: 3 or more Machine monsters
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_MACHINE)>=3
end
-- Effect 5 target and operation
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
-- Effect 6 condition: 3 or more Warrior monsters
function s.warcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_WARRIOR)>=3
end
-- Effect 6 target and operation
function s.wartg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.warop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
-- Effect 7 condition: During damage calculation
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()~=nil
end
-- Effect 7 cost: Send 1 monster from field to GY
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
-- Effect 7 operation: ATK becomes 5000
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(5000)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e1)
        -- Destroy during end phase
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetCountLimit(1)
        e2:SetOperation(s.desop2)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
    end
end
-- Destroy during end phase
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end