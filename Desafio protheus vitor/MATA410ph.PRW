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
	Local aProdutos := {}  // Produtos
	Local aCabec  := {}    // Cabeçalho
	Local aItens  := {}    // Grid
	Local aArea   := GetArea()
	Local aLinhas := {}
	Local nOpr    := 3     // Tipo de operação que sera realizada( Inclusão )
	Local lRet := .F.
	Private lMsErroAuto   := .f.

	//======= Adicionando produtos 1 =========\\
	aadd(aProdutos,{"1",10.00,100.00,1000.00,"502"})

	//======= Adicionando produtos 2 ==========\\
	aaDD(aProdutos,{"2",10.00,100.00,1000.00,"502"})

	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'

	oModel := FWLoadModel("MATA410 ")  //----> Carregando a rotina de pedidos de venda

	//======= Cabeçalho do pedidos de venda ========\\
	aadd(aCabec , {"C5_NUM"    , GETSXENUM("SC5","C5_NUM"),}) //-----> Numero do pedido
	aadd(aCabec , {"C5_TIPO"   , "N"                      ,}) //-----> Tipo do pedido
	aadd(aCabec , {"C5_CLIENTE", "01"                     ,}) //-----> Cliente do pedido
	aadd(aCabec , {"C5_LOJACLI", "01"                     ,}) //-----> Loja do cliente
	aadd(aCabec , {"C5_LOJAENT", "01"                     ,}) //-----> Loja de entrega
	aadd(aCabec , {"C5_CONDPAG", "001"                    ,}) //-----> Condição de pagamento

	//Loop que ira fazer um interate com o array, ira buscar informações dadas no array
	For x = 1 to LEN(aProdutos)
		aLinhas := {}

		aadd(aLinhas, {"C6_ITEM "  ,StrZero(x,2)   ,})		  //-----> Item do pedido
		aadd(aLinhas, {"C6_PRODUTO",aProdutos[x][1],})		  //-----> Produto do pedido
		aadd(aLinhas, {"C6_QTDVEN" ,aProdutos[x][2],})		  //-----> Quantidade de produtos
		aadd(aLinhas, {"C6_PRCVEN" ,aProdutos[x][3],})		  //-----> Preço de venda
		aadd(aLinhas, {"C6_VALOR"  ,aProdutos[x][4],})		  //-----> Valor
		aadd(aLinhas, {"C6_TES"    ,aProdutos[x][5],})		  //-----> Tipo de saida

		//Transferindo aLinhas para aProdutos
		AAdd(aItens,aLinhas)

	NEXT

	//========= Começando a inclusão automatica para o usuario ==============\\
	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, nOpr)
	//Caso houver erros
	If (lMsErroAuto)
		MostraErro()
		RollBackSX8()
		ConOut(Repl("-+-", 80))
		ConOut(PadC("Não foi possivel realizar a inclusão automatica", 80))
		ConOut(PadC("Execução: " + Time(), 80))
		ConOut(Repl("-+-", 80))
	else
		ConfirmSX8()
		FWAlertSuccess("O usuario Fez uma inclusão automatica na tabela de preço ","Inclusão automatica com sucesso")
	endif

	RESET ENVIRONMENT

	RestArea(aArea) // RESTAURAÇÃO DA ÁREA ANTERIOR

Return(lRet)
