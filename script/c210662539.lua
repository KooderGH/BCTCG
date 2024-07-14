-- Choco Wall Doge
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be destroyed by battle
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Wave on Battle
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,3))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCondition(s.wavecon)
    e2:SetTarget(s.wavetg)
    e2:SetOperation(s.waveop)
    c:RegisterEffect(e2)
    --Damage Control
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetOperation(s.dcop)
    c:RegisterEffect(e3)
    --This card's Position cannot be changed.
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SET_POSITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(POS_FACEUP_ATTACK)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e4)
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
--Damage Control effect
function s.dcop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end