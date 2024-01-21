--Benevolent Souma
--Scripted by Konstak.
--Effect:
-- (1) While this card is on the field: Your opponents monsters lose 200 ATK/DEF for each level they have.
-- (2) After damage calculation, when this card battles an opponent's monster: You can banish that monster, also banish this card.
local s,id=GetID()
function s.initial_effect(c)
    --opps monsters lose 200 ATK/DEF (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(s.adval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --when this card battles an opponent's monster: You can banish that monster (2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLED)
    e3:SetTarget(s.bntg)
    e3:SetOperation(s.bnop)
    c:RegisterEffect(e3)
end
--(1)
function s.adval(e,c)
    return c:GetLevel()*-200
end
--(2)
function s.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local t=Duel.GetAttackTarget()
    if chk==0 then
        return (t==c and a:IsAbleToRemove())
            or (a==c and t~=nil and t:IsAbleToRemove())
    end
    local g=Group.CreateGroup()
    if a:IsRelateToBattle() then g:AddCard(a) end
    if t~=nil and t:IsRelateToBattle() then g:AddCard(t) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    local g=Group.FromCards(a,d)
    local rg=g:Filter(Card.IsRelateToBattle,nil)
    Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
