--Learned To Love
--Scripted by poka-poka
-- Effect: 	(1) Once per Chain, when your opponent activates a card or effect: Inflict 300 damage to them.
--			(2) During the End Phase, if you control no monsters: Banish this card, then you can Special Summon 1 monster from your hand or GY.
--			(3) You can only control 1 "Learned to Love"

local s,id=GetID()
function s.initial_effect(c)
    -- (3) Can only control 1 "Learned to Love"
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    -- (1) Inflict 300 damage when opponent activates a card or effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(s.dmgcon)
    e2:SetOperation(s.dmgop)
    c:RegisterEffect(e2)
    -- (2) Banish this card and Special Summon a monster if no monsters are controlled
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(s.spcon)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end
-- (1) Inflict 300 damage when opponent activates a card or effect (Once per Chain)
function s.dmgcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.GetFlagEffect(tp,id)==0 -- Opponent activates effect & flag not set
end
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1) -- Prevent multiple activations in the same chain
    Duel.Damage(1-tp,300,REASON_EFFECT)
end
-- (2) Banish and Special Summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_HAND|LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
