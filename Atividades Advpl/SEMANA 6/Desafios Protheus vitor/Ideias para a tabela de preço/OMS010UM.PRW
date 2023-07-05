#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"
#Include "TOPCONN.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ExecAuto em MVC
Rotina automatica em tela mvc
@author  Kayke
@since   15/06/2023
@version 1.0
/*/
//------------------- ------------------------------------------------

User function OMS0()
	Local cCombo
	Local oCombo
	Local aItens := {}
	local cQuery   := ""
	Local x := 0

	If (!IsBlind())
		PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'
	EndIf

	cQuery := " SELECT "                                        + CRLF
	cQuery += "     B1_COD, "                                   + CRLF
	cQuery += "     B1_DESC "                                   + CRLF
	cQuery += " FROM "                                          + CRLF
	cQuery += "" + RetSQLName('SB1') + " SB1 "                  + CRLF
	TCQuery cQuery New Alias "QRY_SB1"

	For x = 1 to LEN("QRY_SB1")

		aadd(aItens,{QRY_SB1->B1_COD,QRY_SB1->B1_DESC})
		// aadd(aItens,{QRY_SB1->B1_DESC ,aProdutos})

		DBSkip()

	Next
	oMsDialog := MSDialog():New(180,180,550,500,'Escolha o item que deseja incluir na tabela',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	cCombo:= AllTrim(aItens[1][2])

	oCombo:= TComboBox():New(02,02,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItens,100,20,oMsDialog,,{||Alert('Mudou item da combo')},,,,.T.,,,,,,,,,'cCombo')

	oTButton := TButton():New( 155, 002, "Confirmar",oMsDialog,{||U_oms1(cProduto)}, 40,30,,,.F.,.T.,.F.,,.F.,,,.F. )

	oMsDialog:ACTIVATE()
	U_oms1(cProduto)

	If (!IsBlind())

		RESET ENVIRONMENT

	ENDIF

Return
