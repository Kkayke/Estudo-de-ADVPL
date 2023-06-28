#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} OMS1
Rotina automatica em tela mvc
@author  Kayke
@since   15/06/2023
@version 22.10
/*/
//------------------- ------------------------------------------------

User function OMS1(cProduto,nOpr)

	Local aErro         := {}
	Local aProdutos     := {}
	Local x             := 0
	Local lRet          := .f.
	local lOk			:= .F.
	Local oDA0Mod
	Local oDA1Mod
	PRIVATE lMsErroAuto := .F.

	If (!IsBlind())
		PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'	//Array com informações de que sera aplicado nos campos
	ENDIF

	oModel := FwLoadModel("OMSA010")

	oModel:SetOperation(nOpr)

	oModel:Activate()

	AADD( aProdutos,{DA0->DA0_CODTAB,"1",cProduto})

	If nOpr == 3
		//===========Cabeçalho da tabela==================//
		oDA0Mod:= oModel:GetModel("DA0MASTER")
		oDA0Mod:SetValue("DA0_CODTAB" ,GETSXENUM("DA0","DA0_CODTAB"))	//-----------> Codigo da Tabela de preço
		oDA0Mod:SetValue("DA0_DESCRI" , "Produto para Testes")			//-----------> Descrição da tabela
		oDA0Mod:SetValue("DA0_DATDE" , Date())							//-----------> Data inicial
		oDA0Mod:SetValue("DA0_HORADE" , "00:00")						//-----------> Hora inicial
		oDA0Mod:SetValue("DA0_HORATE" , "23:59")						//-----------> Hora final
		oDA0Mod:SetValue("DA0_TPHORA" , "1")							//-----------> Tipo de hora
		oDA0Mod:SetValue("DA0_ATIVO" , "1")								//-----------> Se for ativo ou Não
		//==============Grid da tabela=======================//
		oDa1Mod := oModel:GetModel("DA1DETAIL")
		oDA1Mod:AddLine()
		For x = 1 to LEN(aProdutos)
			oDA1Mod:SetValue("DA1_TIPPRE", aProdutos[x][2])				//-----------> Tipo de produto
			oDA1Mod:SetValue("DA1_CODPRO", aProdutos[x][3])			//-----------> Codigo do produto

			//Se conseguir validar as informações
			If oModel:VldData()

				//Tenta realizar o Commit
				If oModel:CommitData()
					lOk := .T.
					ConfirmSX8()

					//Se não deu certo, altera a variável para false aa
				Else
					lOk := .F.
					RollBackSX8()
					aErro := oModel:GetErrorMessage()
				EndIf

				//Se não conseguir validar as informações, altera a variável para false
			Else
				lOk := .F.
				RollBackSX8()
				aErro := oModel:GetErrorMessage()
			EndIf
		next
	endif

	If nOpr == 4
		If DA0->(MsSeek(xFilial('DA0')+DA0->DA0_CODTAB))
			DBSetOrder(1)
			oDa1Mod := oModel:GetModel("DA1DETAIL")
			oDa1Mod:Addline()
			oDa1Mod:SetValue("DA1_CODTAB", aProdutos[1][1])
			oDa1Mod:SetValue("DA1_TIPPRE", aProdutos[1][2])
			oDA1Mod:SetValue("DA1_CODPRO", aProdutos[1][3])			//-----------> Codigo do produto
			//Se conseguir validar as informações
			If oModel:VldData()
				//Tenta realizar o Commit
				If oModel:CommitData()
					lOk := .T.
					ConfirmSX8()
					//Se não deu certo, altera a variável para false aa
				Else
					lOk := .F.
					RollBackSX8()
					aErro := oModel:GetErrorMessage()
				EndIf
				//Se não conseguir validar as informações, altera a variável para false
			Else
				lOk := .F.
				RollBackSX8()
				aErro := oModel:GetErrorMessage()
			EndIf
		endif
	endif

	//Se der tudo certo ou algum erro ira aparecer mensagem pro usuario
	if lOk
		FWAlertSuccess("O usuario Adicionou um produto na tabela de preço " ,"Produto incluido com sucesso")
	else
		FWAlertError(aErro[6],"Não foi possivel realizar a inclusão na tabela de preço")
	endif

	If (!IsBlind())
		RESET ENVIRONMENT
	EndIf

return(lRet)
