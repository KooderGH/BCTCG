-- Drury Witch
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    -- Special Summon this card
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    -- Special Summon Tribute
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetCondition(s.spcon2)
    e2:SetTarget(s.sptg2)
    e2:SetOperation(s.spop2)
    c:RegisterEffect(e2)
    --Hide
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.spelltarget)
    e3:SetOperation(s.spellop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --Weaken Ability
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,3))
    e6:SetCategory(CATEGORY_DISABLE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE+LOCATION_SZONE)
    e6:SetCountLimit(1)
    e6:SetTarget(s.weakentg)
    e6:SetOperation(s.weakenop)
    c:RegisterEffect(e6)
end
--Special Summon SS Function
function s.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0 or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_DARK),c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--Special Summon Tribute Function
function s.blackfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.spcon2(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.blackfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.blackfilter,1,1,false,true,true,c,nil,nil,false,nil,nil)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
    return true
    end
    return false
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Release(g,REASON_COST)
    g:DeleteGroup()
end
--Hide Function
function s.spelltarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.spellop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
end
--Weaken
function s.weakentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_APPLYTO)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.weakenop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        e1:SetValue(-tc:GetAttack()/4)
        tc:RegisterEffect(e1)
    end
end