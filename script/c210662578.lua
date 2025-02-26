-- Metal Ball
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Metal Mechanic
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.desatktg)
    c:RegisterEffect(e1)
    --self destroy
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_SELF_DESTROY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.sdcon)
    c:RegisterEffect(e2)
    --Cannot be targeted (Metal Coat)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Excavate (Search Ability)
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(s.srtg)
    e4:SetOperation(s.srop)
    c:RegisterEffect(e4)
end
--Metal Ability
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsFaceup() end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetValue(-50)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
    c:RegisterEffect(e1)
    return true
end
function s.sdcon(e)
    local c=e:GetHandler()
    return c:GetDefense()<=0
end
--Excavate Search Ability
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsLevelAbove(6) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
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