-- Shibalien Elite
--Scripted By Konstak
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
    --Targetable Warp Mechanic
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.warptg)
    e3:SetOperation(s.warpop)
    c:RegisterEffect(e3)
    --return hand (Peon Ability)
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetTarget(s.destg)
    e4:SetOperation(s.desop)
    c:RegisterEffect(e4)
end
--Excavate Search Ability
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsLevelBelow(3) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_CELESTIALWARRIOR) and c:IsAbleToHand()
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
		local tg=g:FilterSelect(tp,s.filter,1,2,nil)
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
--Warp Function
function s.warpfilter(c)
	return c:IsAbleToRemove() and c:IsMonster() and c:IsCanBeEffectTarget() and not c:IsCode(id)
end
function s.warptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.warpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.HintSelection(g)
        if Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetReset(RESET_PHASE+PHASE_MAIN1,3)
            e1:SetLabelObject(tc)
            e1:SetCountLimit(1)
            e1:SetOperation(s.returnop)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==2 then
        ct=0
        c:SetTurnCounter(ct)
        Duel.Hint(HINT_CARD,0,id)
        Duel.ReturnToField(e:GetLabelObject())
    end
end
--Peon Ability
function s.destg(e,tp,eg,ev,ep,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ev,ep,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end