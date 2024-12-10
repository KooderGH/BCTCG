--Sarukani
--Scripted by Konstak.
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) If you control 2 or more WIND monsters, you can tribure 1 WIND monster to Special Summon this card from your hand.
-- (3) During the damage step, if this card battles a Fairy or Zombie monster, this card gains 2900 ATK until the end of the damage step.
-- (4) You can only use 1 of these effects of "Sarukani" per turn, and only once that turn.
-- * (Quick) You can banish 1 WIND monster from your GY and target 1 card on the field; Destroy it
-- * If this card is sent to the GY: You can tribute 1 WIND monster on your side of the field; Special Summon this card but it cannot attack this turn.
local s,id=GetID()
function s.initial_effect(c)
    --self destroy (1)
--    local e1=Effect.CreateEffect(c)
--    e1:SetType(EFFECT_TYPE_SINGLE)
--    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
--    e1:SetRange(LOCATION_MZONE)
--    e1:SetCode(EFFECT_SELF_DESTROY)
--    e1:SetCondition(s.sdcon)
--    c:RegisterEffect(e1)
    --Special Summon this card (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    --during damage calculation gain 2900 atk (3)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetTarget(s.atktg)
    e3:SetOperation(s.atkop)
    c:RegisterEffect(e3)
    --destroy (2)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,id)
    e4:SetCost(s.descost)
    e4:SetTarget(s.destg)
    e4:SetOperation(s.desop)
    c:RegisterEffect(e4)
    --if this card is sent to the GY
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1,id)
    e5:SetCost(s.sp2cost)
    e5:SetTarget(s.sp2tg)
    e5:SetOperation(s.sp2op)
    c:RegisterEffect(e5)
end
--Self Destroy Function
--function s.sdfilter(c)
--    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
--end
--function s.sdcon(e)
--    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
--end
--Special Summon Function
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsAttribute,2,false,2,true,c,c:GetControler(),nil,false,nil,ATTRIBUTE_WIND)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,false,true,true,c,nil,nil,false,nil,ATTRIBUTE_WIND)
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
--during damage calculation function
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and (bc:IsRace(RACE_FAIRY) or bc:IsRace(RACE_ZOMBIE))  end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToBattle() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(2900)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e1)
    end
end
--Banish and Destroy function
function s.desfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--Special summon from GY but cannot attack
function s.gyfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.gyfilter,1,false,nil,nil) end
    local g=Duel.SelectReleaseGroupCost(tp,s.gyfilter,1,1,false,nil,nil)
    Duel.Release(g,REASON_COST)
end
function s.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sp2op(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end