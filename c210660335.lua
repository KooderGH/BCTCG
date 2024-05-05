--Sea Maiden Ruri
--Scripted by senorpizza
--Effect:
--(1) During your opponent's turn (Quick Effect): You can Tribute this card from your hand or face-up field; neither player can banish cards for the rest of this turn.

local s,id=GetID()
function s.initial_effect(c)
	--During your opponent's turn (Quick Effect): You can Tribute this card from your hand or face-up field; neither player can banish cards for the rest of this turn.
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(s.rmcon)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.rmcost)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetFlagEffect(0,id)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--30459350 chk
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(30459350)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,1,aux.Stringid(id,2),nil)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
end