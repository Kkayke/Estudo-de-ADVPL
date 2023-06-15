#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ExecAuto em MVC
Rotina automatica em tela mvc
@author  Kayke
@since   15/06/2023
@version 1.0
/*/
//-------------------------------------------------------------------

User function OMS1()

	Local aErro         := {}
	Local aProdutos     := {}
	Local x             := 0
	Local lRet          := .f.
	Local oDA0Mod
	Local oDA1Mod
	PRIVATE lMsErroAuto := .F.

	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'

	oModel := FWLoadModel("OMSA010")

	oModel:SetOperation(3)

	oModel:Activate()

	//Array com informações de que sera aplicado nos campos
	AADD( aProdutos,{"1","1",100.00})
	AADD( aProdutos,{"1","2",100.00})

	//Campos pai
	oDA0Mod := oModel:GetModel("DA0MASTER")
	oDA0Mod:SetValue("DA0_CODTAB" ,GETSXENUM("DA0","DA0_CODTAB")   )
	oDA0Mod:SetValue("DA0_DESCRI" , "123")
	oDA0Mod:SetValue("DA0_DATDE" , Date()  )
	oDA0Mod:SetValue("DA0_HORADE" , "00:00"   )
	oDA0Mod:SetValue("DA0_HORATE" , "23:59"  )
	oDA0Mod:SetValue("DA0_TPHORA" , "1")
	oDA0Mod:SetValue("DA0_ATIVO" , "1"  )

//Campos filhos ja preenchidos com informações dadas no array
	oDa1Mod := oModel:GetModel("DA1DETAIL")
	For x = 1 to Len(aProdutos)
		oDA1Mod:SetValue("DA1_TIPPRE", aProdutos[z][1])
		oDA1Mod:SetValue("DA1_ITEM",   StrZero(z,4))
		oDA1Mod:SetValue("DA1_CODPRO", aProdutos[z][2])

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

//Se der tudo certo ou algum erro ira aparecer mensagem pro usuario
	if lOk
		FWAlertSuccess("Voce é o cara","Protheuzou")
	else
		FWAlertError(aErro[6],"Erro vc nao protheouzou")
	endif

	RESET ENVIRONMENT

return(lRet)
