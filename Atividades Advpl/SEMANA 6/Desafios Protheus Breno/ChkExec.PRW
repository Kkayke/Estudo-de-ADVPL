<<<<<<< HEAD
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'



User function ChkExec()
	Local aArea := GetArea()
	lRet := .T.
	Local cFuncao := ParamIxb
	local cUser := USRRETNAME(RETCODUSR())


	If !Empty(cFuncao)

		FWAlertSuccess("Olá "+cUser +" Você esta na rotina: "+StrTran(cFuncao,"()",),"Bem Vindo")

	EndIf

	RestArea(aArea)

return lRet



=======
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'



User function ChkExec()
	Local aArea := GetArea()
	lRet := .T.
	Local cFuncao := ParamIxb
	local cUser := USRRETNAME(RETCODUSR())


	If !Empty(cFuncao)

		FWAlertSuccess("Olá "+cUser +" Você esta na rotina: "+StrTran(cFuncao,"()",),"Bem Vindo")

	EndIf

	RestArea(aArea)

return lRet



>>>>>>> 156c02d199a07062260049be24aed3b38441b711
