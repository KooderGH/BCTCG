-- Koronium
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --When Normal Summoned (Search Ability)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,0))
    e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e0:SetCode(EVENT_SUMMON_SUCCESS)
    e0:SetTarget(s.srtg)
    e0:SetOperation(s.srop)
    c:RegisterEffect(e0)
    local e1=e0:Clone()
    e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e1)
    --Metal Mechanic
    local e2=Effect.CreateEffect(c)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.desatktg)
    c:RegisterEffect(e2)
    --self destroy
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_SELF_DESTROY)
    e3:SetCondition(s.sdcon)
    c:RegisterEffect(e3)
    --Wave on Battle
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_DISABLE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_ATTACK_ANNOUNCE)
    e4:SetCondition(s.wavecon)
    e4:SetTarget(s.wavetg)
    e4:SetOperation(s.waveop)
    c:RegisterEffect(e4)
end
--When NS add function
function s.dfilter(c)
    return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK,0,2,2,nil)
    if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
    end
end
--Metal Ability Function
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsFaceup() end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(-50)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
        c:RegisterEffect(e1)
    return true
end
function s.sdcon(e)
    local c=e:GetHandler()
    return c:GetDefense()<=0
end
--Wave on Battle Function
function s.wavecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
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
    Duel.NegateAttack()
    if tc then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
