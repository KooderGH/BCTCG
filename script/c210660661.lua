--Chronos the Bride
--Scripted by Konstak
local s,id=GetID()
function s.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Cannot be destroyed by battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --atklimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e3)
    --reflect battle dam
 --   local e4=Effect.CreateEffect(c)
  --  e4:SetType(EFFECT_TYPE_SINGLE)
  --  e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
 --   e4:SetValue(1)
 --   c:RegisterEffect(e4)
    --Destroy 1 Spell/Trap, then get additional effec based on destroyed card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.battlecon)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
    --send
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DECKDES)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(s.sdcon)
    e6:SetTarget(s.sdtg)
    e6:SetOperation(s.sdop)
    c:RegisterEffect(e6)
    -- Deck Destroy
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,2))
    e7:SetCategory(CATEGORY_DECKDES)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
    e7:SetCost(s.sdcost2)
    e7:SetTarget(s.sdtg2)
    e7:SetOperation(s.sdop2)
    c:RegisterEffect(e7)
	--neither player take battle damage involving this card
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
end
--e1
function s.spfilter(c)
    return c:IsDiscardable() and c:IsType(TYPE_TRAP)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,s.spfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--e5
function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
    -- Ensure the monster with this effect was involved in the battle
    local c=e:GetHandler()
    return c:IsRelateToBattle()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
-- Destruction effect and adding based on the card destroyed
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local tg=g:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if Duel.Destroy(tc, REASON_EFFECT) then
            -- If it's a Spell card, add 1 Trap from Graveyard to hand
            if tc:IsType(TYPE_SPELL) then
                if Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_GRAVE,0,1,nil,TYPE_TRAP) then
                    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
                    local trap = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_TRAP)
                    if #trap>0 then
                        Duel.SendtoHand(trap,nil,REASON_EFFECT)
                    end
                end
            -- If it's a Trap card, add 1 Spell from Graveyard to hand
            elseif tc:IsType(TYPE_TRAP) then
                if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL) then
                    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
                    local spell = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_SPELL)
                    if #spell>0 then
                        Duel.SendtoHand(spell,nil,REASON_EFFECT)
                    end
                end
            end
        end
    end
end
--e6
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,5)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
end
--e7
function s.sdfilter2(c)
    return c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function s.sdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.sdfilter2,tp,LOCATION_DECK,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.sdfilter2,tp,LOCATION_DECK,0,3,3,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.sdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,10)
end
function s.sdop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(1-tp,10,REASON_EFFECT)
end