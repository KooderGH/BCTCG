-- Kory
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Traitless Ability
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.stval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --Wave on Battle
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,3))
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCondition(s.wavecon)
    e3:SetTarget(s.wavetg)
    e3:SetOperation(s.waveop)
    c:RegisterEffect(e3)
end
--Traitless Ability Function
function s.stval(e,c)
    local tp=c:GetControler()
    local v=Duel.GetLP(tp)
    if v>=10000 then return 500 end
    if v>=7000 and v<10000 then return 300 end
    if v>=4000 and v<7000 then return 300 end
    if v>=2000 and v<4000 then return 200 end
    if v>=0 and v<2000 then return 100 end
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