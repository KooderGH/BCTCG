-- Shibalien Elite
local s,id=GetID()
function s.initial_effect(c)
    --warp mechanic
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.warptg)
	e1:SetOperation(s.warpop)
	c:RegisterEffect(e1)
end
function s.warpfilter(c)
	return c:IsAbleToRemove() and c:IsMonster() and not c:IsCode(id)
end
function s.warptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.warpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.warpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,1)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()~=e:GetLabel() and tp==Duel.GetTurnPlayer() then
		Duel.Hint(HINT_CARD,0,id)
		Duel.ReturnToField(e:GetLabelObject())
	end
end
