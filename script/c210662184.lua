-- Mistress Celeboodle
local s,id=GetID()
function s.initial_effect(c)
    --Strong Against
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(s.strongtg)
    e1:SetOperation(s.strongop)
    c:RegisterEffect(e1)
    --Strengthen
    local e2=Effect.CreateEffect(c)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.strengthentg)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_DRAW)	
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
end
--Strong function
function s.strongtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and (bc:IsAttribute(ATTRIBUTE_FIRE)) end
end
function s.strongop(e,tp,eg,ep,ev,re,r,rp)
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
--Strengthen function
function s.strengthentg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE)
    c:RegisterEffect(e1)
    return true
end
--Draw Function
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsPlayerCanDraw(1-tp,1) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetCode(EVENT_PHASE+PHASE_DRAW)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        e1:SetCountLimit(1)
        e1:SetOperation(s.drawop)
        c:RegisterEffect(e1)
    end
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end