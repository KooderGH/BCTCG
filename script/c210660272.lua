--By Konstak
--Splendid Ganesha
local s,id=GetID()
function s.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --Discard this card and one other FIRE Warrior monster to draw 2 cards
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e2:SetCost(s.discost)
    e2:SetTarget(s.drawtg)
    e2:SetOperation(s.drawop)
    c:RegisterEffect(e2)
    --Destroy 1 face-down monster your opponent controls when this card is Normal Summoned
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
    local e3a=e3:Clone()
    e3a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3a)
    --Destruction replacement by Tributing 1 monster
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(s.reptg)
    e4:SetOperation(s.repop)
    e4:SetValue(function(e,c) return s.repfilter(c,e:GetHandlerPlayer()) end)
    c:RegisterEffect(e4)
end
--e2
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_HAND,0,1,e:GetHandler(),RACE_CREATORGOD) end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
    Duel.DiscardHand(tp,Card.IsRace,1,1,REASON_COST+REASON_DISCARD,e:GetHandler(),RACE_CREATORGOD)
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(4)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    Duel.BreakEffect()
    Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
--e3
function s.filter(c)
    return c:IsFacedown() and c:IsDestructable()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--e4
function s.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE|REASON_EFFECT)
        and not c:IsReason(REASON_REPLACE)
end
function s.trbfilter(c,e)
    return c:IsReleasableByEffect() and not c:IsImmuneToEffect(e)
        and not c:IsStatus(STATUS_DESTROY_CONFIRMED|STATUS_BATTLE_DESTROYED)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
        and Duel.IsExistingMatchingCard(s.trbfilter,tp,LOCATION_MZONE,0,1,eg,e)  end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
        local tg=Duel.SelectMatchingCard(tp,s.trbfilter,tp,LOCATION_MZONE,0,1,1,eg,e)
        Duel.SetTargetCard(tg)
        return true
    else return false end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,1-tp,id)
    local tc=Duel.GetFirstTarget()
    Duel.Release(tc,REASON_EFFECT|REASON_REPLACE)
end