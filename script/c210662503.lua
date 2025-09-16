-- Miku Doge
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Dodge Ability
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(s.dodgetg)
    e1:SetOperation(s.dodgeop)
    c:RegisterEffect(e1)
end
--Dodge Ability Function
function s.dodgetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.dodgeop(e,tp,eg,ep,ev,re,r,rp)
    local d1=Duel.TossDice(tp,1)
    if d1<=4 then
        Duel.NegateAttack()
    end
end