--The 12th Angel
--Scripted by Kooder
--Effects:
-- If you control 2 or more Evangelion banner monsters, you can Special summon this card from your hand.
-- Once per turn (ignition), if you control 4 or more Evangelion banner monsters, you can activate this effect; Tribute this card, then, Special summon 1 mosnter from your deck ignoring it's summoning conditions.
-- This card gains 200 ATK/DEF for each card in your opponent's deck.
local s,id=GetID()
function s.initial_effect(c)
--if 2 or more eva, special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(2)
	e1:SetCondition(s.evacount)
	c:RegisterEffect(e1)
--if 4 or more eva, tribute this card then special summon 1 monster ignoring its condition
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(Cost.SelfTribute)
	e2:SetLabel(4)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	e2:SetCondition(s.evacount)
	c:RegisterEffect(e2)
--gains 200 for each card in opponent's deck
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(s.stat)
    c:RegisterEffect(e3)
	local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
end
--eva count
function s.evafilter(c)
	return c:IsFaceup() and c:IsCode(210660416) or c:IsCode(210660547) or c:IsCode(210660710) or c:IsCode(210660413) or c:IsCode(210660487) or c:IsCode(210660709) or c:IsCode(210660414) or c:IsCode(210660488) or c:IsCode(210660550) or c:IsCode(210660551) or c:IsCode(210660548) or c:IsCode(210660412) or c:IsCode(210660549) or c:IsCode(210660415) or c:IsCode(210663011)
end
function s.evacount(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.evafilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--special summon ignoring condition
function s.monsterfilter(c)
	return c:IsMonster()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(s.monsterfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.monsterfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
--200 atk and def for each card in deck
function s.stat(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_DECK)*200
end