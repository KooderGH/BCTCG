--Trixi the Revenant 
--Scripted by "poka-poka"
--Effect:
--(1) Cannot be normal summoned/set. Must be special summoned (from your hand) by tributing 2 monsters you control and sending 1 face-up Spell/Trap you control to the GY
--(2) This card cannot move to defense position nor be flipped face-down. (If an effect would move it, move it to attack position instead.)
--(3) Unaffected by spell/trap effects and activated effects from any monster who's original level/rank is lower than this card's current level
--(4) Before damage calculation involving this card, target 1 monster on your opponent's side of the field; Your opponent takes damage equal to its ATK.
--(5) During your opponent's battle phase, all of your opponent's monsters are changed to face-up attack position and must attack if able to.
--(6) Each time a player rolls a die (or dice), you can choose 1 die to change the result; Change the dice result to what you wish (between 1-6).
--(7) Each time a coin is flipped, you can change the result.
--(8) Once per turn, when an monster effect your opponent control's targets 1 player is activated, you can activate this effect (Quick); That monster effect is applied to the other player instead.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--Special Summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	-- Special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Always Attack Position (2)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_POSITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(POS_FACEUP_ATTACK)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e2)
	--Unaffected by cards' effects (3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	-- Damage before damage calculation (4)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(s.burncon)
	e4:SetTarget(s.burntg)
	e4:SetOperation(s.burnop)
	c:RegisterEffect(e4)
	-- force attack
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.forceatkcon)
	e5:SetTarget(s.forceatktarget)
	e5:SetOperation(s.forceatkop)
	c:RegisterEffect(e5)
	--dice
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TOSS_DICE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(s.diceop)
	c:RegisterEffect(e6)
	--coin
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_TOSS_COIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(s.coinop)
	c:RegisterEffect(e7)
	--change target player
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,0))
	e8:SetCategory(CATEGORY_DISABLE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(s.redirectcon)
	e8:SetTarget(s.redirecttg)
	e8:SetOperation(s.redirectop)
	c:RegisterEffect(e8)
end

-- 1
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(Card.IsReleasable,c:GetControler(),LOCATION_MZONE,0,2,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
-- 3
function s.efilter(e,te)
	if te:IsSpellTrapEffect() then
		return true
	else
		return aux.qlifilter(e,te)
	end
end

-- 4 
function s.burncon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function s.burntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function s.burnop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local atk=tc:GetAttack()
        Duel.Damage(1-tp,atk,REASON_EFFECT)
    end
end
--5
function s.forceatkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.forceatktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,#sg,0,0)
end
function s.forceatkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #sg>0 then
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK,0,POS_FACEUP_ATTACK,0)
		local tc=sg:GetFirst()
		for tc in aux.Next(sg) do
			--Must attack, if able to
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(3200)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function s.befilter(c)
	return c:GetFlagEffect(id)~=0 and c:CanAttack()
end
--6
function s.diceop(e,tp,eg,ep,ev,re,r,rp)
    local dc={Duel.GetDiceResult()} 
    local ct=#dc 
    if ct==0 then return end 
    local cancelDice={}
    for i=1,ct do
        cancelDice[i]=0
    end
    Duel.SetDiceResult(table.unpack(cancelDice))
    local selDice={}
    for i=1,ct do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
        local sel=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
        table.insert(selDice, sel)
    end
    Duel.SetDiceResult(table.unpack(selDice))
end
--7
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
    local results={Duel.GetCoinResult()}
    local ct=#results
    if ct==0 then return end
    local CancelCoins={}
    for i=1,ct do
        CancelCoins[i]=0 
    end
    Duel.SetCoinResult(table.unpack(CancelCoins))
    local newResults={}
    for i=1,ct do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
        local sel=Duel.AnnounceCoin(tp) 
        table.insert(newResults, sel)
    end
    Duel.SetCoinResult(table.unpack(newResults))
end
--8
function s.redirectcon(e,tp,eg,ep,ev,re,r,rp)
    local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
    local tc=te:GetHandler()
    return rp==1-tp and tc:IsControler(1-tp) and te:IsActivated() and te:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET)
end
function s.redirecttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.redirectop(e,tp,eg,ep,ev,re,r,rp)
    local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
    local targetPlayer=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
    if not targetPlayer then return end
    local newTarget=1-targetPlayer
    Duel.ChangeTargetPlayer(ev,newTarget)
end