-- Celeboodle
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --Traitless Ability
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.stval)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    --Opponent drop Money draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,3))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)
end
--Traitless Ability Function
function s.stval(e,c)
    local tp=c:GetControler()
    local v=Duel.GetLP(tp)
    if v>=10000 then return 500 end
    if v>=7000 and v<10000 then return 400 end
    if v>=4000 and v<7000 then return 300 end
    if v>=2000 and v<4000 then return 200 end
    if v>=0 and v<2000 then return 100 end
end
--Draw Function
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsPlayerCanDraw(1-tp,1) then
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
    Duel.Draw(1-tp,1,REASON_EFFECT)
end