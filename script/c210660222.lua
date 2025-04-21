--Huge Hermit
--Scripted by Konstak
--Effect
--(1) When this card is Summoned; Place in Defense position.
--(2) You can only control 1 "Huge Hermit".
--(3) Once per turn (Ignition): You can activate this effect; Special Summon as many "Small Hermit" token's (Machine/FIRE/Level 4/ATK 0/DEF 1500) in Defense Position as possible. "Small Hermit" token's cannot be destroyed by battle and cannot be used as link material.
--(4) When "Huge Hermit" leaves the field; Destroy all "Small Hermit" on your side of the field.
--(5) During your opponent's end phase; Add 1 "Hi-Do" from your deck, GY, or banish zone to your hand.
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one (2)
    c:SetUniqueOnField(1,0,id)
    --When Summoned, change to defense position (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.postg)
    e1:SetOperation(s.posop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --Special Summon Small Hermit tokens (3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(s.sptg)
    e4:SetOperation(s.spop)
    c:RegisterEffect(e4)
    --Destroy all Small Hermit tokens when this leaves the field (4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetTarget(s.destg)
    e5:SetOperation(s.desop)
    c:RegisterEffect(e5)
    --Add Hi-Do during opponent's end phase (5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,3))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_PHASE+PHASE_END)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(s.thcon)
    e6:SetTarget(s.thtg)
    e6:SetOperation(s.thop)
    c:RegisterEffect(e6)
end
--Functions for effect 1 (Change to defense position)
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
--Functions for effect 3 (Special Summon tokens)
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,210668009,0,TYPES_TOKEN,0,1500,4,RACE_MACHINE,ATTRIBUTE_FIRE) end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,210668009,0,TYPES_TOKEN,0,1500,4,RACE_MACHINE,ATTRIBUTE_FIRE) then return end
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
    local tokens = {}
    for i=1,ft do
        local token=Duel.CreateToken(tp,210668009)
        table.insert(tokens, token)
    end
    for _,token in ipairs(tokens) do
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        --Cannot be destroyed by battle
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e1,true)
        --Cannot be used as Link Material
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e2,true)
    end
    Duel.SpecialSummonComplete()
end
--Functions for effect 4 (Destroy tokens when leaving field)
function s.desfilter(c)
    return c:IsCode(210668009) --Small Hermit token
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end

--Functions for effect 5 (Add Hi-Do during opponent's end phase)
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end

function s.thfilter(c)
    return c:IsCode(210660225) and c:IsAbleToHand() --Hi-Do code
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end