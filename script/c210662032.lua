-- R. Ost
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
    --Critical Ability
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetTarget(s.crittg)
    e3:SetOperation(s.critop)
    c:RegisterEffect(e3)
end
--Traitless Ability Function
function s.stval(e,c)
    local tp=c:GetControler()
    local v=Duel.GetLP(tp)
    if v>=10000 then return 500 end
    if v>=7000 and v<10000 then return 400 end
    if v>=4000 and v<7000 then return 300 end
    if v>=2000 and v<4000 then return 200 end
    if v>=0 and v<2000 then return 100 end
end
--Critical Ability Function
function s.crittg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_MACHINE) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function s.critop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() and Duel.TossCoin(tp,1)==COIN_HEADS then
        Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
    end
end