--Princess Kaguya
--Scripted by Konstak
--Effect
-- (1) You can only control 1 "Princess Kaguya"
-- (2) If you control a WIND Attribute monster, you can Special Summon this card from your hand.
-- (3) You can only use 1 of these effects of "Princess Kaguya" per turn, and only once that turn.
-- * Once per turn: You can have all wind monsters gain 400 ATK for each wind monster you control until your opponent's end phase.
-- * If this card is send to the GY; You can Special Summon one WIND Machine monster from your hand.
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
    --Special Summon this card (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.spcon)
	e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
    --gain atk
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE)
    e3:SetCountLimit(1,id)
	e3:SetCondition(s.atkcon)
    e3:SetTarget(s.atktg)
    e3:SetOperation(s.atkop)
    c:RegisterEffect(e3)
    --Once destroyed Special Summon 1 WIND Machine Monster
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,id)
    e4:SetTarget(s.sstg)
    e4:SetOperation(s.ssop)
    c:RegisterEffect(e4)
end
--Special summon this card function
function s.spfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--ATK Gain function
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(s.adval)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,2)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
		local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_REVERSE_DAMAGE)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetTargetRange(0,1)
		e2:SetValue(1)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
    end
end
function s.adval(e,c)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_WIND),c:GetControler(),LOCATION_ONFIELD,0,nil)*400
end
--Once destroyed function
function s.specialfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.specialfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.specialfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
