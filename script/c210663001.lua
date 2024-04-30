--Summer Vacation Vigler
--Scripted by Konstak
--Effect
-- 2 "Detective Vigler" monsters (Fusion Monster)
-- (1) Cannot be used as Fusion Material.
-- (2) Must be Special Summoned only (from your Extra Deck) by sending 2 "Detective Vigler" from your field to the GY. (You do not use "Polymerization")
-- (3) When your opponent activates a monster effect: You can discard this card and a level 4 or higher DARK Warrior monster from your hand; negate that effect and destroy it.
-- (4) When this card is Special Summoned: Target 2 cards on the field; Banish them and deal 2000 damage to your opponent.
-- (5) When this card on the field is sent to the GY; You can add 1 card from your GY to your hand except "Summer Vacation Vigler".
local s,id=GetID()
function s.initial_effect(c)
    --Can only control one
    c:SetUniqueOnField(1,0,id)
    --fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixRep(c,true,true,s.fil,2,2)
    Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
    --cannot be fusion material
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
    --Special banish damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(s.tbtarget)
    e1:SetOperation(s.tboperation)
    c:RegisterEffect(e1)
    --Recover from grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(s.thcon)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end
--Special Summon Functions
function s.fil(c,fc,sumtype,tp,sub,mg,sg,contact)
	if contact then sumtype=0 end
	return c:IsFaceup() and c:IsCode(210660431)
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
--e1
function s.tbtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
	end
end
function s.tboperation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetTargetCards(e)
    if #tc>0 then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        Duel.Damage(1-tp,2000,REASON_EFFECT)
    end
end
--e2
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thfilter(c)
	return c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
