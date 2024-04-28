--Necro-Dancer Cat
--Link Monster (LD,RD)
--2 monsters with different names, except tokens.
--(1) Cannot be used as Link material.
local s,id=GetID()
function s.initial_effect(c)
    --Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,aux.NOT(aux.FilterBoolFunctionEx(Card.IsType,TYPE_TOKEN)),2,2,s.lcheck)
    --cannot link material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --control
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
    e2:SetCondition(s.ctcon)
    e2:SetTarget(s.cttg)
    e2:SetOperation(s.ctop)
    c:RegisterEffect(e2)
    --control
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CONTROL_CHANGED)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(s.conop)
    c:RegisterEffect(e3)
    --cannot be battle target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e4:SetCondition(s.con)
    e4:SetValue(aux.imval1)
    c:RegisterEffect(e4)
end
--lcheck
function s.lcheck(g,lc,sumtype,tp)
	return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end
--Take Control
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetHandler():GetCardTarget()
    return not g:IsExists(Card.IsControler,1,nil,tp)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.GetControl(tc,tp) then
            if c:GetFlagEffect(id)==0 then
                c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_SET_CONTROL)
                e1:SetRange(LOCATION_MZONE)
                e1:SetTargetRange(LOCATION_MZONE,0)
                e1:SetTarget(s.cttg2)
                e1:SetValue(s.ctval)
                c:RegisterEffect(e1)
            end
            c:SetCardTarget(tc)
        end
    end
end
function s.ctval(e,c)
    return e:GetHandlerPlayer()
end
function s.cttg2(e,c)
    return e:GetHandler():IsHasCardTarget(c)
end
--Control
function s.conop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget():Filter(Card.IsControler,nil,tp)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local des=g:Select(tp,1,1,nil)
		Duel.Destroy(des,REASON_EFFECT)
	end
end
--Cannot target
function s.filter(c,e)
    return e:GetHandler():IsHasCardTarget(c)
end
function s.con(e)
    local c=e:GetHandler()
    return Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,c,e)
end