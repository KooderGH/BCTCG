--Ganglions unholy exchange
--Scripted By poka-poka
--Effect: Target 2 monster's your opponent controls; This turn, if you would Tribute Summon a FIRE Dragon monster, you must Tribute those target's, as if you controlled them. You cannot Special Summon the turn you activate this card.
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
-- Filter function to check for monsters that can be targeted
function s.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
-- Cost: You cannot Special Summon the turn you activate this card
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetTargetRange(1,0)
    Duel.RegisterEffect(e2,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,2,2,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if #tg~=2 then return end
    local tc1=tg:GetFirst()
    local tc2=tg:GetNext()
    for _,tc in ipairs({tc1, tc2}) do
        -- Effect 1: Allow the targeted monster to be used as your Tribute
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_RELEASE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        -- Effect 2: Restrict the targeted monster to only be tributable for FIRE Dragon monsters
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UNRELEASABLE_SUM)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
        e2:SetValue(function(e,c)
            return not (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE))
        end)
        e2:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end