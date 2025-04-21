--Sol Dae Rokker
--Scripted by Konstak
--Effect
--(1) Cannot be Normal Summoned or Set.
--(2) Must be Special Summoned by "Donald Morden", and cannot be Special Summoned by other ways.
--(3) Cannot be destroyed by battle or card effect, also you take no battle damage from battles involving this card.
--(4) At the end of the Damage Step, if this card battled an opponent's monster: Inflict damage to your opponent equal to that opponent's monster's ATK, gain LP equal to that monster's DEF, and if you do, banish that monster.
--(5) During your End Phase: Draw 1 card.
--(6) During your opponent's standby phase: Target 1 monster in their GY; Special Summon it in face-up Attack Position on your opponent's side of the field.
--(7) Once per turn (Ignition): If the difference between both player's LP is 9000 or more: Inflict 4000 damage to your opponent.
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be Normal Summoned/Set (1)
    c:EnableUnsummonable()
    --Must be Special Summoned by Donald Morden (2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(s.splimit)
    c:RegisterEffect(e1)
    --Cannot be destroyed by battle or card effects (3)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e3)
    --No battle damage (3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --Battle effect: damage, gain LP, banish (4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,0))
    e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_DAMAGE_STEP_END)
    e5:SetCondition(s.damcon)
    e5:SetTarget(s.damtg)
    e5:SetOperation(s.damop)
    c:RegisterEffect(e5)
    --Draw during End Phase (5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,1))
    e6:SetCategory(CATEGORY_DRAW)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(s.drcon)
    e6:SetTarget(s.drtg)
    e6:SetOperation(s.drop)
    c:RegisterEffect(e6)
    --Special Summon during opponent's Standby Phase (6)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,2))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(s.spcon)
    e7:SetTarget(s.sptg)
    e7:SetOperation(s.spop)
    c:RegisterEffect(e7)
    --Inflict 4000 damage if LP difference is 9000+ (7)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,3))
    e8:SetCategory(CATEGORY_DAMAGE)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)
    e8:SetCondition(s.dmgcon)
    e8:SetTarget(s.dmgtg)
    e8:SetOperation(s.dmgop)
    c:RegisterEffect(e8)
end
--Functions for effect 2 (Summon condition)
function s.splimit(e,se,sp,st)
    return se:GetHandler():IsCode(210660224)
end
--Functions for effect 4 (Battle effect)
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsControler(1-tp)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc end
    local atk=bc:GetAttack()
    local def=bc:GetDefense()
    Duel.SetTargetCard(bc)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,def)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local bc=Duel.GetFirstTarget()
    if bc and bc:IsRelateToEffect(e) then
        local atk=bc:GetAttack()
        local def=bc:GetDefense()
        if Duel.Damage(1-tp,atk,REASON_EFFECT)>0 and Duel.Recover(tp,def,REASON_EFFECT)>0 then
            Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
        end
    end
end
--Functions for effect 5 (Draw)
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
--Functions for effect 6 (Special Summon opponent's monster)
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
    end
end
--Functions for effect 7 (Inflict 4000 damage)
function s.dmgcon(e,tp,eg,ep,ev,re,r,rp)
    local lp1=Duel.GetLP(tp)
    local lp2=Duel.GetLP(1-tp)
    return math.abs(lp1-lp2)>=9000
end
function s.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(4000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end