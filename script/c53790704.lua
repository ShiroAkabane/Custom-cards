--Sesshomaru
function c53790704.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,53790704)
	e1:SetCondition(c53790704.spcon)
	e1:SetCost(c53790704.cost)
	e1:SetTarget(c53790704.sptg)
	e1:SetOperation(c53790704.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,53790704)
	e2:SetCost(c53790704.cost)
	e2:SetTarget(c53790704.thtg)
	e2:SetOperation(c53790704.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(53790704,ACTIVITY_SPSUMMON,c53790704.counterfilter)
	--(3) Gain ATK/DEF
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(53790704,1))
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c53790704.atkcon)
    e3:SetTarget(c53790704.atktg)
    e3:SetOperation(c53790704.atkop)
    c:RegisterEffect(e3)
end
function c53790704.counterfilter(c)
	return c:IsSetCard(0x5EB)
end
function c53790704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(53790704,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c53790704.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c53790704.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x5EB)
end
function c53790704.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5EB) and not c:IsCode(53790704)
end
function c53790704.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53790704.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c53790704.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c53790704.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c53790704.thfilter(c)
	return c:IsCode(53790704) and c:IsAbleToHand()
end
function c53790704.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53790704.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53790704.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c53790704.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--(3) Gain ATK/DEF
function c53790704.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local des=eg:GetFirst()
  local rc=des:GetReasonCard()
  if des:IsType(TYPE_XYZ) then
    e:SetLabel(des:GetRank()) 
  elseif des:IsType(TYPE_LINK) then
    e:SetLabel(des:GetLink())
  else
    e:SetLabel(des:GetLevel())
  end
  return rc and rc:IsSetCard(0x5EB) and rc:IsControler(tp) and rc:IsRelateToBattle() and des:IsReason(REASON_BATTLE) 
end
function c53790704.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c53790704.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end