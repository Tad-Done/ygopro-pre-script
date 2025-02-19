--死償不知
--
--Script by Trishula9
function c101107079.initial_effect(c)
	--activate 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101107079.condition)
	e1:SetTarget(c101107079.target)
	e1:SetOperation(c101107079.operation)
	c:RegisterEffect(e1)
end
function c101107079.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c101107079.desfilter(c,dif)
	return c:IsAttackBelow(dif) and c:IsFaceup()
end
function c101107079.spfilter(c,dif,e,tp)
	return c:IsAttackBelow(dif) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dif=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c101107079.desfilter,tp,0,LOCATION_MZONE,1,nil,dif)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c101107079.spfilter,tp,LOCATION_GRAVE,0,1,nil,dif,e,tp)	
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(101107079,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(101107079,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(101107079,0),aux.Stringid(101107079,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
	end
	if s==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c101107079.operation(e,tp,eg,ep,ev,re,r,rp)
	local dif=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	if dif<=0 then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c101107079.desfilter,tp,0,LOCATION_MZONE,1,1,nil,dif)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101107079.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,dif,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
