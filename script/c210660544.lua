--Kyosaka Nanaho
--Scripted by Gideon
-- (1) Cannot be Normal Summoned Set. Must be Special Summoned by its own effect and cannot be Special Summoned by other ways. This card Summon cannot be negated. You can Special Summon this card from your hand by discarding 2 card's from your hand while controlling no monsters. Then move this card to your Extra Monster Zone. 
-- (2) Cannot be returned to hand, banished, or tributed.
-- (3) Cannot be targeted by card effects. This effect cannot be negated.
-- (4) When this card is Special Summoned: Look at your opponent's hand; Banish 1 card from their hand and all cards with that same name from their hand/deck face-down.
-- (5) Once while this card is face-up on the field: If it would be destroyed; gain 1000 ATK instead.
-- (6) This card can attack your opponents monsters once each.
-- (7) If this card is in your GY: You can banish 3 cards from top of your deck facedown; Add this card to your hand.
local s,id=GetID()
function s.initial_effect(c)
	--(1)Start
	--Makes it unsummonable via normal
	c:EnableUnsummonable()
	--Cannot be SS by other ways other then it's own effect via above and this function
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--SS from Hand / GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.ssummoncon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Move to EMZ
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(s.mvop)
    c:RegisterEffect(e2)
	--Summon cannot be disabled (Hopefully)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--(1)Finish
	--(2)Start
	--Cannot be Tributed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--Cannot be returned to hand
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	--Cannot banish
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e7)
	--(2)Finish
	--(3)Start
	--Cannot be targeted (self)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--(3)Finish
	--(4)Start
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetTarget(s.handtg)
	e9:SetOperation(s.handop)
	c:RegisterEffect(e9)
end
--(1)
function s.ssummoncon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0,c)
        and Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
        and (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_DISCARD,nil,nil,true)
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
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
	g:DeleteGroup()
end
--Move to extra
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tp=c:GetControler()
    if (Duel.CheckLocation(tp,LOCATION_EMZONE,0) or Duel.CheckLocation(tp,LOCATION_EMZONE,1)) then
        local lftezm=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,5) and 0x20 or 0
        local rgtemz=not Duel.IsExistingMatchingCard(Card.IsSequence,tp,LOCATION_MZONE,0,1,nil,6) and 0x40 or 0
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
        local selected=Duel.SelectFieldZone(tp,1,LOCATION_MZONE,0,~ZONES_EMZ|(lftezm|rgtemz))
        selected=selected==0x20 and 5 or 6
        Duel.MoveSequence(c,selected)
    end
end
--4