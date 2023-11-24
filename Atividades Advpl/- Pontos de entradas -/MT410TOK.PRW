<<<<<<< HEAD
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT410TOK
Ponto de entrada que vai validar uma informação para o usuario
@type Ponto de entrada
@version 0.1
@author Kayke
@since 05/06/2023
/*/

user function MT410TOK()

	local lRet    := .T.
	Local aArea   := GetArea() // Ira abrir um ambiente com getArea
	local dData   := M->C5_EMISSAO +2 //Aqui sera buscado a informação dado na memoria, ou seja a data que ira conter pelo usuario
	Local aAreaC5 := SC5->(GetArea()) //Vamos abrir um ambiente para o SC5

	If INCLUI
		FWAlertInfo(UsrFullName(__cUserID) + ", o pedido: " + M->C5_NUM+ ", Deve ser faturado até:"+DToC(DataValida(dData,.T.)) , "Alerta")
	EndIf

	RestArea(aAreaC5) //Ira fechar o ambiente com informações dadas
	RestArea(aArea) //Ira fechar o ambiente

return lRet
