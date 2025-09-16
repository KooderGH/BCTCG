-- Ackey
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Shield Mechanic
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.desatktg)
    c:RegisterEffect(e1)
    --Can attack directly
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e2)
    --Freeze Ability
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCondition(s.freezecon)
    e3:SetOperation(s.freezeop)
    c:RegisterEffect(e3)
end
--Shield Mechanic
function s.desatktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and c:IsFaceup() end
    return true
end
--Freeze Function
function s.freezecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle() and Duel.GetTurnPlayer()==tp
end
function s.freezeop(e,tp,eg,ep,ev,re,r,rp)
    local effp=e:GetHandler():GetControler()
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.TossCoin(tp,1)==COIN_HEADS then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_SKIP_DP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        if Duel.GetTurnPlayer()==effp then
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetCondition(s.skipcon)
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
        else
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
        end
        Duel.RegisterEffect(e1,effp)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetCategory(CATEGORY_DRAW)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetCondition(s.retcon)
        e2:SetLabel(Duel.GetTurnCount())
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        e2:SetCountLimit(1)
        e2:SetOperation(s.droperation)
        Duel.RegisterEffect(e2,effp)
        Duel.NegateAttack()
    end
end
function s.skipcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end