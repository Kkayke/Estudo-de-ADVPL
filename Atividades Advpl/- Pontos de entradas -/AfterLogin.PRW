<<<<<<< HEAD
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} AfterLogin
Ponto de entrada que ira fazer uma a��o apos o login de user
@type Ponto de entrada
@version
@author Kayke
@since 05/06/2023
/*/
User function AfterLogin()
	Local cUser  := UsrRetName(RETCODUSR()) //Fun��o UsrRetName ira chamar o nome do usuario pelo codigo buscado	Local cUser2 := GetMV("LG_SAUDA") // Parametro feito com 2 usuarios que ser�o logados

	If nModulo == 5 .AND. cUser $ cUser2 // Se for o modulo 5(Fatureamento) e o cUser compara com o cuser2
		FWAlertSuccess("Ol� "+cUser +" Seja muito bem vindo","Bem Vindo")
	EndIf

Return
