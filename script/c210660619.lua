--Lilin
--Scripted By Gideon
-- (1) This card gains 500 ATK/DEF for each Level 5 or higher LIGHT Spellcaster on the field.
-- (2) When this card is Tribute Summoned; Add 3 level's to all monster's you control.
-- (3) When this card is Tributed; Destroy all monster's your opponent control. You cannot attack the turn you use this effect.
-- (4) You can Tribute 1 LIGHT Spellcaster you control except "Lilin"; Add up to 2 Level 4 or lower Spellcaster's from your deck to your hand.
-- (5) You can only use each effect of "Lilin" once per turn and used only once while it is face-up on the field.
-- (6) Has piercing battle damage.
local s,id=GetID()
function s.initial_effect(c)
    --500 ATK/DEF for each Level 5 or higher LIGHT Spellcaster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --When tribute Summoned; Add levels
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    --When tributed, destroy all monsters opponent controls
end
--e1
function s.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(5) and c:IsRace(RACE_SPELLCASTER)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.cfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*500
end