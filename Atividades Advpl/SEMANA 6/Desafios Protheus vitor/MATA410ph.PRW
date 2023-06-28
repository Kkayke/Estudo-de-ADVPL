#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} MAT410
Rotina automatica do cadastro do pedidos de venda
@author  Kayke
@since 15/06/2023
@version 22.10
/*/
//-------------------------------------------------------------------
User function MAT4(oTela,cProduto,nOpr)
	Local x := 0
	Local aProdutos := {}
	Local aCabec  := {}
	Local aItens  := {}
	Local aArea   := GetArea()
	Local aLinhas := {}
	Local lRet    := .T.
	Private lMsErroAuto   := .f.

	//======= Array de produtos =========\\
	aadd(aProdutos,{cProduto,10.00,100.00,1000.00,"502"})

	If (!IsBlind())
		PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'
	EndIf

	oModel := FWLoadModel("MATA410")

	if nOpr == 3
		//======= Cabeçalho do pedidos de venda ========\\
		aadd(aCabec , {"C5_NUM"    , GETSXENUM("SC5","C5_NUM"),}) //-----> Numero do pedido
		aadd(aCabec , {"C5_TIPO"   , "N"                      ,}) //-----> Tipo do pedido
		aadd(aCabec , {"C5_CLIENTE", "01"                     ,}) //-----> Cliente do pedido
		aadd(aCabec , {"C5_LOJACLI", "01"                     ,}) //-----> Loja do cliente
		aadd(aCabec , {"C5_LOJAENT", "01"                     ,}) //-----> Loja de entrega
		aadd(aCabec , {"C5_CONDPAG", "001"                    ,}) //-----> Condição de pagamento

		//======= Grid do pedidos de venda ========\\
		For x = 1 to LEN(aProdutos)
			aLinhas := {}

			aadd(aLinhas, {"C6_ITEM "  ,StrZero(x,2)   ,})		  //-----> Item do pedido
			aadd(aLinhas, {"C6_PRODUTO",aProdutos[x][1],})		  //-----> Produto do pedido
			aadd(aLinhas, {"C6_QTDVEN" ,aProdutos[x][2],})		  //-----> Quantidade de produtos
			aadd(aLinhas, {"C6_PRCVEN" ,aProdutos[x][3],})		  //-----> Preço de venda
			aadd(aLinhas, {"C6_VALOR"  ,aProdutos[x][4],})		  //-----> Valor
			aadd(aLinhas, {"C6_TES"    ,aProdutos[x][5],})		  //-----> Tipo de saida

			AAdd(aItens,aLinhas)

		NEXT

		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, nOpr)

	endif

	if nOpr == 4
		If	SC5->(MsSeek(xFilial('SC5')+SC5->C5_NUM))
			DBSetOrder(1)

			aadd(aCabec , {"C5_NUM",SC5->C5_NUM,})

			aLinhas := {}
			aadd(aLinhas, {"C6_ITEM "  ,GETSXENUM("SC6","C6_ITEM"),})
			aadd(aLinhas, {"C6_PRODUTO",aProdutos[1][1],})		  //-----> Produto do pedido
			aadd(aLinhas, {"C6_QTDVEN" ,aProdutos[1][2],})		  //-----> Quantidade de produtos
			aadd(aLinhas, {"C6_PRCVEN" ,aProdutos[1][3],})		  //-----> Preço de venda
			aadd(aLinhas, {"C6_VALOR"  ,aProdutos[1][4],})		  //-----> Valor
			aadd(aLinhas, {"C6_TES"    ,aProdutos[1][5],})		  //-----> Tipo de saida

			AAdd(aItens,aLinhas)

			MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,nOpr)

			//Caso houver erros
			If (lMsErroAuto)
				MostraErro()
			else
				ConfirmSX8()
				FWAlertSuccess("O usuario Fez uma inclusão automatica de um produto no pedido de venda ","Inclusão automatica com sucesso")
			endif

			If (!IsBlind())
				RESET ENVIRONMENT
			EndIf

			RestArea(aArea) // RESTAURAÇÃO DA ÁREA ANTERIO
		endif
	endif

Return(lRet)
