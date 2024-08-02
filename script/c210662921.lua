-- Dread Bore
--Scripted by Konstak.
local s,id=GetID()
function s.initial_effect(c)
    --Revive
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetTarget(s.sumtg)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)
    --Surge Attack on Battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCondition(s.surgecon)
    e2:SetTarget(s.surgetg)
    e2:SetOperation(s.surgeop)
    c:RegisterEffect(e2)
    --Attack all each time
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_ATTACK_ALL)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.CheckLPCost(c:GetControler(),1500) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
        Duel.PayLPCost(tp,1500)
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	end
end
--Surge on Battle Function
function s.surgecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.surgetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.surgeop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.NegateAttack()
    local d1=6
    while d1>3 do
        d1=Duel.TossDice(tp,1)
    end
    local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,d1)
    local Zone=d1
    if tc then
        local seq=tc:GetSequence()
        local nseq=seq
        Duel.Destroy(tc,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE_FIELD)
        e1:SetRange(LOCATION_SZONE)
        e1:SetLabel(nseq+16)
        e1:SetOperation(s.disop)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY,1)
        Duel.RegisterEffect(e1,tp)
    else
        local seq=Zone
        local nseq=seq
        if Duel.CheckLocation(1-tp,LOCATION_MZONE,nseq) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_DISABLE_FIELD)
            e1:SetRange(LOCATION_SZONE)
            e1:SetLabel(nseq+16)
            e1:SetOperation(s.disop)
            e1:SetReset(RESET_PHASE+PHASE_STANDBY,1)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function s.disop(e,tp)
    return 0x1<<e:GetLabel()
end