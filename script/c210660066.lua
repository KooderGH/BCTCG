-- PPT46
-- Scripted by poka-poka
-- Effect : (1) If you control a Princess Punt Banner monster on the field (Ignition); You can Special Summon this card from your hand or GY. If summoned this way, cannot be used as link material except for the monster "Manic Princess Punt". You can only use this effect of "PPT46" once per turn.
--			(2) You can only control 1 "PTT46" on the field.
--			(3) This card cannot be tributed or banished from the field and cannot be Special Summoned except it's own effect's.
-- 			(4) If you have 10 or more cards in your GY: this card is unaffected by card effects except itself.
--			(5) If you have 20 or more cards in your GY: increase this card's attack by 1500 and level by 4.
--			(6) If you have 35 or more cards in your GY (Ignition), you can target 1 Princess Punt Banner monster in your GY; Special Summon it.
--			(7) (Igntion) Activate only if you have 46 or more cards in your GY; Place 1 Princess Punt Counter on this card. When this card has 2 Princess Punt Counter(s), you win the duel.

local s,id=GetID()
function s.initial_effect(c)
	-- Effect 2: Can only control one 
	c:SetUniqueOnField(1,0,id)
    -- Effect 1: Special Summon from hand or GY if you control a "Princess Punt Banner" monster
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
	-- Effect 3 : cannot be tributed, banised. and cannot be special summoned except by own effect.
	-- No sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(s.splimit)
	c:RegisterEffect(e2)
	--cannot be tributed
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_UNRELEASABLE_SUM)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e4)
	--cannot be banished
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EFFECT_CANNOT_REMOVE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
	--Effect 4 :unaffected by other card effect
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.imcon)
    e6:SetValue(s.immunefilter)
    c:RegisterEffect(e6)
	-- Effect 5: Increase attack and level
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.atkcon)
	e7:SetValue(1500)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_LEVEL)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.atkcon)
	e8:SetValue(4)
	c:RegisterEffect(e8)
	-- Effect 6: special summon 1 punt banner monster
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(s.spcon2)
	e9:SetTarget(s.sptg2)
	e9:SetOperation(s.spop2)
	c:RegisterEffect(e9)
	-- Effect 7: add 1 counter, win at 2 counter
	c:EnableCounterPermit(0x4008)
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_COUNTER)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1,id)
	e10:SetCondition(s.countercon)
	e10:SetOperation(s.counterop)
	c:RegisterEffect(e10)
	--Win con
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetProperty(EFFECT_FLAG_DELAY)
    e11:SetCode(EVENT_ADJUST)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCondition(s.wincon)
    e11:SetOperation(s.winop)
    c:RegisterEffect(e11)
end
--Princess Punt counter
s.counter_place_list={0x4008}
--effect 1
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.puntbannerfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.puntbannerfilter(c)
    return c:IsFaceup() and (c:IsCode(210660337) or c:IsCode(210660066) or c:IsCode(210661067) or c:IsCode(210660485) or c:IsCode(210660530) or c:IsCode(210661068) or c:IsCode(210660161))
end
-- Special Summon this card
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(function(e,lc) return not lc:IsCode(210660161) end)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1,true)
    end
end
function s.splimit(e,se,sp,st)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
        return se:GetHandler()==c
    end
    return true
end
--immune
function s.imcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_GRAVE,0) >= 10
end
function s.immunefilter(e,te)
    return te:GetHandler()~=e:GetHandler()
end
--atk & lv
function s.atkcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_GRAVE,0)>=20
end
--sp summon 1 punt
function s.bannerfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsCode(210660337) or c:IsCode(210660066) or c:IsCode(210661067) or c:IsCode(210660485) or c:IsCode(210660530) or c:IsCode(210661068) or c:IsCode(210660161))
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=35
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.bannerfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingMatchingCard(s.bannerfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.bannerfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- add 1 Counter
function s.countercon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=46
end
function s.counterop (e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x4008,1)
end
--win
function s.wincon(e)
	return e:GetHandler():GetCounter(0x4008)>=2
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x67)
end