--Holy Coppermine
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    -- Effect 1: Twice per turn (Quick), negate attack
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(2)
    e1:SetCondition(s.atkcon)
    e1:SetTarget(s.atktg)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)
    -- Effect 2: Once per turn (Ignition): Add Spellcaster from GY to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2) 
    -- Effect 3: During each End Phase: Gain 400 LP for each card in both hands
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.rectg)
    e3:SetOperation(s.recop)
    c:RegisterEffect(e3)
    -- Effect 4: Once per turn (Ignition): Control 3 "Coppermine", destroy opponent's cards
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(s.descon)
    e4:SetTarget(s.destg)
    e4:SetOperation(s.desop)
    c:RegisterEffect(e4)
end

-- e1 Negate attack
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker()~=nil and Duel.GetAttacker():IsControler(1-tp) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(Duel.GetAttacker())
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.NegateAttack()
    end
end
-- e2 Add Spellcaster from GY to hand
function s.thfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
-- e3 Gain LP during End Phase
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ct*400)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*400)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,LOCATION_HAND)
    Duel.Recover(p,ct*400,REASON_EFFECT)
end
-- e4 Destroy all cards opponent controls and in their hand
function s.copperminefilter(c)
    return c:IsCode(210660107) and c:IsFaceup()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.copperminefilter,tp,LOCATION_MZONE,0,nil)
    return g:GetClassCount(Card.GetRace)>=3
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.Destroy(g,REASON_EFFECT)
end
