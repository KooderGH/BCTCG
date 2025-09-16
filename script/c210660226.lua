--Warlock and Pirerre
--Scripted by Gideon. Got aid from pyrQ and larry.
--Effect:
-- If this card attacks, it is changed to Defense Position at the end of the Battle Phase, and its battle position cannot be changed until the End Phase of your next turn.
-- If this card attacks directly, before damage calulation; double this card attack, then destroy this card at the end of the damage step. 
-- When this card is sent to the graveyard, you can target 1 LV 4 or lower DARK Warrior monster in your graveyard except "Warlock and Pierre"; add that card to your hand.
local s,id=GetID()
function s.initial_effect(c)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.poscon)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	--search went sent to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--destroy itself raise atk trigger
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_CONFIRM)
    e3:SetCondition(function() return Duel.GetAttackTarget()==nil end)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- If attacks, then go to def
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
	c:RegisterEffect(e1)
end
-- End of E1 stuff, start of E2
-- Filter for graveyard targets
function s.rfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(id)
end
-- Targets
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
-- The grave operation
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- End of E2 stuff, start of E3
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(c:GetAttack()*2)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_PHASE|PHASE_DAMAGE)
        c:RegisterEffect(e1)
    end
    c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE,0,1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EVENT_DAMAGE_STEP_END)
    e2:SetCountLimit(1)
    e2:SetOperation(function(e,tp) if c:HasFlagEffect(id) then Duel.Destroy(c,REASON_EFFECT) end end)
    e2:SetReset(RESET_PHASE|PHASE_DAMAGE)
    Duel.RegisterEffect(e2,tp)
end
-- 2 Effects at once. First activates to trigger double attack. Then flags itself immune for the cost to destroy itself
-- Thanks to pryQ to the desop
-- End of card