--Kaguya of the coast
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    -- Effect 1: Special Summon from hand if LP are 4000 or less
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    -- Effect 2: Change battle position when Summoned
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(s.sumpostg)
	e2:SetOperation(s.sumposop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
    -- Effect 3: Both players cannot conduct their battle phase
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_BP)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(1,1)
    c:RegisterEffect(e5)
    -- Effect 4: Opponent draws 1 card during their standby phase
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.drawcon)
	e6:SetTarget(s.drawtg)
	e6:SetOperation(s.drawop)
	c:RegisterEffect(e6) 
    -- Effect 5: Change to face-down Defense Position
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(s.postg)
	e7:SetOperation(s.posop)
	c:RegisterEffect(e7) 
    -- Effect 6: Place card face-up in Spell & Trap Zone
    local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,3))
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(s.stzcon)
    e8:SetOperation(s.stzop)
    c:RegisterEffect(e8)
end
-- Effect 1: Special Summon from hand if LP are 4000 or less
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.GetLP(c:GetControler())<=4000
end
-- Effect 2: Change battle position when Summoned
function s.sumpostg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.sumposop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
-- Effect 4: Opponent draws 1 card during their standby phase
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,1,REASON_EFFECT)
end
-- Effect 5: Change to face-down Defense Position
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
-- Effect 6: Place card face-up in Spell & Trap Zone
function s.stzcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
-- Operation: Move the card to the Spell & Trap Zone and set up the draw effect
function s.stzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT|(RESETS_STANDARD&~RESET_TURN_SET))
		c:RegisterEffect(e1)
        -- Register effect to draw when WIND monster is destroyed
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        e2:SetCode(EVENT_DESTROYED)
        e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
        e2:SetRange(LOCATION_SZONE)
		e2:SetCountLimit(1,id)
        e2:SetCondition(s.drcon)
        e2:SetOperation(s.drop)
        c:RegisterEffect(e2)
    end
end
-- Condition for drawing 2 cards when a WIND monster is destroyed
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsContinuousSpell() and
           eg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND) and
           eg:IsExists(Card.IsControler,1,nil,tp) and
           r&(REASON_EFFECT)~=0
end
-- Draw 2 cards operation
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,2,REASON_EFFECT)
end
