--Dark Aegis Garu
--Scripted by Konstak
--Effect
-- (1) When you take damage from a card in your opponent's possession: You can Special Summon this card from your hand.
-- (2) When this card is Special Summoned by its effect: Activate the appropriate effect based on the type of damage:
-- * Battle damage: Destroy all monster's your opponent controls.  You can only use this effect of "Dark Aegis Garu" once per Duel.
-- * Effect damage: Inflict damage to your opponent equal to double the damage you took. This card gains ATK equal to the damage you inflicted to your opponent this way.
-- (3) Other monsters you control cannot attack.
-- (4) During each end phase: This card gains 1000 ATK.
-- (5) If this card ATK is 8000 or higher: This card can attack directly.
local s,id=GetID()
function s.initial_effect(c)
    --special summon (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,{id,1})
    e1:SetCondition(s.sumcon)
    e1:SetTarget(s.sumtg)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)
    --special summon success (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(s.sumcon2)
    e2:SetTarget(s.sumtg2)
    e2:SetOperation(s.sumop2)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(s.sumcon3)
    e3:SetTarget(s.sumtg3)
    e3:SetOperation(s.sumop3)
    e3:SetLabelObject(e1)
    c:RegisterEffect(e3)
    --Cannot attack (3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(function(_e,_c) return _e:GetHandler()~=_c end)
    c:RegisterEffect(e4)
    --During each end phase: This card gains 1000 ATK. (4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,3))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCountLimit(1)
    e5:SetOperation(s.atkop)
    c:RegisterEffect(e5)
    --Can attack directly (5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DIRECT_ATTACK)
    e6:SetCondition(s.atkval2)
    c:RegisterEffect(e6)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and tp~=rp and Duel.IsTurnPlayer(1-tp)
	and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) + 2 <= Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local sumtype=1
    if (r&REASON_BATTLE)~=0 then 
        sumtype=2
    elseif (r&REASON_EFFECT)~=0 then
        sumtype=3
    end
    if Duel.SpecialSummon(c,sumtype,tp,tp,false,false,POS_FACEUP)~=0 then
        e:SetLabel(ev)
    end
end
--(2) *1
function s.sumcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+2
end
function s.sumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.sumop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
    --if c:IsRelateToEffect(e) and c:IsFaceup() then
     --   local e1=Effect.CreateEffect(c)
     --   e1:SetType(EFFECT_TYPE_FIELD)
     --   e1:SetCode(EFFECT_CANNOT_ATTACK)
     --   e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
     --   e1:SetTargetRange(LOCATION_MZONE,0)
     --   e1:SetReset(RESET_PHASE+PHASE_END)
     --   Duel.RegisterEffect(e1,tp)
    --end
end
--(2) *2
function s.sumcon3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+3
end
function s.sumtg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local d=e:GetLabelObject():GetLabel()*2
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(d)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
end
function s.sumop3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(d)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end
--(4)
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end
--(5)
function s.atkval2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsAttackAbove(8000)
end