--Sakura Sonic
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    -- Effect 1: Flip a coin at the start of the Battle Phase
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
    e1:SetCondition(s.coin_condition)
    e1:SetOperation(s.coin_operation)
    c:RegisterEffect(e1)
    -- Effect 2: Quick Effect to discard hand, destroy all cards, opponent takes no damage
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0)) 
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.discard_condition)
    e2:SetCost(s.discard_cost)
    e2:SetOperation(s.discard_operation)
    c:RegisterEffect(e2)
    -- Effect 3: Declare a Monster Type when destroying a monster in battle
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1)) 
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(s.onbdescon)
	e3:SetTarget(s.onbdestg)
    e3:SetOperation(s.onbdesop)
    c:RegisterEffect(e3)
    -- Effect 4: No LP damage from battles involving this card
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
    -- Effect 5: Banish a card your opponent controls if this card is banished
    local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2)) 
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_REMOVE)
    e5:SetTarget(s.rmtg)
    e5:SetOperation(s.rmop)
    c:RegisterEffect(e5)
end
-- Effect 1 Functions
function s.coin_condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup()
end
function s.coin_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local coin=Duel.TossCoin(tp,1) -- Toss coin once: 0 is tails, 1 is heads
    if coin==1 then
        -- Heads: Gain 1800 ATK
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1800)
        e1:SetReset(RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    else
        -- Tails: Opponent's monsters cannot attack this card
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
        e2:SetValue(aux.imval1)
        e2:SetReset(RESET_PHASE+PHASE_BATTLE)
        c:RegisterEffect(e2)
    end
end
-- Effect 2 Functions
function s.discard_condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=2 and
           Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD) >
           Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
end
function s.discard_cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=2 end
    local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    Duel.SendtoGrave(hg,REASON_COST+REASON_DISCARD)
end
function s.discard_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- Destroy all other cards on the field
    local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
    if g:GetCount()>0 then
        g:RemoveCard(c)
        Duel.Destroy(g,REASON_EFFECT)
    end
    -- Prevent further damage this turn
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
-- Effect 3 Functions
function s.onbdescon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsMonster() and (bc:IsLocation(LOCATION_GRAVE) or bc:IsLocation(LOCATION_REMOVED))
end
function s.onbdestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(ac)
end
function s.onbdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot attack announce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.tglimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.tglimit)
	e2:SetLabel(e:GetLabel())
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function s.tglimit(e,c)
	return c:IsRace(e:GetLabel())
end
-- Effect 5 Functions
 function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end