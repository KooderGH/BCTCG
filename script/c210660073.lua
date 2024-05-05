--Oda Nobunaga
--Scripted by senorpizza
--Effect:
--(1) When this card is Summoned; Add 1 Equip Spell Card from your deck to your hand.
--(2) When this card is sent to the GY; Add 1 Equip Spell card from your GY to your hand.
--(3) When this card is tributed; Add 1 FIRE monster from your deck or GY to your hand.
--(4) If you control 4 FIRE monster's: You can Special Summon this card from your hand.
local s,id=GetID()
function s.initial_effect(c)
    --When this card is Summoned; Add 1 Equip Spell Card from your deck to your hand.
    
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    --When this card is sent to the GY; Add 1 Equip Spell card from your GY to your hand.
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetTarget(s.addtg)
    e2:SetOperation(s.addop) 
    c:RegisterEffect(e2)
	--When this card is tributed; Add 1 FIRE monster from your deck or GY to your hand.
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetCode(EVENT_RELEASE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(s.srtg)
    e3:SetOperation(s.srop)
    c:RegisterEffect(e3)
    --If you control 4 FIRE monster's: You can Special Summon this card from your hand.
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EFFECT_SPSUMMON_PROC)
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(s.spcon)
    c:RegisterEffect(e4)
end
--Add 1 Equip Spell Card from your deck to your hand.
function s.filter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--Add 1 Equip Spell Card from your GY to your hand.
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--Add 1 FIRE monster from your deck or GY to your hand.
function s.srfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--You can Special Summon this card from your hand if you control 4 FIRE monsters.
function s.spfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_MZONE,0,4,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
