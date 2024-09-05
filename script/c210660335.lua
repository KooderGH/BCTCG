--Sea Maiden Ruri
--Old effect Scripted by senorpizza
--Previous effect(1) During your opponent's turn (Quick Effect): You can Tribute this card from your hand or face-up field; neither player can banish cards for the rest of this turn.
--New effect Scripted by poka-poka

local s,id=GetID()
function s.initial_effect(c)
    -- Effect 1: Send from hand to GY and banish cards sent to GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.nograycon)
    e1:SetCost(s.handcost)
    e1:SetOperation(s.banishop)
    c:RegisterEffect(e1)
    -- Effect 2: Return from banished zone to GY, draw 2 cards (Once per Duel)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_REMOVED)
    e2:SetCost(s.banishcost)
    e2:SetOperation(s.drawop)
    e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    c:RegisterEffect(e2) 
    -- Effect 3: Special Summon from hand if you control no monsters
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetRange(LOCATION_HAND)
    e3:SetCondition(s.spcon)
    c:RegisterEffect(e3)
    -- Effect 4: Equip and take control during End Phase if destroyed by opponent card
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
    e4:SetCondition(s.eqcon)
    e4:SetTarget(s.eqtg)
    e4:SetOperation(s.eqop)
    c:RegisterEffect(e4)
end

-- Condition for Effect 1: No cards in GY
function s.nograycon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp, LOCATION_GRAVE, 0)==0
end
-- Cost for Effect 1: Send this card from hand to GY
function s.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(), REASON_COST)
end
-- Operation for Effect 1: Cards sent to GY are banished instead
function s.banishop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetTargetRange(0xff, 0xff)
    e1:SetValue(LOCATION_REMOVED)
    e1:SetReset(RESET_PHASE+PHASE_END + RESET_OPPO_TURN)
    Duel.RegisterEffect(e1,tp)
end
-- Cost for Effect 2: Return this card from banished zone to GY
function s.banishcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGrave() end
    Duel.SendtoGrave(e:GetHandler(), REASON_COST + REASON_RETURN)
end
-- Operation for Effect 2: Draw 2 cards
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,2,REASON_EFFECT)
end
-- Condition for Effect 3: Control no monsters
function s.spcon(e,c)
    if c == nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(), LOCATION_MZONE,0)==0
end
-- Condition for Effect 4: Sent to GY because destroyed by opponent's card
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    return c:IsReason(REASON_DESTROY) and rp ~= tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
-- Target for Effect 4: Equip to an opponent's monster
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.CheckStealEquip(chkc, e, tp) end
    if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,aux.CheckStealEquip,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
-- Equip limit function
function s.eqlimit(e,c)
    return e:GetOwner()==c
end
-- Operation for Effect 4: Equip this card and take control of target
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and aux.CheckStealEquip(tc, e, tp) and tc:IsRelateToEffect(e) and Duel.Equip(tp, c, tc) then
        -- Add Equip limit
        local e1 = Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        e1:SetValue(s.eqlimit)
        c:RegisterEffect(e1)
        -- Control of equipped monster
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetCode(EFFECT_SET_CONTROL)
        e2:SetValue(tp)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
        c:RegisterEffect(e2)
    end
end
