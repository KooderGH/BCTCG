--Shiro Amakusa
--Scripted By poka-poka
--(1) FLIP: Target up to 2 monsters your opponent controls; Set their ATK to 0. This effect is negated if you control a non-FIRE Warrior Monster.
--(2) When this card is destroyed by battle, you can target up to 2 FIRE Warrior monster in your hand or GY; Special summon them.
--(3) This card gains the following effect(s) based on the number of Equip Cards equipped to it:
	--1+:Once per turn (Ignition): Target 1 card on the field; Destroy it.
	--3+:You can Tribute this card; Add 6 Equip Cards from your deck/GY to your hand.
local s,id=GetID()
function s.initial_effect(c)
    -- 1. FLIP: Set ATK of up to 2 opponent's monsters to 0
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_FLIP)
    e1:SetTarget(s.fliptg)
    e1:SetOperation(s.flipop)
    c:RegisterEffect(e1)
    -- 2. Special Summon up to 2 FIRE Warrior monsters when destroyed by battle
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
    -- 3. Effect based on number of Equip Cards
    -- a. Eq>=1: Destroy 1 target on the field
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(s.descon)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3) 
    -- b. Eq>=3: Tribute and add up to 6 Equip Cards to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(s.thcon)
    e4:SetCost(s.thcost)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)
end
-- 1. FLIP Effect: Set ATK of up to 2 opponent's monsters to 0
function s.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
    if chk == 0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g = Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,#g,0,0)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsExistingMatchingCard(s.nonfirewarriorfilter,tp,LOCATION_MZONE,0,1,nil) then
        Duel.NegateEffect(0)
        return
    end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    for tc in aux.Next(g) do
        if tc:IsFaceup() and tc:IsRelateToEffect(e) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(0)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
    end
end
function s.nonfirewarriorfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and not c:IsAttribute(ATTRIBUTE_FIRE)
end
-- 2. Special Summon up to 2 FIRE Warrior monsters when destroyed by battle
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    -- Check if the card was destroyed by battle
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE)
end
-- Filter: FIRE Warrior monsters in hand or graveyard
function s.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- Target: Select up to 2 FIRE Warrior monsters from your hand or graveyard
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,math.min(2,ft),tp,LOCATION_HAND+LOCATION_GRAVE)
end
-- Operation: Special Summon the selected monsters
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,math.min(2,ft),nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end
-- 3a.1 Equip : select a target destroy it
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipCount()>=1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk == 0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc = Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
-- 3b. 3 Equip : Tribute this card, select up to 6 Equip Card from Deck/GY to hand
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipCount()>=3
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(), REASON_COST)
end
function s.thfilter(c)
    return c:IsType(TYPE_EQUIP) and (c:IsAbleToHand() or c:IsLocation(LOCATION_GRAVE))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local max_select = math.min(6, Duel.GetMatchingGroupCount(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,max_select,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end