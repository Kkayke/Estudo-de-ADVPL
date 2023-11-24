<<<<<<< HEAD
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
/*/{Protheus.doc} ChkExec
Funчуo que retorna ao usuario uma mensagem informando qual rotina ele estс
@type function
@version  
@author kayke
@since 05/07/2023
@return variant, return_description
/*/
User function ChkExec()
	Local aArea := GetArea()
	lRet := .T.
	Local cFuncao := ParamIxb
	local cUser := USRRETNAME(RETCODUSR())

	If !Empty(cFuncao)

		FWAlertSuccess("Olс "+cUser +" Vocъ esta na rotina: "+StrTran(cFuncao,"()",),"Bem Vindo")

	EndIf

	RestArea(aArea)

return lRet

