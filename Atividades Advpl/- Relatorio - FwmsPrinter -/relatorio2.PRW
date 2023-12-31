#INCLUDE 'TOTVS.CH'

#Include 'TOPCONN.CH'
#INCLUDE "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
//AQUI TERA ALGUMAS DEFINI�OES

//ALINHAMENTOS DA COLUNA
#Define PAD_LEFT 2
#Define PAD_RIGHT 2
#Define PAD_CENTER 2

//DEFININDO CORES
#Define  COR_CINZA RGB(180, 180, 180)
#Define  COR_PRETO RGB(000, 000, 000)
#Define  COR_AZUL RGB(255, 255, 255)
//COLUNAS DE QUAIS INFORMA��ES
#Define COL_USER      005
#Define COL_EMAIL     100
#Define COL_CIDADE    200
#Define COL_ESTADO    300
#Define COL_ENDERECO  400
#Define COL_IDADE     500

User function rela01()

	Local aArea := GetArea()

	If MsgYesNo("Deseja gerar um relatorio de usuarios?", "Aten��o")
		processa({||fMontaRel()},"Processando....")

	endIf

	RestArea(aArea)

RETURN



// Fun��o que ira montar o relatorio agora kkkk
Static function fMontaRel()
	local cCaminho := ""
	local cArquivo := ""
	local cQuery   := ""
	local nAtual   := 0
	local nTotal   := 0
	local cRet     := ""
//Agora tera linha e colunas
	Private nLinAtu   := 000
	Private nTamLin   := 015
	Private nLinFin   := 820
	Private nColIni   := 010
	Private nColFin   := 550
	Private nColMeio  := (nColFin-nColIni)/2

//Objeto de Impress�o
	private oImpressa

//Fontes
	Private cNomeFont := "Arial"
	Private oFontDet  := TFont():New(cNomeFont, 9, -10, .T., .F., 5, .T., 5, .T., .F.)
	Private oFontDetN := TFont():New(cNomeFont, 9, -10, .T., .T., 5, .T., 5, .T., .F.)
	Private oFontTit  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)

//Caminho e pasta temporaria
	cCaminho := GetTempPath(.T., .F.)
	conout("Path pasta temporaria client: " + cRet)         // Resultado: "C:\Users\username\AppData\Local\Temp"

//Criando o fwmsPrinter
	oImpressa := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oImpressa, "", , , , .T.)

//Setando os atributos necess�rios do relat�rio
	oImpressa:SetResolution(72)
	oImpressa:SetPortrait()
	oImpressa:SetPaperSize(DMPAPER_A4)
	oImpressa:SetMargin(60, 60, 60, 60)
	oImpressa:SetLandScape(.F.)
//Imprime o cabe�alho
	fImpCab()

//Montando a consulta
	cQuery := " SELECT "                                       + CRLF
	cQuery += "     LAT_STATUS, "                              + CRLF
	cQuery += "   CONVERT(varchar(5000),LAT_EMAIL) LAT_EMAIL, " + CRLF
	cQuery += "     LAT_END, "                                  + CRLF
	cQuery += "     LAT_MARCA, "                                + CRLF
	cQuery += "     LAT_CIDADE, "                               + CRLF
	cQuery += "     LAT_NASCI "                                + CRLF
	cQuery += " FROM "                                         + CRLF
	cQuery += "     " + RetSQLName('LAT') + " LAT "            + CRLF
	cQuery += " WHERE "                                        + CRLF
	cQuery += "     LAT_FILIAL = '" + FWxFilial('LAT') + "' "   + CRLF
	cQuery += "     AND D_E_L_E_T_ = ' ' "                     + CRLF
	cQuery += " ORDER BY "                                     + CRLF
	cQuery += "     LAT_STATUS "                                 + CRLF
	TCQuery cQuery New Alias "QRY_LAT"

//Conta o total de registros, seta o tamanho da r�gua, e volta pro topo
	Count To nTotal
	ProcRegua(nTotal)
	QRY_LAT->(DbGoTop())
	nAtual := 0

//Enquanto houver registros
	While ! QRY_LAT->(EoF())
		nAtual++
		IncProc("Imprimindo usuarios " + QRY_LAT->LAT_STATUS + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")

//Se a linha atual mais o espa�o que ser� utilizado forem maior que a linha final, imprime rodap� e cabe�alho
		If nLinAtu + nTamLin > nLinFin
			//fImpRod()
			fImpCab()
		EndIf

//Imprimindo a linha atual
		oImpressa:SayAlign(nLinAtu, COL_USER, QRY_LAT->LAT_STATUS, oFontDet, 0050, nTamLin, COR_PRETO, PAD_LEFT, 0)
		oImpressa:SayAlign(nLinAtu, COL_EMAIL, QRY_LAT->LAT_EMAIL, oFontDet, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
		oImpressa:SayAlign(nLinAtu, COL_ENDERECO, QRY_LAT->LAT_END, oFontDet, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
		oImpressa:SayAlign(nLinAtu, COL_ESTADO , QRY_LAT->LAT_MARCA, oFontDet, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
		oImpressa:SayAlign(nLinAtu, COL_CIDADE, QRY_LAT->LAT_CIDADE, oFontDet, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
		oImpressa:SayAlign(nLinAtu, COL_IDADE, DtoC(sToD(QRY_LAT->LAT_NASCI)), oFontDet, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
		nLinAtu := nTamLin

		QRY_LAT->(DbSkip())
	EndDo
	QRY_LAT->(DbCloseArea())

//Se ainda tiver linhas sobrando na p�gina, imprime o rodap� final
	If nLinAtu <= nLinFin
		//fImpRod()
	EndIf

	//Mostrando o relat�rio
	oImpressa:Preview()
Return

/*---------------------------------------------------------------------*
| Func:  fImpCab                                                      |
| Desc:  Fun��o que imprime o cabe�alho                               |
*---------------------------------------------------------------------*/

	Static Function fImpCab()
    Local cTexto   := ""
    Local nLinCab  := 030

    //Iniciando P�gina
    oImpressa:StartPage()

    //Cabe�alho
    cTexto := "Rela��o de Grupos de Usuarios"
    oImpressa:SayAlign(nLinCab, nColMeio - 120, cTexto, oFontTit, 440, 20, COR_CINZA, PAD_CENTER, 0)

    //Cabe�alho das colunas
    nLinCab += nTamLin
    oImpressa:SayAlign(nLinCab +0, COL_USER, "Usuarios",oFontDetN, 040, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oImpressa:SayAlign(nLinCab, COL_EMAIL, "Email", oFontDetN, 050, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oImpressa:SayAlign(nLinCab, COL_CIDADE, "Cidade", oFontDetN, 0160, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oImpressa:SayAlign(nLinCab, COL_ESTADO, "Estado", oFontDetN, 0170, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oImpressa:SayAlign(nLinCab, COL_ENDERECO, "Endere�o", oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oImpressa:SayAlign(nLinCab, COL_IDADE, "Data de nascimento", oFontDetN, 0240, nTamLin, COR_PRETO, PAD_LEFT, 0)
	nLinCab += nTamLin

    //Atualizando a linha inicial do relat�rio
    nLinAtu := nLinCab + 3
	Return


