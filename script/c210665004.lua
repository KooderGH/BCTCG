--A Warlord's Spirit Lives On!
--Scripted by poka-poka
--Effects : Target 1 FIRE Warrior monster and 1 equip spell in your GY; Special Summon that targets and equip the monster with the targeted equip spell.
local s,id=GetID()
function s.initial_effect(c)
    -- Activate effect: Special Summon and equip
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- Filters for FIRE Warrior and Equip Spell in GY
function s.monster_filter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.equip_filter(c,tp)
    return c:IsType(TYPE_EQUIP) and c:IsSpell() and c:IsAbleToHand()
end
-- Targets
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then 
        return Duel.IsExistingTarget(s.monster_filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
            and Duel.IsExistingTarget(s.equip_filter,tp,LOCATION_GRAVE,0,1,nil,tp)
    end
    -- Select 1 FIRE Warrior monster
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,s.monster_filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    -- Select 1 Equip Spell
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectTarget(tp,s.equip_filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
-- Activate SS then Equip
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    local monster=tg:Filter(Card.IsType,nil,TYPE_MONSTER):GetFirst()
    local equip=tg:Filter(Card.IsType,nil,TYPE_SPELL):GetFirst()
    if monster and equip and Duel.SpecialSummon(monster,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.Equip(tp,equip,monster)
    end
end
