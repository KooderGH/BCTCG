--Demon Knight Kyklops
--Scripted by Gideon and Larry. Huge thanks to Larry for ruling help on LP gain cost lol.
--Effect
-- Does Piercing Damage.
-- When this card is Tribute Summoned: Target one monster your opponent controls; deal damage to your opponent equal to that monster's attack.
-- When this card is Special Summoned: You can increase your opponent's LP by 3000; Draw 2 cards.

local s,id=GetID()
function s.initial_effect(c)
	--pierce
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e1)
	--Tribute Burn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(s.tbcondition)
	e2:SetTarget(s.tbtarget)
	e2:SetOperation(s.tboperation)
	c:RegisterEffect(e2)
	--Draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCost(s.dcost)
    e3:SetTarget(s.dtarget)
    e3:SetOperation(s.dactivate)
    c:RegisterEffect(e3)
end
--e2
function s.tbcondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.tbtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
        end
    end
function s.tboperation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local atk=tc:GetAttack()
        Duel.Damage(1-tp,atk,REASON_EFFECT)
    end
end
--e3
function s.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_RECOVER) end
    Duel.Recover(1-tp,3000,REASON_COST)
end
function s.dtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.dactivate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
