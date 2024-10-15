-- Divine Cyclone
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    c:EnableUnsummonable()
    --special summon tribute
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Opponent No Battle Damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Attack all each time
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_ATTACK_ALL)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Can banish zombie monsters
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetTarget(s.bntg)
    e4:SetOperation(s.bnop)
    c:RegisterEffect(e4)
end
function s.angelfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function s.spcon(e,c)
	if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.angelfilter,2,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,s.angelfilter,2,2,false,true,true,c,nil,nil,false,nil,nil)
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
--Banish Zombies function
function s.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_ZOMBIE) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
        Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
    end
end