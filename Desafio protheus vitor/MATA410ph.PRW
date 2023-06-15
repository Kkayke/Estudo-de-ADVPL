#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} ExecAuto
Utilizando execAuto para rotina automatica
@author  Kayke
@since 15/06/2023
@version 1.0
/*/
//-------------------------------------------------------------------
User function MAT4()
	Local x := 0
	Local aProdutos := {}
	Local aCabec  := {} // Pai
	Local aItens  := {} // filhos
	Local aArea   := {} // ARMAZENA ÁREA CORRENTE
	Local aLinhas := {}
	Local nOpr    := 3
	Local lRet := .F.
	Private lMsErroAuto   := .f.

	//Adicionando produtos 1
	aadd(aProdutos,{"1",10.00,100.00,1000.00,"502"})
	//Adicionando produtos 2
	aaDD(aProdutos,{"2",10.00,100.00,1000.00,"502"})

	aArea:= GetArea()

	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'

	oModel := FWLoadModel("MATA410 ")

	//Definindo informações do pai, vulgo cabeçalho
	aadd(aCabec , {"C5_NUM"    , GETSXENUM("SC5","C5_NUM"),})
	aadd(aCabec , {"C5_TIPO"   , "N"                      ,})
	aadd(aCabec , {"C5_CLIENTE", "01"                     ,})
	aadd(aCabec , {"C5_LOJACLI", "01"                     ,})
	aadd(aCabec , {"C5_LOJAENT", "01"                     ,})
	aadd(aCabec , {"C5_CONDPAG", "001"                    ,})

	//filhos do pai(Grid do cabeçalho)
	For x = 1 to LEN(aProdutos)
		aLinhas := {}

		aadd(aLinhas, {"C6_ITEM "  ,StrZero(x,2)   ,})
		aadd(aLinhas, {"C6_PRODUTO",aProdutos[x][1],})
		aadd(aLinhas, {"C6_QTDVEN" ,aProdutos[x][2],})
		aadd(aLinhas, {"C6_PRCVEN" ,aProdutos[x][3],})
		aadd(aLinhas, {"C6_VALOR"  ,aProdutos[x][4],})
		aadd(aLinhas, {"C6_TES"    ,aProdutos[x][5],})

		AAdd(aItens,aLinhas)

	NEXT

	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, nOpr)

	If (lMsErroAuto)
		MostraErro()
		RollBackSX8()
		ConOut(Repl("-+-", 80))
		ConOut(PadC("Não foi possivel protheuzar", 80))
		ConOut(PadC("Execução: " + Time(), 80))
		ConOut(Repl("-+-", 80))
	else
		ConfirmSX8()
		FWAlertSuccess("Foi possivel protheuzar","Protheuzou com sucesso")
	endif

	RESET ENVIRONMENT

	RestArea(aArea) // RESTAURAÇÃO DA ÁREA ANTERIOR

Return(lRet)
