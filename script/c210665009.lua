--Dragon's Ultimate Offering
--Scripted by poka-poka
--Effect : During your Main Phase: You can pay 1000 LP: Immediately after this effect resolves, Normal Summon/Set 1 Dragon Monster.
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    -- Additional Normal Summon/Set for a Dragon monster
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(s.nscost)
    e2:SetTarget(s.nstg)
    e2:SetOperation(s.nsop)
    c:RegisterEffect(e2)
end

function s.nscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function s.nsfilter(c,tp)
    return c:IsRace(RACE_DRAGON) and c:IsSummonable(true,nil)
end
function s.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND,0,1,nil,tp) end
end
function s.nsop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
    if #g>0 then
        Duel.Summon(tp,g:GetFirst(),true,nil)
    end
end
