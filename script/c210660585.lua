--Mighty Aegis Garu
--Scripted by Konstak
--Effect
-- (1) When you take damage from a card in your opponent's possession: You can Special Summon this card from your hand.
-- (2) When this card is Special Summoned by its effect: Activate the appropriate effect based on the type of damage:
-- * Battle damage: Change all your opponent's monsters to face-down Defense Position. Monsters changed to face-down Defense Position by this effect cannot change their battle positions.
-- * Effect damage: Gain LP equal to the amount of damage you took. This card gains DEF equal to the amount of damage you took.
-- (3) During your opponent's end phase: If this is the only monster you control; You can add up to 2 cards from your GY to your hand.
local s,id=GetID()
function s.initial_effect(c)
    --special summon (1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,{id,1})
    e1:SetCondition(s.sumcon)
    e1:SetTarget(s.sumtg)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)
    --special summon success (2) *1
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.sumcon2)
    e2:SetTarget(s.sumtg2)
    e2:SetOperation(s.sumop2)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    -- *2
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(s.sumcon3)
    e3:SetTarget(s.sumtg3)
    e3:SetOperation(s.sumop3)
    e3:SetLabelObject(e1)
    c:RegisterEffect(e3)
    --GY to hand (3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,3))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(s.addcon)
    e4:SetTarget(s.addtg)
    e4:SetOperation(s.addop)
    c:RegisterEffect(e4)
end
--(1)
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and tp~=rp and Duel.IsTurnPlayer(1-tp)
	and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) + 2 <= Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local sumtype=1
    if (r&REASON_BATTLE)~=0 then 
        sumtype=2
    elseif (r&REASON_EFFECT)~=0 then
        sumtype=3
    end
    if Duel.SpecialSummon(c,sumtype,tp,tp,false,false,POS_FACEUP)~=0 then
        e:SetLabel(ev)
    end
end
--(2) *1
function s.sumcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+2
end
function s.sumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.sumop2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
    if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
        local og=Duel.GetOperatedGroup()
        local tc=og:GetFirst()
        for tc in aux.Next(og) do
            --Cannot change their battle positions
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(3313)
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
    end
end
--(2) *2
function s.sumcon3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+3
end
function s.sumtg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local d=e:GetLabelObject():GetLabel()
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(d)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,d)
end
function s.sumop3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(d)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
    end
end
--(3)
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function s.addfilter(c)
    return c:IsAbleToHand()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_GRAVE,0,1,2,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
