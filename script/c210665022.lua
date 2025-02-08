--Zombie Reborn!?
--Scripted by poka-poka
--Effect :
--(1) Once per turn (Ignition): You can Roll a six-sided die and apply the following based on its result:
-- 1-2: Target 1 monster on the field; It now becomes a DARK zombie monster.
-- 3-4: Target 1 monster in your GY; Special Summon it. It is now treated as a zombie monster while on the field.
-- 5-6: Target 1 monster in your opponent's GY; Special Summon it on your side of the field. It is now treated as a zombie monster.
--(2) If this card would be destroyed, you can destroy 1 zombie monster you control instead.
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    -- (1) Roll a six-sided die and apply effect
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,id)
    e2:SetTarget(s.dicetg)
    e2:SetOperation(s.diceop)
    c:RegisterEffect(e2)
    -- (2) Destroy a Zombie instead of this card
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTarget(s.reptg)
    e3:SetOperation(s.repop)
    c:RegisterEffect(e3)
end

-- (1) Roll a die and apply an effect
function s.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.diceop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.TossDice(tp,1)
    if d<=2 then

        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.HintSelection(g)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
            e1:SetValue(ATTRIBUTE_DARK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)

            local e2=e1:Clone()
            e2:SetCode(EFFECT_CHANGE_RACE)
            e2:SetValue(RACE_ZOMBIE)
            tc:RegisterEffect(e2)
        end

    elseif d<=4 then
        -- 3-4: Special Summon 1 monster from your GY as a Zombie
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_RACE)
            e1:SetValue(RACE_ZOMBIE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end

    else
        -- 5-6: Special Summon 1 monster from opponent's GY as a Zombie
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_RACE)
            e1:SetValue(RACE_ZOMBIE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
    end
end
-- (2) Destroy replace
function s.repfilter(c)
    return c:IsRace(RACE_ZOMBIE) and c:IsReleasable()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_MZONE,0,1,nil) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Release(g,REASON_EFFECT+REASON_REPLACE)
end