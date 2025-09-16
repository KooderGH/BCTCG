--Donald Morden
--Scripted by Konstak
--Effect
--(1) Cannot be Normal Summoned or Set.
--(2) Must be Special Summoned by "Hi-Do", and cannot be Special Summoned by other ways.
--(3) Cannot be destroyed by battle.
--(4) Card's on the field cannot return to hand while this card is on the field.
--(5) You take no battle damage from battles involving this card. This effect cannot be negated.
--(6) At the end of the Damage Step, if this card battled an opponent's monster: Destroy that monster, then draw 1 card.
--(7) During your End Phase; Destroy all other monsters on the field.
--(8) During your opponent's End Phase; Your opponent draws 1 card.
--(9) If this face-up card leaves the field; Special Summon 1 "Sol Dae Rokker" from your Hand, Deck, or GY
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be Normal Summoned/Set (1)
    c:EnableUnsummonable()
    --Must be Special Summoned by Hi-Do (2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(s.splimit)
    c:RegisterEffect(e1)
    --Cannot be destroyed by battle (3)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Cards cannot return to hand (4)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TO_HAND)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    c:RegisterEffect(e3)
    --No battle damage (5)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e4:SetValue(1)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e4)
    --Destroy monster after battle and draw (6)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DAMAGE_STEP_END)
    e5:SetCondition(s.descon2)
    e5:SetTarget(s.destg)
    e5:SetOperation(s.desop)
    c:RegisterEffect(e5)
    --Destroy all other monsters during End Phase (7)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(s.descon)
    e6:SetTarget(s.desalltg)
    e6:SetOperation(s.desallop)
    c:RegisterEffect(e6)
    --Opponent draws during their End Phase (8)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,2))
    e7:SetCategory(CATEGORY_DRAW)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_PHASE+PHASE_END)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(s.drcon)
    e7:SetTarget(s.drtg)
    e7:SetOperation(s.drop)
    c:RegisterEffect(e7)
    --Special Summon Sol Dae Rokker when leaving field (9)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,3))
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetCondition(s.spcon)
    e8:SetTarget(s.sptg)
    e8:SetOperation(s.spop)
    c:RegisterEffect(e8)
end
--Functions for effect 2 (Summon condition)
function s.splimit(e,se,sp,st)
    return se:GetHandler():IsCode(210660225)
end
--Functions for effect 6 (Destroy after battle and draw)
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsRelateToBattle() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc and bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
--Functions for effect 7 (Destroy all other monsters)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.desalltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desallop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    Duel.Destroy(g,REASON_EFFECT)
end
--Functions for effect 8 (Opponent draws)
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
--Functions for effect 9 (Special Summon Sol Dae Rokker)
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function s.spfilter(c,e,tp)
    return c:IsCode(210660727) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
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