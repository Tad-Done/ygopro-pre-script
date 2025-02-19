--夢魔鏡の逆徒－ネイロイ
--
--Script by JoyJ
function c101107018.initial_effect(c)
	aux.AddCodeList(c,74665651,1050355)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107018,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101107018)
	e1:SetTarget(c101107018.thtg)
	e1:SetOperation(c101107018.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107018,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101107018+100)
	e3:SetCost(c101107018.spcost)
	e3:SetTarget(c101107018.sptg)
	e3:SetOperation(c101107018.spop)
	c:RegisterEffect(e3)
end
function c101107018.thfilter(c)
	return c:IsCode(18189187) and c:IsAbleToHand()
end
function c101107018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107018.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101107018.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101107018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		if Duel.SelectYesNo(tp,aux.Stringid(101107018,2)) then
			Duel.BreakEffect()
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(ATTRIBUTE_LIGHT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c101107018.costfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x131) and c:IsLevelAbove(0)
		and Duel.IsExistingMatchingCard(c101107018.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
		and Duel.GetMZoneCount(tp,c)>0
end
function c101107018.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x131) and not c:IsLevel(lv)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (aux.IsCodeListed(c,74665651) and Duel.IsExistingMatchingCard(c101107018.spthfilter,tp,LOCATION_DECK,0,1,nil,74665651)
			or aux.IsCodeListed(c,1050355) and Duel.IsExistingMatchingCard(c101107018.spthfilter,tp,LOCATION_DECK,0,1,nil,1050355))
end
function c101107018.spthfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c101107018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if Duel.CheckReleaseGroup(tp,c101107018.costfilter,1,c,e,tp) then
			e:SetLabel(1)
			return true
		else
			e:SetLabel(0)
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rc=Duel.SelectReleaseGroup(tp,c101107018.costfilter,1,1,c,e,tp):GetFirst()
	e:SetLabel(rc:GetLevel())
	Duel.Release(rc,REASON_COST)
end
function c101107018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c101107018.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101107018.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		local tc=g:GetFirst()
		local g2=Group.CreateGroup()
		if aux.IsCodeListed(tc,74665651) then
			g2:Merge(Duel.GetMatchingGroup(c101107018.spthfilter,tp,LOCATION_DECK,0,nil,74665651))
		end
		if aux.IsCodeListed(tc,1050355) then
			g2:Merge(Duel.GetMatchingGroup(c101107018.spthfilter,tp,LOCATION_DECK,0,nil,1050355))
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
