--Imagawa Yoshimoto
--Scripted By poka-poka

local s,id=GetID()
function s.initial_effect(c)
    -- Effect 1: Destroy all non-Warrior monsters on the field when Tribute Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    -- Effect 2: Gain 500 ATK for each face-up Spell on the field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)
    -- Effect 3: Negate monster effect by sending this card and an Equip Spell from your hand to the GY (Quick Effect)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_HAND)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetCondition(s.negcon)
    e3:SetCost(s.negcost)
    e3:SetTarget(s.negtg)
    e3:SetOperation(s.negop)
    c:RegisterEffect(e3)
    -- Effect 4: Banish this card from the GY and add an Equip Spell from your GY to your hand
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCondition(s.thcon)
    e4:SetCost(s.thcost)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)
end

-- Effect 1 
function s.destroyfilter(c)
    return c:IsMonster() and not c:IsRace(RACE_WARRIOR)
end
-- Target non-Warrior monsters on the field
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.destroyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(s.destroyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

-- Operation function: destroy all non-Warrior monsters and apply restriction to Dragons
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(s.destroyfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if Duel.Destroy(sg,REASON_EFFECT)>0 then
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
        e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND)
        e2:SetTargetRange(1,0)
        e2:SetValue(function(_,re) return re:IsMonsterEffect() and re:GetHandler():IsRace(RACE_DRAGON) end)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
    end
end

-- Effect 2
-- Gain ATK for each Equip Spell
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(function(card) return card:IsType(TYPE_SPELL) and card:IsFaceup() end, e:GetHandlerPlayer(), LOCATION_ONFIELD, LOCATION_ONFIELD, nil) * 500
end
-- Effect 3
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
-- Send this card and 1 equip spell
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_EQUIP)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local eq=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_EQUIP)
    Duel.SendtoGrave(eq,REASON_COST)
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
-- Effect 4
-- Banish this card from GY
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsLocation(LOCATION_GRAVE) or e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
-- Return 1 euip spell from GY to hand
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_EQUIP) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_EQUIP)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
