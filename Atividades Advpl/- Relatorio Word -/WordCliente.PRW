#INCLUDE 'TOTVS.CH'
#INCLUDE 'MSOLE.CH'

#Define oleWdFormatDocument "0"
#Define oleWdFormatHTML "102"
#Define oleWdFormatPDF "17"

User function criarWord()

	Local cTitulo := "Impressão dos clientes em Word"

	If !perguntaDiretorio()
		FWAlertError("Impressão cancelada.","TOTVS")
		Return
	EndIf

	FWMsgRun(, {||imprimeWord() }, cTitulo, "Gerando o documento")

Return

static function imprimeWord()
	Local oWord
	Local cCaminho := Alltrim(MV_PAR01)

	IF CpyS2T("Dot\clientes.docx",cCaminho )

		oWord := OLE_CreateLink( "TMsOleWord97" )
		OLE_SetProperty( oWord, oleWdVisible, .F. )
		OLE_SetProperty( oWord, oleWdPrintBack, .F. )

		OLE_NewFile(oWord,cCaminho +"clientes.docx")

		DbSelectArea('SA1')

		OLE_SetDocumentVar(oWord, "w_A1_COD",    SA1->A1_COD)
		OLE_SetDocumentVar(oWord, "w_A1_NOME",   SA1->A1_NOME)
		OLE_SetDocumentVar(oWord, "w_A1_LOJA",   SA1->A1_LOJA)
		OLE_SetDocumentVar(oWord, "w_A1_TIPO",   SA1->A1_TIPO)
		OLE_SetDocumentVar(oWord, "w_A1_ESTADO", SA1->A1_ESTADO)
		OLE_SetDocumentVar(oWord, "w_A1_MUN",    SA1->A1_MUN)
		OLE_SetDocumentVar(oWord, "w_A1_END",    SA1->A1_END)

		OLE_UpdateFields(oWord)

		if MV_PAR02 == "1"
			OLE_SaveAsFile( oWord, cCaminho +"clientes.docx")
		else
			OLE_SaveAsFile( oWord, cCaminho + "clientes.pdf", '', '', .F., oleWdFormatPDF)
		endif
		// Fecha o documento.
		OLE_CloseFile(oWord)

		//Fechando o arquivo e o link
		OLE_CloseLink(oWord)

		// // SE FOR WORD, ABRE O ARQUIVO
		if MV_PAR02 == "1"
			ShellExecute("open","clientes.docx","",cCaminho,1)
		else
			ShellExecute("open","clientes.pdf","",cCaminho,1)
		endif
	Else
		FWAlertError("Arquivo nao copiado","TOTVS")
	EndIf

return

static function perguntaDiretorio()
	Local aPergs := {}
	local lRet   := .F.

	aAdd(aPergs, {6, "Dir. Salvar", Space(90), "", , "", 90, .T., "Diretórios", "C:\", GETF_LOCALHARD+GETF_RETDIRECTORY})
	aAdd(aPergs, {2, "Tipo Arquivo", "1", {"1=Word", "2=PDF"}, 90, ".T.", .T.})

	If ParamBox(aPergs, "",,,,,,,,, .F., .F.)
		lRet := .T.
	EndIf

Return lRet
