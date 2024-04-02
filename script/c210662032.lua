-- R. Ost
--Scripted By Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Critical Ability
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(s.crittg)
    e1:SetOperation(s.critop)
    c:RegisterEffect(e1)
end
--Critical Ability Function
function s.crittg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_MACHINE) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function s.critop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
        Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
    end
end