--Santa Kuu
--Scripted by Konstak. Help from Gideon
--Effect
--You can Special Summon this card (from your hand) to your opponent's field in Defense Position, by Tributing 1 monster they control. 
--If Summoned this way, once, during the End Phase of this turn: Both players draw 1 card. (mandatory)
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	aux.AddLavaProcedure(c,1,POS_FACEUP_DEFENSE,nil,1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
end
function s.ctcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-(RESET_LEAVE+RESET_TEMP_REMOVE+RESET_TURN_SET)+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
