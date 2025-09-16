-- Big Peng Z
--Scripted by Konstak.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --special summon tribute
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_HAND)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetCondition(s.spcon)
    e0:SetTarget(s.sptg)
    e0:SetOperation(s.spop)
    c:RegisterEffect(e0)
    --Revive
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCost(s.sumcost)
    e1:SetCondition(s.sumcon)
    e1:SetTarget(s.sumtg)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)
    --Excavate (Search Ability)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.srtg)
    e2:SetOperation(s.srop)
    c:RegisterEffect(e2)
    --Colossal Mechanic
    local e3=Effect.CreateEffect(c)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(s.desatktg)
    c:RegisterEffect(e3)
    --self destroy Colossal Mechanic
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(s.sdcon)
    c:RegisterEffect(e4)
    --Toxic Ability
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetCondition(s.toxiccon)
    e5:SetTarget(s.toxictg)
    e5:SetOperation(s.toxicop)
    c:RegisterEffect(e5)
end
function s.zombiefilter(c)
	return c:IsFaceup() and c:IsCode(210662469)
end
function s.spcon(e,c)
	if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.zombiefilter,3,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,s.zombiefilter,3,3,false,true,true,c,nil,nil,false,nil,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Release(g,REASON_COST)
    g:DeleteGroup()
end
--Revive
function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function s.sumcon(e,tp,c)
    if c==nil then return true end
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and ct<1 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    if e:GetHandler():IsRelateToEffect(e) then
        ct=ct+1
        c:SetTurnCounter(ct)
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
    end
end
--Excavate Search Ability
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=15 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.srfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	--Effect
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<15 then return end
	Duel.ConfirmDecktop(tp,15)
	local g=Duel.GetDecktopGroup(tp,15)
	Duel.DisableShuffleCheck()
	if g:IsExists(s.srfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,s.srfilter,1,2,nil)
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
--Colossal Mechanic
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsFaceup() end
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e0:SetCode(EFFECT_UPDATE_ATTACK)
        e0:SetValue(500)
        e0:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
        c:RegisterEffect(e1)
    return true
end
function s.sdcon(e)
    local c=e:GetHandler()
    return c:GetAttack()>=3300
end
--Toxic on Battle function
function s.filter(c)
    return c:IsFaceup()
end
function s.toxiccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.toxictg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.toxicop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
    local c=e:GetHandler()
    local tc=sg:GetFirst()
    for tc in aux.Next(sg) do
        Duel.NegateAttack()
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_UPDATE_ATTACK)
        e0:SetReset(RESET_EVENT+RESETS_STANDARD)
        e0:SetValue(-500)
        tc:RegisterEffect(e0)
    end
end