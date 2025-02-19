--死者所生
--
--Script by JoyJ
--not fully implemented
SUMTYPE_MONSTER_REBORN = 83764718
function c101107077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101107077.condition)
	e1:SetCost(c101107077.cost)
	e1:SetTarget(c101107077.target)
	e1:SetOperation(c101107077.activate)
	c:RegisterEffect(e1)
	if not c101107077.last_turn then
		c101107077.last_turn=-1
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetOperation(c101107077.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101107077.checkop1(e,tp,eg,ep,ev,re,r,rp)
	c101107077.last_turn=Duel.GetTurnCount()
end
function c101107077.condition(e,tp,eg,ep,ev,re,r,rp)
	return c101107077.last_turn==Duel.GetTurnCount()
end
function c101107077.cfilter(c)
	return c:IsCode(83764718) and c:IsAbleToGraveAsCost()
end
function c101107077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107077.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101107077.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101107077.tgfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMTYPE_MONSTER_REBORN,tp,false,false)
end
function c101107077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101107077.tgfilter(chkc,e,tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(c101107077.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101107077.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101107077.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,SUMTYPE_MONSTER_REBORN,tp,tp,false,false,POS_FACEUP)
	end
end
