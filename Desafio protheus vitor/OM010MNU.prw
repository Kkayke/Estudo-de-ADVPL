#include 'totvs.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} Ponto de entrada Da tabela de preço
Criando um botão para inclusão sem precisa executar direto no fonte
@author  Kayke
@since   19/06/2023
@version 22.10
/*/
//-------------------------------------------------------------------
User function OM010MNU()
	Local cProduto := "1"

	aadd(aRotina,{'Incluir automatico',"u_OMS1("+cProduto+")",0,3,0,NIL})     //------ Botão que ira aparecer na tabela


return
