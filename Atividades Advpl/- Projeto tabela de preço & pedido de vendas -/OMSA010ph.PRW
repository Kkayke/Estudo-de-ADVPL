
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

	oModel := FWLoadModel("OMSA010")     //------>Carregando a rotina

	oModel:SetOperation(3)               //------> Opera��o de inclus�o

	oModel:Activate()					//-------> Ativando a rotina

	//Array com informa��es de que sera aplicado nos campos
	AADD( aProdutos,{"1",cProduto,85.00})

	//===========Cabe�alho da tabela==================//
	oDA0Mod := oModel:GetModel("DA0MASTER")
	oDA0Mod:SetValue("DA0_CODTAB" ,GETSXENUM("DA0","DA0_CODTAB"))	//-----------> Codigo da Tabela de pre�o
	oDA0Mod:SetValue("DA0_DESCRI" , "Produto para Testes")			//-----------> Descri��o da tabela
	oDA0Mod:SetValue("DA0_DATDE" , Date())							//-----------> Data inicial
	oDA0Mod:SetValue("DA0_HORADE" , "00:00")						//-----------> Hora inicial
	oDA0Mod:SetValue("DA0_HORATE" , "23:59")						//-----------> Hora final
	oDA0Mod:SetValue("DA0_TPHORA" , "1")							//-----------> Tipo de hora
	oDA0Mod:SetValue("DA0_ATIVO" , "1")								//-----------> Se for ativo ou N�o

//==============Grid da tabela=======================//
	oDa1Mod := oModel:GetModel("DA1DETAIL")
	For x = 1 to LEN(aProdutos)
		oDA1Mod:SetValue("DA1_TIPPRE", aProdutos[x][1])				//-----------> Tipo de produto
		oDA1Mod:SetValue("DA1_CODPRO", aProdutos[x][2])				//-----------> Codigo do produto
		oDA1Mod:SetValue("DA1_PRCBAS",aProdutos[x][3])				//-----------> Pre�o base do produto

		//Se conseguir validar as informa��es
		If oModel:VldData()

			//Tenta realizar o Commit
			If oModel:CommitData()
				lOk := .T.
				ConfirmSX8()

				//Se n�o deu certo, altera a vari�vel para false aa
			Else
				lOk := .F.
				RollBackSX8()
				aErro := oModel:GetErrorMessage()
			EndIf

			//Se n�o conseguir validar as informa��es, altera a vari�vel para false
		Else
			lOk := .F.
			RollBackSX8()
			aErro := oModel:GetErrorMessage()
		EndIf
	next

//Se der tudo certo ou algum erro ira aparecer mensagem pro usuario
	if lOk
		FWAlertSuccess("O usuario Fez uma inclus�o automatica na tabela de pre�o " ,"Inclus�o automatica com sucesso")
	else
		FWAlertError(aErro[6],"N�o foi possivel realizar a inclus�o na tabela de pre�o")
	endif

	If (!IsBlind())
		RESET ENVIRONMENT
	EndIf

return(lRet)
