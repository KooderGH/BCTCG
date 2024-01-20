--Shining Amaterasu
--Scripted by Konstak.
--Effect:
-- (1) You can Special Summon this card from your Hand by banishing one trap card from your GY. 
-- (2) Can attack all monsters you opp controls once each.
-- (3) When this card attacks; Gain 800 atk.
-- (4) When this card has 5000 or more ATK, You can Tribute this card (Igntion); Draw 2 cards. 
local s,id=GetID()
function s.initial_effect(c)
	--special summon (1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --Attack all each time (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --When this card attacks; Gain 800 atk (3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
    e4:SetCondition(s.atkcon)
    e4:SetOperation(s.atkop)
    c:RegisterEffect(e4)
	--draw 2 cards when tribute (4) 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.trcon)
	e5:SetCost(s.trcost)
	e5:SetOperation(s.trop)
	c:RegisterEffect(e5)
end
--e1
function s.spfilter(c,att)
    return c:IsAbleToRemoveAsCost() and c:IsTrap()
end
function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
    return aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
    local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_DISCARD,nil,nil,true)
    if #g>0 then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    end
    return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    g:DeleteGroup()
end
--e3
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsRelateToBattle()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(800)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end
--e4
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttack()>=5000
end
function s.trcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,2,REASON_EFFECT)
end