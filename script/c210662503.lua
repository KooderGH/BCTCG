-- Miku Doge
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --Slow Ability
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetTarget(s.dodgetg)
    e2:SetOperation(s.dodgeop)
    c:RegisterEffect(e2)
end
s.listed_names={210662899}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,210662899,0,TYPES_TOKEN,0,1500,4,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(1-tp,210662899,0,TYPES_TOKEN,0,1500,4,RACE_WARRIOR,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) then
		local token=Duel.CreateToken(tp,210662899)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
--Dodge Ability Function
function s.dodgetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.dodgeop(e,tp,eg,ep,ev,re,r,rp)
    local d1=Duel.TossDice(tp,1)
    if d1<=4 then
        Duel.NegateAttack()
    end
end