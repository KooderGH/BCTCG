--Hanasaka Cat
--Scripted by Gideon
--(1) You can only use 1 of these effects of "Hanasaka Cat" per turn, and only once that turn.
--* If this card is Summoned while you control another WIND monster; Add 1 WIND monster from your GY to your hand but you cannot Normal Summon/Set or Special Summon monsters with that name, nor activate their monster effects for the rest of this turn.
--* If this card is sent from the field to the GY while you control no monster: Target up to 3 WIND monsters in your GY; Add those targets to your hand but you cannot Normal Summon/Set or Special Summon monsters with that name, nor activate their monster effects for the rest of this turn.
--* If this card deals direct battle damage: Target up to 5 WIND monsters in your GY: Add those targets to your hand but you cannot Normal Summon/Set or Special Summon monsters with that name, nor activate their monster effects for the rest of this turn.
local s,id=GetID()
function s.initial_effect(c)
--Add 1 WIND from GY to hand on Summon
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
e1:SetCode(EVENT_SUMMON_SUCCESS)
e1:SetTarget(s.tg)
e1:SetOperation(s.op)
e1:SetCountLimit(1,id)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
c:RegisterEffect(e2)
local e3=e1:Clone()
e3:SetCode(EVENT_SPSUMMON_SUCCESS)
c:RegisterEffect(e3)
--Field to GY
local e4=Effect.CreateEffect(c)
e4:SetDescription(aux.Stringid(id,1))
e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
e4:SetCode(EVENT_TO_GRAVE)
e4:SetCountLimit(1,id)
e4:SetCondition(s.gycon)
e4:SetTarget(s.gytg)
e4:SetOperation(s.gyop)
c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
e5:SetDescription(aux.Stringid(id,2))
e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e5:SetCode(EVENT_BATTLE_DAMAGE)
e5:SetCountLimit(1,id)
e5:SetCondition(function(e,tp,eg,ep) return ep==1-tp and Duel.GetAttackTarget()==nil end)
e5:SetTarget(s.directtarget)
e5:SetOperation(s.directoperation)
c:RegisterEffect(e5)
end
--General WIND to hand filter
function s.thfilter(c)
return c:IsMonster() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand()
end
function s.faceupfilter(c)
return c:IsMonster() and c:IsAttribute(ATTRIBUTE_WIND)
end
--Grave to hand
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
    --Check Wind on field
    and Duel.IsExistingMatchingCard(aux.FaceupFilter(s.faceupfilter),tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
local tc=g:GetFirst()
if not tc then return end
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,tc)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(s.sumlimits)
        e1:SetLabel(tc:GetCode())
        e1:SetReset(RESET_PHASE|PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        Duel.RegisterEffect(e2,tp)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CANNOT_MSET)
        Duel.RegisterEffect(e3,tp)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_CANNOT_ACTIVATE)
        e4:SetValue(s.aclimits)
        Duel.RegisterEffect(e4,tp)
        end

end
--Group limits for 1.2
function s.sumlimit(e,c)
    local codes=e:GetLabelObject()
    return #codes>0 and c:IsCode(table.unpack(codes))
end
function s.aclimit(e,re,tp)
    local codes=e:GetLabelObject()
    return re:GetHandler():IsCode(table.unpack(codes)) and re:IsMonsterEffect()
end
function s.sumlimits(e,c)
return c:IsCode(e:GetLabel())
end
function s.aclimits(e,re,tp)
return re:GetHandler():IsCode(e:GetLabel()) and re:IsMonsterEffect()
end
--Effect 2: Check mzone empty
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
--Effect 2 Target up to 3
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,3,e,tp)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,LOCATION_GRAVE)
end
--Add group to hand
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetTargetCards(e)
    if tg then
        local g=tg:Filter(Card.IsRelateToEffect,nil,e)
        if #tg>0 then
            if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
                Duel.ConfirmCards(1-tp,tg)
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_CANNOT_SUMMON)
                e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e1:SetTargetRange(1,0)
                e1:SetTarget(s.sumlimit)
                e1:SetLabelObject(g:GetClass(Card.GetCode))
                e1:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e1,tp)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
                Duel.RegisterEffect(e2,tp)
                local e3=e1:Clone()
                e3:SetCode(EFFECT_CANNOT_MSET)
                Duel.RegisterEffect(e3,tp)
                local e4=e1:Clone()
                e4:SetCode(EFFECT_CANNOT_ACTIVATE)
                e4:SetValue(s.aclimit)
                Duel.RegisterEffect(e4,tp)
                end
            end
        if not tg then return end
    end
end
--Direct attack effect: Add cards - Target
function s.directtarget(e,tp,eg,ep,ev,re,r,rp,chk)
if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,5,e,tp)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,LOCATION_GRAVE)
end
--Group to hand
function s.directoperation(e,tp,eg,ep,ev,re,r,rp)
local tg=Duel.GetTargetCards(e)
if tg then
    local g=tg:Filter(Card.IsRelateToEffect,nil,e)
    if #tg>0 then
        if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
            Duel.ConfirmCards(1-tp,tg)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_CANNOT_SUMMON)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetTargetRange(1,0)
            e1:SetTarget(s.sumlimit)
            e1:SetLabelObject(g:GetClass(Card.GetCode))
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
            Duel.RegisterEffect(e2,tp)
            local e3=e1:Clone()
            e3:SetCode(EFFECT_CANNOT_MSET)
            Duel.RegisterEffect(e3,tp)
            local e4=e1:Clone()
            e4:SetCode(EFFECT_CANNOT_ACTIVATE)
            e4:SetValue(s.aclimit)
            Duel.RegisterEffect(e4,tp)
            end
        end
    if not tg then return end
    end
end
