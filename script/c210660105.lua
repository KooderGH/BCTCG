--Kuu
--Scripted By Gideon
-- (1) While this card is on the field: For each Spellcaster you control except "Kuu", this card gains 1 level.
-- (2) If this card is Tributed while Level 7 or higher: Target 1 monster your opponent controls; Destroy it and gain LP equal to that monster's ATK and DEF total.
-- (3) You can target 1 monster you control (Ignition); Raise that monster's level by 3.
-- (4) You can activate this effect; Until your next standby phase: This card gains 300 ATK/DEF for each level it has.
-- (5) You can only use each activated effect of "Kuu" once per turn and used only once while it is face-up on the field.
-- (6) You can only control 1 Kuu
local s,id=GetID()
function s.initial_effect(c)
	--Can only control one
	c:SetUniqueOnField(1,0,id)
	--(1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	--(2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.relcon)
	e2:SetTarget(s.reltg)
	e2:SetOperation(s.relop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--(3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.lvtarget)
	e3:SetOperation(s.lvopp)
	c:RegisterEffect(e3)
	--(4)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,2})
    e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
end
--e1
function s.val(e,c)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsRace,RACE_SPELLCASTER),c:GetControler(),LOCATION_MZONE,0,c)*1
end
--e2
function s.relcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetPreviousLevelOnField()>=7
end
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	local def=g:GetFirst():GetDefense()
	local lpgain=atk+def
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,lpgain)
end
function s.relop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local lpgain=atk+def
        Duel.Destroy(tc,REASON_EFFECT)
		Duel.Recover(tp,lpgain,REASON_EFFECT)
	end
end
--e3
function s.lvfilter(c)
	return c:IsFaceup()
end
function s.lvtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.lvopp(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(3)
		tc:RegisterEffect(e1)
	end
end
--e4
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.value)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
end
function s.value(e,c)
	return c:GetLevel()*300
end