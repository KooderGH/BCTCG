--Kalisa
--Scripted By Gideon
-- (1) You can Normal Summon/Set this card without Tributing, but its original ATK and DEF becomes halved.
-- (2) If this card was Tribute Summoned by using 2 LIGHT Spellcasters: You can target up to 3 cards your opponent controls; Destroy those targets.
-- (3) When this card destroys an opponent's monster by battle and sends it to the GY: You can Tribute this card; Special Summon 1 LIGHT Spellcaster from you hand, deck, or GY, then raise it's level by 4.
-- (4) If this card is Tributed; You can Special Summon 1 LIGHT Spellcaster from your hand, then raise it's level by 4.
-- (5) You can only use each effect of "Kalisa" once per turn and used only once while it is face-up on the field.
-- (6) This card can be treated as 2 Tributes for the Tribute Summon of a LIGHT monster.
local s,id=GetID()
function s.initial_effect(c)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	e1:SetOperation(s.ntop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetBaseAttack()/2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(c:GetBaseDefense()/2)
	c:RegisterEffect(e2)
end