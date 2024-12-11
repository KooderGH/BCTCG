--By Tungnon (effect 2*1 and 2*2 by Konstak) e3 by poka-poka
--Spectral Goth Vega
local s,id=GetID()
function s.initial_effect(c)
    --Banish 1 target from the GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_ATTACK)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    --act limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetOperation(s.regop)
    c:RegisterEffect(e2)
	-- e3: Draw 1 card when banished, optional additional draw if the drawn card is a monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.drawtg)
	e3:SetOperation(s.drawop)
	c:RegisterEffect(e3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.rmfilter(c)
    return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and s.rmfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,s.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsSummonType(SUMMON_TYPE_TRIBUTE) then return end
    --act limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetValue(s.aclimit)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0xff,0xff)
    e2:SetTarget(s.rmtarget)
    e2:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e2)
end
function s.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER)
end
function s.rmtarget(e,c)
    return Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c)
end
--Draw when banished
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Draw(tp,1,REASON_EFFECT)>0 then
        local g=Duel.GetOperatedGroup()
        local tc=g:GetFirst()
        if tc and tc:IsType(TYPE_MONSTER) and Duel.IsPlayerCanDraw(tp,1) then
            Duel.ConfirmCards(1-tp,tc)
            if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
                Duel.Draw(tp,1,REASON_EFFECT)
            end
        end
    end
end