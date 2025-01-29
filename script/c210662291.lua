-- Zang Roo
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Burrow down
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e1:SetTarget(s.burrowdowntg)
    e1:SetOperation(s.burrowdownop)
    c:RegisterEffect(e1)
    --Burrow up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e2:SetCondition(s.burrowupcon)
    e2:SetTarget(s.burrowuptg)
    e2:SetOperation(s.burrowupop)
    c:RegisterEffect(e2)
    --Excavate (Search Ability)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.srtg)
    e3:SetOperation(s.srop)
    c:RegisterEffect(e3)
end
--burrow down function
function s.burrowdowntg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.burrowdownop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
end
--burrow up function
function s.burrowupcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function s.burrowupfilter(c,atk)
    return c:IsFaceup()
end
function s.burrowuptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(s.burrowupfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,s.burrowupfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function s.burrowupop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
            Duel.SpecialSummon(c,1,tp,1-tp,false,false,POS_FACEUP)
        end
    end
end
--Excavate Search Ability
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsLevel(4) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
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