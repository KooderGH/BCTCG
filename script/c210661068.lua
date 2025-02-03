--Judgement
--Scripted by poka-poka
--Effect :
--(1) This card gains ATK and DEF equal to the ATK and DEF of all monsters attached to this card.
--(2) During each end phase: Target 1 card in your opponent's GY; Attach it to this card.
--(3) This card gains these effects based on the number of materials with different names attach to it.
-- *2+ Once per turn (Ignition): You can detach one card and target one card with the same name of the deatched card you have in the GY; Add the targeted card to your hand.
-- *3+ Cannot be destroyed by battle
-- *8+ (Quick Effect): You can detach 5 materials from this card; Destroy all cards on the field except this card.
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    Xyz.AddProcedure(c,s.xyzfilter,nil,2,nil,0,2,nil,true,s.xyzcheck)
	-- Effect 1: Gain ATK and DEF equal to the ATK and DEF of all attached materials
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetValue(s.defval)
    c:RegisterEffect(e2)
	--attach
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.mttg)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
	-- Effect: Detach 1 material, then add a card with the same name from GY to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
	--cannot be destroyed by battle
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	-- destroy all card on the field except this Card
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1,{id,1})
	e6:SetCondition(s.descon)
	e6:SetCost(aux.dxmcostgen(5,5,nil))
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6,false,REGISTER_FLAG_DETACH_XMAT)
end
function s.xyzfilter(c)
    return c:IsCode(210660485) or c:IsCode(210660530)
end
function s.xyzcheck(g,tp,xyz)
    return g:GetClassCount(Card.GetCode) == 2 and g:IsExists(Card.IsCode,1,nil,210660485) and g:IsExists(Card.IsCode,1,nil,210660530)
end
-- Calculate total ATK of attached Xyz materials
function s.atkval(e,c)
    local g=c:GetOverlayGroup()
    local atk=0
    for tc in aux.Next(g) do
        atk=atk+tc:GetAttack()
    end
    return atk
end

-- Calculate total DEF of attached Xyz materials
function s.defval(e,c)
    local g=c:GetOverlayGroup()
    local def=0
    for tc in aux.Next(g) do
        def=def+tc:GetDefense()
    end
    return def
end
-- Target 1 card in the opponent's GY
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
end

-- Attach the targeted card as material
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end

-- add card with same name as detached
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) and e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and e:GetLabel()==1 then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--to hand
function s.thcon(e)
	return e:GetHandler():GetOverlayCount()>=2
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(s.thfilter,nil,tp)
	if chk==0 then return #g>0 end 
	-- Select 1 valid material to detach
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc then
		e:SetLabel(tc:GetCode()) 
		Duel.SendtoGrave(tc,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

-- Filter: Check if a material has a matching card in the GY
function s.thfilter(c,tp)
	return Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
-- Filter: Check for a card with the same Code in the GY
function s.gyfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end

-- Operation: Add the selected card to hand
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if code == 0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.gyfilter,tp,LOCATION_GRAVE,0,1,1,nil,code)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--cannot be destroyed by battle
function s.indcon(e)
	return e:GetHandler():GetOverlayCount()>=3
end

--destroy all other
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>=8
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) 
    end
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
    Duel.Destroy(g,REASON_EFFECT)
	end