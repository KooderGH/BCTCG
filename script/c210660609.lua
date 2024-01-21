--Dark Aegis Garu
--Scripted by " "
--Effect
-- (1) When you take damage from a card in your opponent's possession: You can Special Summon this card from your hand.
-- (2) When this card is Special Summoned by its effect: Activate the appropriate effect based on the type of damage:
-- * Battle damage: Destroy all monster's your opponent controls. You cannot attack the turn you use this effect.
-- * Effect damage: Inflict damage to your opponent equal to double the damage you took. This card gains ATK equal to the damage you inflicted to your opponent this way.
-- (3) Other monsters you control cannot attack.
-- (4) During each end phase: This card gains 1000 ATK.
-- (5) If this card ATK is 8000 or higher: This card can attack directly.
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)


end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and tp~=rp
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sumtype=1
	if (r&REASON_BATTLE)~=0 then sumtype=2 end
	if Duel.SpecialSummon(c,sumtype,tp,tp,false,false,POS_FACEUP)~=0 then
		e:SetLabel(ev)
	end
end