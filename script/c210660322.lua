--Sarukani
--Scripted by Konstak.
--Effect
-- (1) If you control a monster that is not a WIND Attribute monster, destroy this card.
-- (2) If you control 2 or more WIND monsters, you can tribure 1 WIND monster to Special Summon this card from your hand.
-- (3) During the damage step, if this card battles a Fairy or Zombie monster, this card gains 2900 ATK until the end of the damage step.
-- (4) You can only use 1 of these effects of "Sarukani" per turn, and only once that turn.
-- * If this card is in your GY: You can banish 1 WIND monster from your GY to add this card to your hand.
-- * If this card is sent to the GY: You can tribute 1 WIND monster on your side of the field; Special Summon this card but it cannot attack this turn.
local s,id=GetID()
function s.initial_effect(c)
    --self destroy (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SELF_DESTROY)
    e1:SetCondition(s.sdcon)
    c:RegisterEffect(e1)
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
    --during damage calculation
    --
	--SS from hand or GY
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.sscon)
	e4:SetTarget(s.sstg)
	e4:SetOperation(s.ssop)
	c:RegisterEffect(e4)
    --if this card is sent to the GY
end
--Self Destroy Function
function s.sdfilter(c)
    return c:IsMonster() and c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function s.sdcon(e)
    return Duel.IsExistingMatchingCard(s.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
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
--Special summon card from GY
function s.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsMonster() and c:IsAttribute(ATTRIBUTE_WIND) and aux.SpElimFilter(c,true,true)
end
function s.sscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_GRAVE,0,c)
	return aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_GRAVE,0,c)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end