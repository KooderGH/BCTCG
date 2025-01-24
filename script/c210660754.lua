--Akechi Mitsuhide
--Scripted By "poka-poka "
--(1) Cannot be Special Summoned from hand or deck.
--(2) Unaffected by your opponent's card effects.
--(3) Cannot be tributed or used as link material.
--(4) When this card is Summoned; Destroy all cards you control. For each card destroyed this way, add 1 equip card from your GY to your hand and this card gains 1000 ATK / DEF.
--(5) You can discard 1 equip card from your hand (Quick); This card gains 1000 ATK / DEF.
--(6) During your opponent's end phase; Lower this card's ATK / DEF by 3000.
--(7) Cannot Direct Attack the turn it is summoned
local s,id=GetID()
function s.initial_effect(c)
	--Effect 1 : Cannot be special summoned from the Hand or Deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(s.splimcon)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	-- Effect 2: This card is unaffected by your opponent's card effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.unaffectedval)
	c:RegisterEffect(e2)
	-- Effect 3: Cannot be tributed or used as link material.
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
	local e5=e3:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e5)
	-- Effect 4: Destroy all cards you control; Add Equip cards to hand and gain ATK/DEF
	-- Effect 7: Cannot Direct Attack the turn it is summoned
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetTarget(s.bulkingtg)
	e6:SetOperation(s.bulkingop)
	c:RegisterEffect(e6)
	local e9=e6:Clone()
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e10=e6:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e10)
	-- Effect 5: Discard 1 Equip card to gain ATK/DEF
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCost(s.qdiscost)
	e7:SetOperation(s.qdisop)
	c:RegisterEffect(e7)
	-- Effect 6: During your opponent's End Phase, lower this card's ATK/DEF by 3000
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(s.weakencon)
	e8:SetOperation(s.weakenop)
	c:RegisterEffect(e8)
end
--(1)
function s.splimcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
--(2)
function s.unaffectedval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--(4)
function s.equipfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.bulkingtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
    end
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.bulkingop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,c)
    if #g > 0 and Duel.Destroy(g,REASON_EFFECT) > 0 then
        local destroyedCount = Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
        local equips = Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_EQUIP)
        local maxAdd = math.min(destroyedCount, #equips)
        if maxAdd > 0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local toAdd = equips:Select(tp,1,maxAdd,nil)
            Duel.SendtoHand(toAdd,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,toAdd)
        end
        if destroyedCount > 0 then
            local atkDefGain = destroyedCount * 1000
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(atkDefGain)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
            c:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            c:RegisterEffect(e2)
        end
		--(7)Cannot Direct Attack
		local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
        e3:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
        c:RegisterEffect(e3)
    end
end
--(5)
function s.qdiscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(s.eqcostfilter,tp,LOCATION_HAND,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,s.eqcostfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.eqcostfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsDiscardable()
end
function s.qdisop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end
--(6)
function s.weakencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.weakenop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end