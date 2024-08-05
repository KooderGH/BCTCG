-- Crabelinian
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --during damage calculation FIRE lose half of their ATK/DEF (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(s.atktg)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)
    --Pay 150 LP based on how many you control
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetOperation(s.lpop)
    c:RegisterEffect(e2)
end
--e1
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and (bc:IsAttribute(ATTRIBUTE_FIRE)) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=e:GetHandler():GetBattleTarget()
    if c:IsRelateToBattle() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-bc:GetAttack()/2)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        bc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(-bc:GetDefense()/2)
        e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        bc:RegisterEffect(e2)
    end
end
--e2
function s.crabfilter(c)
    return c:IsFaceup() and (c:IsCode(210662173) or c:IsCode(210662606) or c:IsCode(210662910) or c:IsCode(210662911) or c:IsCode(210662912) or c:IsCode(210662913) or c:IsCode(210662914) or c:IsCode(210662915) or c:IsCode(210662916) or c:IsCode(210662917) or c:IsCode(210662918) or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA)))
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d = Duel.GetMatchingGroupCount(s.crabfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*250
    if e:GetHandler():IsRelateToEffect(e) and d then
        Duel.Recover(tp,d,REASON_EFFECT)
    end
end