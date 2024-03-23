-- Le'Saint
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
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)	
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTarget(s.drtg)
    e2:SetOperation(s.drop)
    c:RegisterEffect(e2)
    --Can banish zombie monsters
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetTarget(s.bntg)
    e3:SetOperation(s.bnop)
    c:RegisterEffect(e3)
end
function s.angelfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.spcon(e,c)
	if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.angelfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,s.angelfilter,1,1,false,true,true,c,nil,nil,false,nil,nil)
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
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(1-tp,2) end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(2)	
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
--Banish Zombies function
function s.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_ZOMBIE) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
    Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
    end
end