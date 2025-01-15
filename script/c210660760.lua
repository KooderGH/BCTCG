--Gunduros 
--Scripted by poka-poka
--(1) You cannot Special Summon this card from your hand.
--(2) When this card is Tribute Summoned, you can add up to 5 FIRE Dragon monsters from your GY to your hand, then, you can Normal Summon 1 monster from your hand.
--(3) If this card is Special Summoned, target up to 2 monsters your opponent controls; Destroy them.
--(4) When this card is destroyed by a card effect, Target 3 dragon monsters you control; Destroy them, and if you do, Special Summon as many FIRE Dragon monster's from your GY as possible except "Gunduros".
--(5) When this card is destroyed by battle: Target 1 spell or trap card on your opponent's side of the field; Destroy it.
local s,id=GetID()
function s.initial_effect(c)
	--Effect 1 : Cannot be special summoned from the Hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(s.splimcon)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--Effect 2 : When this card is Tribute Summoned, you can add up to 5 FIRE Dragon monsters from your GY to your hand, then, you can Normal Summon 1 monster from your hand.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.tscon)
	e2:SetTarget(s.tstg)
	e2:SetOperation(s.tsop)
	c:RegisterEffect(e2)
	-- Effect 3: If this card is Special Summoned, target up to 2 monsters your opponent controls; Destroy them.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	-- Effect 4: When destroyed by a card effect, destroy 3 Dragon monsters you control, then Special Summon FIRE Dragon monsters from your GY
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(s.efdescon)
	e4:SetTarget(s.efdestg)
	e4:SetOperation(s.efdesop)
	c:RegisterEffect(e4)
	-- Effect e5: Destroy 1 Spell/Trap when destroyed by battle
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCondition(s.battlecon)
	e5:SetTarget(s.battletg)
	e5:SetOperation(s.battleop)
	c:RegisterEffect(e5)
end
--(1)
function s.splimcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_HAND)
end
--(2)
function s.tscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function s.fireDragonFilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.fireDragonFilter,tp,LOCATION_GRAVE,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.fireDragonFilter,tp,LOCATION_GRAVE,0,1,5,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    -- Optional Normal Summon 1 monster from hand
    if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
        local sg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil)
        if #sg>0 then
            Duel.Summon(tp,sg:GetFirst(),true,nil)
        end
    end
end
--(3)
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if g then
        local tg=g:Filter(Card.IsRelateToEffect,nil,e)
        if #tg>0 then
            Duel.Destroy(tg,REASON_EFFECT)
        end
    end
end
--(4)
function s.efdescon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.efdestg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.dragonfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.dragonfilter,tp,LOCATION_MZONE,0,3,nil)
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.dragonfilter,tp,LOCATION_MZONE,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,maxSummon,0,tp,LOCATION_GRAVE)
end
function s.dragonfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) and c:IsDestructable()
end
function s.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_DRAGON) and not c:IsCode(id)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.efdesop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local g=tg:Filter(Card.IsRelateToEffect,nil,e)
    if #g==3 and Duel.Destroy(g,REASON_EFFECT)==3 then
        local availableZones = Duel.GetLocationCount(tp, LOCATION_MZONE)
        local spg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
        local maxSummon=math.min(availableZones,spg:GetCount())
        if maxSummon>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local toSummon = spg:Select(tp,1,maxSummon,nil)
            Duel.SpecialSummon(toSummon,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
--(5)
function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_BATTLE)
end
function s.stfilter(c)
	return c:IsSpellTrap() and c:IsDestructable()
end
function s.battletg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and s.stfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.stfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,s.stfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end