--Neo Backhoe Cat
--Scripted By Konstak
--Effect:
-- 1 EARTH Machine monster, except tokens.
-- (1) Cannot be used as Link material.
-- (2) You can only control one "Neo Backhoe Cat".
-- (3) Your opponent can only target "Neo Backhoe Cat" for attacks.
-- (4) This card gains the following effect(s), based on the "Grandon Corps" Monster(s) you control except "Neo Backhoe Cat":
-- * Neo Cutter Cat: "Grandon Corps" Monsters you control gain 900 ATK.
-- * Neo Driller Cat: "Grandon Corps" Monsters you control cannot be targeted by card effects.
-- * Neo Saw Cat: This card cannot be destroyed by battle.
-- * Neo Piledriver Cat: You take no battle damage from attacks involving this card.
-- (5) Your opponent takes damage based on the number of "Grandon Corps" Monsters you control x 500
-- (6) "Grandon Corps" monsters you control cannot be tributed.
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --Link Summon
    c:EnableReviveLimit()
    Link.AddProcedure(c,s.machinefilter,1,1,s.lcheck)
    --cannot link material
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    --Only "Neo Backhoe Cat" can be attack target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(s.atlimit)
    c:RegisterEffect(e1)
    --"Grandon Corps" gain 900 ATK
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetLabel(1)
    e2:SetCondition(s.cuttercon)
    e2:SetTarget(s.grandfilter)
    e2:SetValue(900)
    c:RegisterEffect(e2)
    --"Grandon Corps" cannot be targeted by card effects.
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetLabel(1)
    e3:SetCondition(s.drillercon)
    e3:SetTarget(s.grandfilter)
    c:RegisterEffect(e3)
    --Cannot be destroyed by battle.
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetLabel(1)
    e4:SetValue(1)
    e4:SetCondition(s.sawcon)
    c:RegisterEffect(e4)
    --No Battle damage
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetLabel(1)
    e5:SetValue(1)
    e5:SetCondition(s.piledrivercon)
    c:RegisterEffect(e5)
    --Pay 500 LP based on how many you control
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetCountLimit(1)
    e6:SetOperation(s.lpop)
    c:RegisterEffect(e6)
    --"Grandon Corps" monsters you control cannot be tributed.
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetCode(EFFECT_UNRELEASABLE_SUM)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(1,1)
    e7:SetTarget(s.trlimit)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e8)
end
--lcheck
function s.machinefilter(c,scard,sumtype,tp)
    return c:IsRace(RACE_MACHINE,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_EARTH,scard,sumtype,tp) and not c:IsType(TYPE_TOKEN)
end
function s.lcheck(g,lc,sumtype,tp)
    return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end
--Only "Neo Backhoe Cat" can be attack target function
function s.atlimit(e,c)
    return c:IsFacedown() or not c:IsCode(id)
end
--Grandons filter
function s.grandfilter(e,c,tp,r)
    return (c:IsCode(210661443) or c:IsCode(210661444) or c:IsCode(210661445) or c:IsCode(210661446) or c:IsCode(210661447)) and c:IsFaceup()
end
--Cutter Filter
function s.cutterfilter(c)
    return c:IsFaceup() and c:IsCode(210661445)
end
function s.cuttercon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.cutterfilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Driller Filter
function s.drillerfilter(c)
    return c:IsFaceup() and c:IsCode(210661443)
end
function s.drillercon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.drillerfilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Saw Filter
function s.sawfilter(c)
    return c:IsFaceup() and c:IsCode(210661447)
end
function s.sawcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.sawfilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Piledriver Filter
function s.piledriverfilter(c)
    return c:IsFaceup() and c:IsCode(210661444)
end
function s.piledrivercon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.GetMatchingGroupCount(s.piledriverfilter,tp,LOCATION_ONFIELD,0,nil)>=e:GetLabel()
end
--Damage LP
function s.lpfilter(c)
    return c:IsFaceup() and (c:IsCode(210661443) or c:IsCode(210661444) or c:IsCode(210661445) or c:IsCode(210661446) or c:IsCode(210661447))
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d = Duel.GetMatchingGroupCount(s.lpfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*500
    if e:GetHandler():IsRelateToEffect(e) and d then
        Duel.Damage(1-tp,d,REASON_EFFECT)
    end
end
--Cannot tribute
function s.trlimit(e,c,tp,r)
    return (c:IsCode(210661443) or c:IsCode(210661444) or c:IsCode(210661445) or c:IsCode(210661446) or c:IsCode(210661447)) and c:IsFaceup()
        and c:IsControler(e:GetHandlerPlayer()) and not c:IsImmuneToEffect(e) and r&REASON_EFFECT>0
end