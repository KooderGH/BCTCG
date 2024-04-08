-- Gideon de Sable
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Guaranteed Wave
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(s.wavetg)
    e1:SetOperation(s.waveop)
    c:RegisterEffect(e1)
end
function s.wavetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.waveop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local d1=6
	while d1>3 do
		d1=Duel.TossDice(tp,1)
	end
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,d1)
	if tc then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
