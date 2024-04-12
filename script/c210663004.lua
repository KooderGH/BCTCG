--Type-O4R Annihilate
--Scripted by Konstak
--Effects:
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixRep(c,true,true,s.fil,1,1)
    Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
    --cannot be fusion material (1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Cannot be returned (3)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Cannot banish
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e3)
    --Can banish zombie monsters
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetTarget(s.bntg)
    e4:SetOperation(s.bnop)
    c:RegisterEffect(e4)
    --Once Destroyed add "Type-80T" to deck
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetTarget(s.addtg)
    e5:SetOperation(s.addop)
    c:RegisterEffect(e5)
    --Place one counter
    c:EnableCounterPermit(0x4001)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,2))
    e6:SetCategory(CATEGORY_COUNTER)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetTarget(s.addct)
    e6:SetOperation(s.addc)
    c:RegisterEffect(e6)
    --move
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id,3))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetTarget(s.seqtg)
    e7:SetOperation(s.seqop)
    c:RegisterEffect(e7)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
    if contact then sumtype=0 end
    return c:IsType(ATTRIBUTE_EARTH,fc,sumtype,tp) and c:IsFaceup() and c:IsCode(210660355) and c:IsRace(RACE_MACHINE,fc,sumtype,tp) and (not contact or c:IsType(TYPE_MONSTER,fc,sumtype,tp))
end
function s.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
    return Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,0,nil,tp)
end
function s.cfilter(c,tp)
    return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function s.contactop(g,tp,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
--Banish Zombies function
function s.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_ZOMBIE) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
        Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
    end
end
--Destroy and add function
function s.addfilter(c)
    return c:IsCode(210663000) and c:IsAbleToDeck()
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--addcounter
s.counter_list={0x4001}
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x4001)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x4001,1)
    end
end
--Destroy
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    Duel.Hint(HINT_ZONE,tp,seq)
    e:SetLabel(math.log(seq,2))
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local seq2=e:GetLabel()
    if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) or not Duel.CheckLocation(tp,LOCATION_MZONE,seq2) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local seq1=c:GetSequence() --register the sequence it comes from
    local dg=c:GetColumnGroup() --and the group of cards there
    local zones=c:GetColumnZone(LOCATION_ONFIELD)
    Duel.MoveSequence(c,seq2)
    if c:GetSequence()==seq2 and seq1~=seq2 then
        Duel.BreakEffect()
        if #dg>0 then
            Duel.BreakEffect()
            Duel.SendtoGrave(dg,REASON_EFFECT)
        end
        -- Zones in the same column cannot be used
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE_FIELD)
        e1:SetRange(LOCATION_MZONE)
        e1:SetLabel(zones)
        e1:SetOperation(s.znop)
        e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
        Duel.RegisterEffect(e1,tp)
    end
end
function s.znop(e,tp,eg,ep,ev,re,r,rp)
    return e:GetLabel()
end