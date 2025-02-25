-- Cerberus Kids
--Scripted by Konstak, fix by Gid
local s,id=GetID()
function s.initial_effect(c)
    --Excavate (Search Ability)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.srtg)
    e1:SetOperation(s.srop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --Freeze Ability
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCondition(s.freezecon)
    e3:SetOperation(s.freezeop)
    c:RegisterEffect(e3)
end
--Excavate Search Ability
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PSYCHIC) and c:IsAbleToHand()
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	--Effect
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.DisableShuffleCheck()
	if g:IsExists(s.filter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,s.filter,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
			Duel.ShuffleHand(tp)
			g:RemoveCard(tg)
		end
	end
	local ct=#g
	if ct>0 then
		Duel.MoveToDeckTop(g,tp)
		Duel.SortDecktop(tp,tp,ct)
	end
end
--Freeze Function
function s.freezecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle() and Duel.GetTurnPlayer()==tp
end
function s.freezeop(e,tp,eg,ep,ev,re,r,rp)
    local effp=e:GetHandler():GetControler()
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.TossCoin(tp,1)==COIN_HEADS then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SKIP_DP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        if Duel.GetTurnPlayer()==effp then
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetCondition(s.skipcon)
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
        end
        Duel.RegisterEffect(e1,effp)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetCategory(CATEGORY_DRAW)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetCondition(s.retcon)
        e2:SetLabel(Duel.GetTurnCount())
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        e2:SetCountLimit(1)
        e2:SetOperation(s.droperation)
        Duel.RegisterEffect(e2,effp)
        Duel.NegateAttack()
    end
end
function s.skipcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end