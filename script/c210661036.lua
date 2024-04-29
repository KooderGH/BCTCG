--Fishman Cat
--Scripted by Konstak.
--Effect:
-- 2+ Monster(s) (Fusion Monster)
-- (1) Must first be Special Summoned (from your Extra Deck) by sending the above cards from your field to the GY. (You do not use "Polymerization") The original ATK and DEF of this card becomes 1000 x the number of materials used for its Special Summon.
-- (2) If this card battles a WIND type monster, double this card's ATK until the end of the damage step.
-- (3) If this card attacks, it is changed to Defense Position at the end of the Battle Phase, and its battle position cannot be changed until the End Phase of your next turn.
-- (4) If this card is in face-up defense position, it cannot be targeted for an attack and it cannot be targeted by card effects.
local s,id=GetID()
function s.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixRep(c,true,true,s.fil,2,99)
    Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
    --during damage calculation gain double atk
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(s.atktg)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1)
    --to defense
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.poscon)
    e2:SetOperation(s.posop)
    c:RegisterEffect(e2)
    --Cannot be attacked
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetCondition(s.cantcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Cannot be targeted by card effects
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(s.cantcon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
    if contact then sumtype=0 end
    return c:IsFaceup() and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
    return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
end
function s.cfilter(c,tp)
    return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function s.contactop(g,tp,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
    e1:SetValue(#g*1000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    c:RegisterEffect(e2)
end
--during damage calculation function
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsAttribute(ATTRIBUTE_WIND) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToBattle() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(c:GetAttack())
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        c:RegisterEffect(e1)
    end
end
--To Defense Position
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- If attacks, then go to def
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
    c:RegisterEffect(e1)
end
--Cannot be target for an attack function
function s.cantcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end