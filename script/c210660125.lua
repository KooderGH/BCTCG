--Takeda Shingen
--Scripted by poka-poka
local s,id=GetID()
function s.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
    -- Effect 1: Discard this card and one other FIRE Warrior monster to draw 2 cards
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(s.discost)
    e1:SetTarget(s.drawtg)
    e1:SetOperation(s.drawop)
    c:RegisterEffect(e1)
    -- Effect 2: Special Summon this card if your opponent controls 2+ monsters and you control at least 1 FIRE Warrior Monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(s.spcon)
    c:RegisterEffect(e2)
    -- Effect 3: You can attach up to 3 Equip Spells in GY to this card when Tribute Summoned (not Forced || You can, but you don't have to?)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(s.eqtg)
    e3:SetOperation(s.eqop)
    c:RegisterEffect(e3)
    -- Effect 4: Add 1 Equip Spell from your deck to your hand when Special Summoned (Forced)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)
    -- Effect 5: Sent to Graveyard if non-FIRE Warrior is controlled
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_SELF_TOGRAVE)
    e5:SetCondition(s.tgcon)
    c:RegisterEffect(e5)
    -- Effect 6: Opponent takes half battle damage involving this card
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e6:SetRange(LOCATION_MZONE) 
	e6:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e6)
    -- Effect 7: Reduce ATK by 400 for each FIRE Warrior monster you control
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetCondition(s.atkcon)
    e7:SetValue(s.atkval)
    c:RegisterEffect(e7)
    -- Effect 8a: Gain 500 ATK for each equip card
    local e8a=Effect.CreateEffect(c)
    e8a:SetType(EFFECT_TYPE_SINGLE)
    e8a:SetCode(EFFECT_UPDATE_ATTACK)
	e8a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8a:SetRange(LOCATION_MZONE)
    e8a:SetValue(s.eqatkval)
    c:RegisterEffect(e8a)
    -- Effect 8b: Gain extra attacks for each equip card
    local e8b=Effect.CreateEffect(c)
    e8b:SetType(EFFECT_TYPE_SINGLE)
    e8b:SetCode(EFFECT_EXTRA_ATTACK)
    e8b:SetValue(s.extraatkval)
    c:RegisterEffect(e8b)
	-- Effect 9: Unaffected By other card effect when equiped by equip spell
	local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(s.immcon)
    e9:SetValue(s.efilter)
    c:RegisterEffect(e9)
end

-- Effect 1: Discard 2 cost and draw 2 cards
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(function(c) return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) end,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
    Duel.DiscardHand(tp,function(c) return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) end,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.eqfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT) > 0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g > 0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
-- Effect 2: Special Summon condition and operation
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>=2
        and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_FIRE+RACE_WARRIOR),c:GetControler(),LOCATION_MZONE,0,1,nil)
end
-- Effect 3: Equip up to 3 spells from GY when Tribute Summoned
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_EQUIP) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_EQUIP) end
    local max_count = math.min(3, Duel.GetLocationCount(tp,LOCATION_SZONE))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,max_count,nil,TYPE_EQUIP)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft<=0 then return end
    if #g>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        g=g:Select(tp,ft,ft,nil)
    end
    for tc in aux.Next(g) do
        if tc:IsRelateToEffect(e) then
            Duel.Equip(tp,tc,c)
        end
    end
end
-- Effect 4: Add 1 equip spell from deck to hand when Special Summoned
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_EQUIP) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_EQUIP)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-- Effect 5: Sent to Graveyard if non-FIRE Warrior is controlled
function s.nonfirewarriorfilter(c)
    return c:IsMonster() and (not c:IsAttribute(ATTRIBUTE_FIRE) or not c:IsRace(RACE_WARRIOR))
end

function s.tgcon(e)
    return Duel.IsExistingMatchingCard(s.nonfirewarriorfilter, e:GetHandlerPlayer(), LOCATION_MZONE, 0, 1, nil)
end
-- Effect 7: Reduce ATK by 400 for each FIRE Warrior monster you control
function s.atkcon(e)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_FIRE+RACE_WARRIOR),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_FIRE),c:GetControler(),LOCATION_MZONE,0,nil)*(-400)
end
-- Effect 8a: Gain 500 ATK for each equip card
function s.eqatkval(e,c)
    return c:GetEquipCount()*500
end
-- Effect 8b: Gain extra attacks for each equip card
function s.extraatkval(e,c)
    return c:GetEquipCount()
end

-- Effect 9
function s.efilter(e,te)
    return te:GetHandler()~=e:GetHandler()
end
function s.immcon(e)
    local c=e:GetHandler()
    local eqg=c:GetEquipGroup()
    return eqg and eqg:IsExists(Card.IsType,1,nil,TYPE_SPELL)
end
