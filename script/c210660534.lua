--Hades The Punisher
--Scripted by Konstak
--Effect
-- (1) Can Be Set without Tribute.
-- (2) When a Card is activated that targets this face-down card (Quick Effect): Change this card to face-up Defense Position, and if you do, negate the activation and if you do, banish it.
-- (3) After damage caluation involving this card: You can target 1 monster in your GY; add it to your hand.
-- (4) When this card is Tributed: Special Summon 1 Monster from your Deck and make it's ATK and DEF 0.
-- (5) When this card is destroyed; You can Special Summon this card in Defense Position during the End Phase. 
local s,id=GetID()
function s.initial_effect(c)
    --Can Be Set without Tribute. (1) 
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    c:RegisterEffect(e1)
    --Change this card to face-up Defense Position, and if you do, negate the activation and if you do, banish it (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.discon)
    e2:SetCost(s.discost)
    e2:SetTarget(s.distg)
    e2:SetOperation(s.disop)
    c:RegisterEffect(e2)
    --After damage caluation involving this card: You can target 1 monster in your GY; add it to your hand. (3)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLED)
    e3:SetCondition(s.scon)
    e3:SetTarget(s.stg)
    e3:SetOperation(s.sop)
    c:RegisterEffect(e3)
    --When this card is Tributed: Special Summon 1 Monster from your Deck and make it's ATK and DEF 0. (4) 
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetCode(EVENT_RELEASE)
    e4:SetTarget(s.sptg)
    e4:SetOperation(s.spop)
    e4:SetLabel(1)
    c:RegisterEffect(e4)
    --When this card is destroyed; You can Special Summon this card in Defense Position during the End Phase. (5) 
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCondition(s.drcon)
    e5:SetTarget(s.drtg)
    e5:SetOperation(s.drop)
    c:RegisterEffect(e5)
end
--(2)
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    local c=e:GetHandler()
    if not tg then return false end
    return tg:IsContains(c) and c:IsFacedown()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
    end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
--(3)
function s.searchfilter(c,e,tp)
    return c:IsAbleToHand()
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttackTarget()
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.searchfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.searchfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--(4)
function s.specialfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.specialfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE)
        tc:RegisterEffect(e2)
    end
end
--(5)
function s.dfilter(c)
	return c:IsCode(id) and c:IsAbleToHand()
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end