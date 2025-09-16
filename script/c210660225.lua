--Hi-Do
--Scripted by Konstak
--Effect
--(1) Cannot be destroyed by battle.
--(2) You take no battle damage from battles involving this card.
--(3) Before damage calculation, if this face-up card is targeted for an attack: Inflict damage to your opponent equal to that attacking monster's ATK.
--(4) Once per turn, during your End Phase: Tribute 1 other monster or destroy this card.
--(5) When this card is destroyed, except by its own effect: Special Summon 1 "Donald-Morden" from your Hand, Deck, or GY
--(6) If you have no monster's in your GY, you can Special Summon this card from your hand.
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be destroyed by battle (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --No battle damage (2)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Inflict damage when attacked (3)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetTarget(s.damtg)
    e3:SetOperation(s.damop)
    c:RegisterEffect(e3)
    --Tribute or destroy (4)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_RELEASE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(s.descon)
    e4:SetTarget(s.destg)
    e4:SetOperation(s.desop)
    c:RegisterEffect(e4)
    --Special Summon Donald-Morden when destroyed (5)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(s.spcon)
    e5:SetTarget(s.sptg)
    e5:SetOperation(s.spop)
    c:RegisterEffect(e5)
    --Special Summon from hand if no monsters in GY (6)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,3))
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_SPSUMMON_PROC)
    e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e6:SetRange(LOCATION_HAND)
    e6:SetCondition(s.hspcon)
    c:RegisterEffect(e6)
end
--Functions for effect 3 (Inflict damage)
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local atk=Duel.GetAttacker():GetAttack()
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(atk)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
--Functions for effect 4 (Tribute or destroy)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,e:GetHandler()) then
        Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
    else
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end

    local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,c)
    if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local sg=g:Select(tp,1,1,nil)
        Duel.Release(sg,REASON_EFFECT)
    else
        Duel.Destroy(c,REASON_EFFECT)
    end
end
--Functions for effect 5 (Special Summon Donald-Morden)
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_DESTROY) and not (re and re:GetHandler()==c)
end
function s.spfilter(c,e,tp)
    return c:IsCode(210660224) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end
--Functions for effect 6 (Special Summon from hand)
function s.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
           (Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 or
           not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER))
end