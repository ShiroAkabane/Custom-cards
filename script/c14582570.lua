--Spell Circle of Spell Counter
function c14582570.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14582570+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c14582570.target)
	e1:SetOperation(c14582570.activate)
	c:RegisterEffect(e1)
end
function c14582570.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x1,1)
end
function c14582570.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c14582570.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14582570.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75014062,1))
	Duel.SelectTarget(tp,c14582570.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1)
end
function c14582570.tfilter(c)
	return c:IsCode(75014062) and c:IsAbleToHand()
end
function c14582570.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x1,3) then
		local th=Duel.GetFirstMatchingCard(c14582570.tfilter,tp,LOCATION_DECK,0,nil)
		if th and Duel.SelectYesNo(tp,aux.Stringid(14582570,0)) then
			Duel.SendtoHand(th,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,th)
		end
	end
end
