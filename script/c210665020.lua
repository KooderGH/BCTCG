--Awaken Thy Cat!
--Scripted by Kooder
--Effects:
-- This card is used to Ritual Summon any "Awakened" Ritual Monster from your hand or GY in face-up Attack Position or face-down Defense Position. You must also Tribute monsters from your hand or field, whose total levels equal or exceed the level of the Ritual Monster you Ritual Summon
-- During your standby phase, you can banish 4 cards from your GY; Add this card to your hand and if you do, you cannot summon "Wonder MOMOCO" the turn you activate this effect
-- You can only activate "Awaken Thy Cat!" once per turn.
local s,id=GetID()
function s.initial_effect(c)
--ritual summon
	local e1=Ritual.AddProcGreater({handler=c,filter=s.awakenedfilter,lvtype=RITPROC_GREATER,sumpos=POS_FACEUP_ATTACK|POS_FACEDOWN_DEFENSE,location=LOCATION_HAND|LOCATION_GRAVE})
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
--standby phase, banish 4 cards then add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.condition)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.awakenedfilter(c)
	return c:IsCode(210661025) or c:IsCode(210661130) or c:IsCode(210661268) or c:IsCode(210661323) or c:IsCode(210661613)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.thfilter(c)
	return not c:IsCode(210665020)
end
function s.mmfilter(e,c,sump,sumtype,sumpos,targetp,se)
		return c:IsCode(210660455)
	end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
--cannot summon Wonder MOMOCO
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE|PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.mmfilter)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,1),nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end