#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'

//-------------------------------------------------------------------
/*/                                                   {Protheus.doc} MAT410
Rotina automatica do cadastro do pedidos de venda
@author Kayke
@since 15/06/2023
@version 22.10
/*/
//-------------------------------------------------------------------
User function MAT4(oTela,cProduto,nOpr)
	Local nAux 			   := 0
	Local x                := 0
	Local z                := 0
	Local cLogMVCAuto	   := ""
	Local aProdutos        := {}
	Local aCabec           := {}
	Local aItens           := {}
	Local aLinhas          := {}
	// Local nTotal    	:= 0
	// Local aPedidos      := {}
	Private lMsErroAuto    := .f.
	Private lMSHelpAuto    := .T.
	Private lAutoErrNoFile := .T.
	Private cMarca         := oTela:Mark()


	//======= Array de produtos =========\\
	aadd(aProdutos, {cProduto, 10.00, 100.00, 1000.00, "502"})

//Se for inclusão ( insert )
	if nOpr == 3

		//======= Cabeçalho do pedidos de venda ========\\
		// aadd(aCabec , {"C5_NUM"    , GETSXENUM("SC5","C5_NUM"),}) //-----> Numero do pedido
		aadd(aCabec , {"C5_TIPO"   , "N"                      ,}) //-----> Tipo do pedido
		aadd(aCabec , {"C5_CLIENTE", "01"                     ,}) //-----> Cliente do pedido
		aadd(aCabec , {"C5_LOJACLI", "01"                     ,}) //-----> Loja do cliente
		aadd(aCabec , {"C5_LOJAENT", "01"                     ,}) //-----> Loja de entrega
		aadd(aCabec , {"C5_CONDPAG", "001"                    ,}) //-----> Condição de pagamento

		//======= Grid do pedidos de venda ========\\
		For x = 1 to LEN(aProdutos)
			aLinhas := {}

			aadd(aLinhas, {"C6_ITEM "  , StrZero(x,2)             ,}) //-----> Item do pedido
			aadd(aLinhas, {"C6_PRODUTO", aProdutos[x][1]          ,}) //-----> Produto do pedido
			aadd(aLinhas, {"C6_QTDVEN" , aProdutos[x][2]          ,}) //-----> Quantidade de produtos
			aadd(aLinhas, {"C6_PRCVEN" , aProdutos[x][3]          ,}) //-----> Preço de venda
			aadd(aLinhas, {"C6_VALOR"  , aProdutos[x][4]          ,}) //-----> Valor
			aadd(aLinhas, {"C6_TES"    , aProdutos[x][5]          ,}) //-----> Tipo de saida

			aadd(aItens , aLinhas)

		NEXT

		MsExecAuto({|x,y,z| MATA410(x, y, z)}, aCabec, aItens, nOpr)

	endif

//Se for Alteração( Update )
	if nOpr == 4

		Begin Transaction

			DBSelectArea("SC5")
			DBSetOrder(1)
			dbGoTop()

			While  ("SC5")->(!EoF())
				If oTela:IsMark(cMarca)
					If SC5->(DbSeek(xFilial( 'SC5' )+SC5->C5_NUM))
						//Caso esteja marcado
						aCabec:= {}
						aadd(aCabec, {"C5_NUM",     SC5->C5_NUM,      Nil})

						DBSelectArea("SC6")
						DBSetOrder(1)
						dbSeek(xFilial("SC6")+SC5->C5_NUM)

						if RecLock( 'SC6' , .F.)
							aLinhas := {}
							aadd(aLinhas, {"C6_ITEM"   , GetSXENum( 'SC6' , 'C6_ITEM') 	      , Nil})
							aadd(aLinhas, {"AUTDELETA" , "N"                                  , Nil})
							aadd(aLinhas, {"C6_PRODUTO", aProdutos[1][1]                      , NIL}) //-----> Produto do pedido
							aadd(aLinhas, {"C6_QTDVEN" , aProdutos[1][2]                      , NIL}) //-----> Quantidade de produtos
							aadd(aLinhas, {"C6_PRCVEN" , aProdutos[1][3]                      , NIL}) //-----> Preço de venda
							aadd(aLinhas, {"C6_VALOR"  , aProdutos[1][4]                      , NIL}) //-----> Valor
							aadd(aLinhas, {"C6_TES"    , aProdutos[1][5]                      , NIL}) //-----> Tipo de saida
							aItens:= {}
							aadd(aItens,aLinhas)
						Endif

						MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,nOpR)

						If (lMsErroAuto)
							aLogAuto := GetAutoGRLog()
							For nAux := 1 To Len(aLogAuto)
								If "Invalido" $ aLogAuto[nAux]
									cLogMVCAuto += Alltrim(aLogAuto[nAux]) + CRLF
								EndIf
							Next
							RollBackSX8()
							DisarmTransaction()
						Else
							ConfirmSX8()
						EndIf

					endif
				ENDIF
				("SC5")->(DbSkip())
			EndDo

		End Transaction
		//Caso houver erros
		If (lMsErroAuto)
			FwAlertInfo("Erro: " + cLogMVCAuto,"TOTVS")
		else
			FWAlertSuccess("O usuario Fez uma inclusão automatica de um produto no pedido de venda ","Inclusão automatica com sucesso")
		endif
	endif
Return
