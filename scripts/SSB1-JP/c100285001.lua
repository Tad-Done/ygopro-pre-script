--閃術兵器－H.A.M.P.
--
--Script by Ruby & mercury233
function c100285001.initial_effect(c)
	--special summon rule(on self field)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100285001,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCountLimit(1,100285001+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100285001.spcon)
	e1:SetOperation(c100285001.spop)
    c:RegisterEffect(e1)
	--special summon rule(on oppent field)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(100285001,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,1)
    e2:SetCountLimit(1,100285001+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c100285001.spcon2)
	e2:SetOperation(c100285001.spop2)
    c:RegisterEffect(e2)
    --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100285001,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetTarget(c100285001.dstg)
	e3:SetOperation(c100285001.dsop)
	c:RegisterEffect(e3)
end
function c100285001.checkfilter(c)
	return c:IsSetCard(0x1115) and c:IsFaceup()
end
function c100285001.sprfilter(c,tp,sp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c,sp)>0
end
function c100285001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c100285001.checkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100285001.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp,tp)
end
function c100285001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c100285001.sprfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,tp)
	Duel.Release(g,REASON_COST)
end
function c100285001.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c100285001.checkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100285001.sprfilter,tp,0,LOCATION_MZONE,1,nil,1-tp,tp)
end
function c100285001.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c100285001.sprfilter,tp,0,LOCATION_MZONE,1,1,nil,1-tp,tp)
	Duel.Release(g,REASON_COST)
end
function c100285001.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100285001.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
