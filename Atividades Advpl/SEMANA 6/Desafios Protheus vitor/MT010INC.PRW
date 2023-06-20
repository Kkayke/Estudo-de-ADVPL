#INCLUDE 'TOTVS.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} Ponto de entrada do cadastro de produto
Após inclusão de um produto no cadastro de produto
@author  Kayke
@since   19/06/2023
@version 22.10
/*/
//-------------------------------------------------------------------
User Function MT010INC()
	Local aArea := GetArea()

	Local cProduto := M->B1_COD		//----> Pegando Codigo que esta em memory

	u_OMS1(cProduto)				//----> Chamando variavel para a outra User function(Inclusão da tabela de preço)

	RestArea(aArea)

Return(.T.)
