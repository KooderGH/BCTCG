--Vars
--Scripted by Senor Pizza. Help by Konstak
--Effect
--(1) You can Normal Summon this card without tribute if you control no monsters OR only control Dragon type monsters.
--(2) When this card is Special Summoned: You can target one monster your opponent controls, return it.
--(3) When this card is Tribute Summoned using Dragon monster. Neither player can Special Summon monsters while this card is face-up on the field.
--(4) If this Tribute Summoned card on the field is destroyed by a card effect; Destroy all Normal Summoned monster's on your opponent's side of the field.
--(5) If this card is destroyed by battle, add 1 Dragon monster from your deck to your hand.
--(6) Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.
local s,id=GetID()
function s.initial_effect(c)
    --You can Normal Summon this card without tribute if you control no monsters OR only control Dragon type monsters.(1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(s.nscon)
    c:RegisterEffect(e1)
    --Once SS: return 1 card (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.retg)
    e2:SetOperation(s.reop)
    c:RegisterEffect(e2)
    --when tribute summoned using dragon monster, neither player can sp summon(3)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	--tribute check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(s.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
    --When destroyed by card effect (4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(s.descon)
    e5:SetTarget(s.destg)
    e5:SetOperation(s.desop)
    c:RegisterEffect(e5)
    --Can be treated as 2 Tributes for the Tribute Summon of a Dragon monster.(6)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e6:SetValue(function (e,c) return c:IsRace(RACE_DRAGON) end)
    c:RegisterEffect(e6)
	--When destroyed by battle (5)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,3))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetCondition(s.descon2)
    e7:SetTarget(s.destg2)
    e7:SetOperation(s.desop2)
    c:RegisterEffect(e7)
end
function s.nscon(e, c)
    if c==nil then return true end
    local tp=c:GetControler()
    local hasNonDragonMonster = Duel.IsExistingMatchingCard(function(mc) return not mc:IsRace(RACE_DRAGON) end,tp,LOCATION_MZONE,0,1,nil)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) == 0 or not hasNonDragonMonster
end
--e2
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsType(TYPE_MONSTER) and chkc:IsAbleToHand() end
    if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,function(c) return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
--e3
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsRace,1,nil,RACE_DRAGON) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE) and e:GetLabel()==1
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    --disable spsummon (3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1)
end
--e5
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT)and c:IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.desfilter(c)
    return c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
--e7
function s.addfilter(c)
    return c:IsMonster() and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end