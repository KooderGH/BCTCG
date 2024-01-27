--Yuletide Nurse
--Scripted by Konstak
--Effect
-- (1) Cannot be Special Summoned.
-- (2) When this card is Summoned: If the LP difference between both players' LP is 4000 or more; Both player's LP become 9000, then banish this card.
-- (3) Cannot be attacked or targeted by effects.
-- (4) During the End phase: Target 1 Card in your GY; Add it to your hand.
-- (5) Once per turn (Ignition): You can target 1 monster you control and declare a monster type and attribute; Both this card and that monster become that type and attribute while face-up on the field.
-- (6) During your turn, except the turn this card was sent to the GY: You can banish this card from your GY; Gain 300 LP for each card in your opponent's deck.
-- (7) While this card is in your hand, If a monster is targeted by a effect: Reveal this card; Negate the effect that targeted that monster and destroy it. You can only use this effect of "Yuletide Nurse" once per Duel.
local s,id=GetID()
function s.initial_effect(c)
    --cannot special summon (1)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --Once special summoned set LP if 4k or more (2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(s.smcon)
    e2:SetOperation(s.smop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --Cannot be attacked (3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --Cannot be targeted by card effects(3)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --Add one card from GY to Hand (4)
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,1))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_PHASE+PHASE_END)
    e7:SetCountLimit(1)
    e7:SetTarget(s.stg)
    e7:SetOperation(s.sop)
    c:RegisterEffect(e7)
    --Change its Type and Attribute (5)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,2))
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1,id)
    e8:SetTarget(s.chtg)
    e8:SetOperation(s.chop)
    c:RegisterEffect(e8)
    --during your turn banish from GY and gain 300 LP from opp's deck (6)
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(id,3))
    e9:SetCategory(CATEGORY_RECOVER)
    e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_GRAVE)
    e9:SetCost(aux.bfgcost)
    e9:SetCondition(aux.exccon)
    e9:SetCountLimit(1)
    e9:SetTarget(s.rtarget)
    e9:SetOperation(s.roperation)
    c:RegisterEffect(e9)
    --While in card, reveal card, negate effect, destroy that monster
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,4))
    e10:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e10:SetType(EFFECT_TYPE_QUICK_O)
    e10:SetCode(EVENT_CHAINING)
    e10:SetRange(LOCATION_HAND)
    e10:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e10:SetTarget(s.distg)
    e10:SetOperation(s.disop)
    c:RegisterEffect(e10)
end
--(2)
function s.smcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)-Duel.GetLP(1-tp)>=4000 or Duel.GetLP(1-tp)-Duel.GetLP(tp)>=4000
end
function s.smop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,9000)
    Duel.SetLP(1-tp,9000)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--(4)
function s.searchfilter(c,e,tp)
    return c:IsAbleToHand()
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.searchfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.searchfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--(5)
function s.racefilter(c)
    return c:IsFaceup() and not c:IsCode(id)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(s.racefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.SelectTarget(tp,s.racefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local c=e:GetHandler()
    local rc=c:AnnounceAnotherRace(tp)
    local att=c:AnnounceAnotherAttribute(tp)
    e:SetLabel(rc,att)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if (not c:IsFaceup() and c:IsRelateToEffect(e)) then return end
    local rc,att=e:GetLabel()
        -- Change monster type
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetValue(rc)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        tc:RegisterEffect(e2)
        -- Change Attribute
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e3:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e3:SetValue(att)
        c:RegisterEffect(e3)
        local e4=e3:Clone()
        tc:RegisterEffect(e4)
end
--(6)
function s.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 and Duel.GetTurnPlayer()==e:GetHandlerPlayer() then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
    local rt=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)*300
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,rt,0,tp,0)
end
function s.roperation(e,tp,eg,ep,ev,re,r,rp)
    local rt=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)*300
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rt,REASON_EFFECT)
end
--(7)
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.NegateEffect(ev)
    Duel.Destroy(eg,REASON_EFFECT)
end