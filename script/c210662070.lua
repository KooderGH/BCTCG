-- Metal Cyclone
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --special summon tribute
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_HAND)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetCondition(s.spcon)
    e0:SetTarget(s.sptg)
    e0:SetOperation(s.spop)
    c:RegisterEffect(e0)
    --Opponent No Battle Damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Attack all each time
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Opponent drop Money draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DRAW)	
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
end
function s.filter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR) and c:IsFaceup()
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.filter,2,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.filter,2,2,false,true,true,c,nil,nil,false,nil,nil)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
    return true
    end
    return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Release(g,REASON_COST)
    g:DeleteGroup()
end
--Draw Function
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsPlayerCanDraw(1-tp,2) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
        e1:SetRange(LOCATION_GRAVE)
        e1:SetCode(EVENT_PHASE+PHASE_DRAW)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        e1:SetCountLimit(1)
        e1:SetOperation(s.drawop)
        c:RegisterEffect(e1)
    end
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(1-tp,2,REASON_EFFECT)
end