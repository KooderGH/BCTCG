--Li'l Valkyrie
--Scripted by Gideon
-- (1) Cannot be Normal Summoned/Set. Must be Special Summoned (from your hand) by having 3 or more LIGHT monsters with different names in your GY while controlling  no monsters.
-- (2) Unaffected by Spell/Trap effects and by activated effects effects from any monster whose original Level/Rank is lower then this card's current Level.
-- (3) All Special Summon monsters your opponent controls lose 800 ATK/DEF
-- (4) Once per turn (Quick): You can make your opponent send 1 monster from their hand or their side of the field to the banish zone (their choice).
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Special summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
	--Unaffected by cards' effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--SS opp loses 800 atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(s.adtg)
	e4:SetValue(-800)
	c:RegisterEffect(e4)
	--Make the opponent send 1 monster to the GY
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.tgtg)
	e5:SetOperation(s.tgop)
	c:RegisterEffect(e5)
end
--e2
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetClassCount(Card.GetCode)==#sg,sg:GetClassCount(Card.GetCode)~=#sg and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0
end
function s.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil)
	return aux.SelectUnselectGroup(rg,e,tp,3,3,s.rescon,0) 
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
			and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--e3
function s.efilter(e,te)
	if te:IsSpellTrapEffect() then
		return true
	else
		return aux.qlifilter(e,te)
	end
end
--e4
function s.adtg(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
--e5
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE|LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE|LOCATION_HAND)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsMonster,1-tp,LOCATION_MZONE|LOCATION_HAND,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,REASON_RULE,PLAYER_NONE,1-tp)
	end
end