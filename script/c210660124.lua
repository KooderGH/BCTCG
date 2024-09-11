--Date Masamune
--Scripted By senorpizza
--[[
(1) Can be Special Summoned from your hand or GY by tributing 1 FIRE monster you control. You can only use this effect of "Date Masamune" once per turn.
(2) You can only control 1 "Date Masamune".
(3) When this card is Normal Summoned; Add 2 FIRE monster's from your deck to your hand.
(4) While this card gains the following effect(s) based on the number of Equip Cards equipped to it.
	1+ Once per turn (Igntion): You can target 1 monster your opponent controls; Return that monster to your opponent's hand.
	3+ When your opponent activate's a card or effect that target's a monster you control (Quick Effect): You can send 1 Equip Card you control to the GY; negate that effect.
	5+ Once per turn (Igntion): You can add 1 Level 12 FIRE monster from your deck or GY to your hand.
]]--
local s,id=GetID()
function s.initial_effect(c)
	--You can only control 1 "Date Masamune". (DONE)
	
	c:SetUniqueOnField(1,0,id)
	
	--(1) Can be Special Summoned from your hand or GY by tributing 1 FIRE monster you control. You can only use this effect of "Date Masamune" once per turn. (1/2 DONE, Graveyard SS does not work) 

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND + LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--(3) When this card is Normal Summoned; Add 2 FIRE monster's from your deck to your hand. (DONE)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)

	--(4, 1) 1+ Once per turn (Igntion): You can target 1 monster your opponent controls; Return that monster to your opponent's hand. (DONE)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id)
	e3:SetCondition(s.retcon)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end

--e1 (DONE)

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsAttribute,1,false,1,true,c,c:GetControler(),nil,false,nil,ATTRIBUTE_FIRE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,false,true,true,c,nil,nil,false,nil,ATTRIBUTE_FIRE)
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

--e2 (DONE)

function s.thfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,2,2,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end

--e3 (4.1) (DONE)

function s.retcon(e)
	local c=e:GetHandler()
	return c:GetEquipCount()>=1
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
