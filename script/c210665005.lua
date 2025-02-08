--Warlord's Gamble
--Scripted by poka-poka
--Effect : Add 1 FIRE Warrior monster and 1 equip spell from your deck to your hand. For the rest of this turn, when you summon a monster, take 700 LP damage (even if this card leaves the field). You can only activate the effect of "Warlord's Gamble" once per turn.
local s,id=GetID()
function s.initial_effect(c)
    -- Activation
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    -- Add 1 FIRE Warrior and 1 Equip Spell to hand, then take 700 LP damage for every summon this turn
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end
function s.thfilter1(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function s.thfilter2(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
            and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if #g1>0 and #g2>0 then
        g1:Merge(g2)
        Duel.SendtoHand(g1,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
    -- 700 LP damage
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCondition(s.damcon)
    e3:SetOperation(s.damop)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    Duel.RegisterEffect(e4,tp)
    local e5=e3:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    Duel.RegisterEffect(e5,tp)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp-1
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(tp,700,REASON_EFFECT)
end
