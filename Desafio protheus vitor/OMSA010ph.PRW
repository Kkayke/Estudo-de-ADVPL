#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ExecAuto em MVC
Rotina automatica em tela mvc
@author  Kayke
@since   15/06/2023
@version 1.0
/*/
//------------------- ------------------------------------------------

User function OMS1(cProduto)

	Local aErro         := {}
	Local aProdutos     := {}
	Local x             := 0
	Local lRet          := .f.
	Local oDA0Mod
	Local oDA1Mod
	PRIVATE lMsErroAuto := .F.

	If (!IsBlind())
		PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'
	EndIf

	oModel := FWLoadModel("OMSA010")

	oModel:SetOperation(3)

	oModel:Activate()

	//Array com informações de que sera aplicado nos campos
	AADD( aProdutos,{"1",cValToChar(cProduto),85.00})

	//===========Cabeçalho da tabela==================//
	oDA0Mod := oModel:GetModel("DA0MASTER")
	oDA0Mod:SetValue("DA0_CODTAB" ,GETSXENUM("DA0","DA0_CODTAB"))	//-----------> Codigo da Tabela de preço
	oDA0Mod:SetValue("DA0_DESCRI" , "Produto para Testes")			//-----------> Descrição da tabela
	oDA0Mod:SetValue("DA0_DATDE" , Date())							//-----------> Data inicial
	oDA0Mod:SetValue("DA0_HORADE" , "00:00")						//-----------> Hora inicial
	oDA0Mod:SetValue("DA0_HORATE" , "23:59")						//-----------> Hora final
	oDA0Mod:SetValue("DA0_TPHORA" , "1")							//-----------> Tipo de hora
	oDA0Mod:SetValue("DA0_ATIVO" , "1")								//-----------> Se for ativo ou Não

//==============Grid da tabela=======================//
	oDa1Mod := oModel:GetModel("DA1DETAIL")
	For x = 1 to LEN(aProdutos)
		oDA1Mod:SetValue("DA1_TIPPRE", aProdutos[x][1])				//-----------> Tipo de produto
		oDA1Mod:SetValue("DA1_CODPRO", aProdutos[x][2])				//-----------> Codigo do produto
		oDA1Mod:SetValue("DA1_PRCBAS",aProdutos[x][3])				//-----------> Preço base do produto

		//Realizando Validação
		If oModel:VldData()

			//Realizando commit
			If oModel:CommitData()
				lOk := .T.
				ConfirmSX8()

				//Caso houver erro na validação
			Else
				lOk := .F.
				RollBackSX8()
				aErro := oModel:GetErrorMessage()
			EndIf


		Else
			lOk := .F.
			RollBackSX8()
			aErro := oModel:GetErrorMessage()
		EndIf
	next

	//Se der certo notificara o usuario com mensagem de sucesso
	if lOk
		FWAlertSuccess("O usuario Fez uma inclusão automatica na tabela de preço " ,"Inclusão automatica com sucesso")
	else
		FWAlertError(aErro[6],"Não foi possivel realizar a inclusão na tabela de preço")
	endif

	If (!IsBlind())
		RESET ENVIRONMENT
	EndIf

return(lRet)
