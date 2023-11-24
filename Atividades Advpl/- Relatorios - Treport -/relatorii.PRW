<<<<<<< HEAD
#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'

User function relat()

	Local oRelato

	//Retorna um alias para ser utilizado no record set definido em PadR()
	Private cAlias  := GetNextAlias()
	Private cPerg   := PadR( 'relatorii' ,10)
	oRelato         := ReportDef()

	// Tela de impressão do relatório
	oRelato:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Private oSection1

	Pergunte(cPerg, .T.)
	oReport         := TReport()  :New(cPerg    , 'Teste de relatorio'           , cPerg, {|oReport|ReportPrint(oReport,cAlias)}, '123')

	// Define a orientação de página do relatório como Paisagem
	oReport:SetLandScape(.T.)

	// Define se será permitida a alteração dos parâmetros do relatório
	oReport:HideParamPage()

	oSection1       := TRSection():New(oReport  , "Relatorio em formato Treport ")

	TRCell():New(oSection1, 'Z1_FILIAL', "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_FILIAL,1,30)})
	TRCell():New(oSection1, 'Z1_IDCLI' , "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_IDCLI,1,30)})
	TRCell():New(oSection1, 'Z1_PRNOME', "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_PRNOME,1,30)})
	TRCell():New(oSection1, 'Z1_UTNOME', "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_UTNOME,1,30)})
	TRCell():New(oSection1, 'Z1_PAIS'  , "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_PAIS,1,30)})
	TRCell():New(oSection1, 'Z1_EMAIL' , "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_EMAIL,1,30)})
	TRCell():New(oSection1, 'Z1_GENERO', "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_GENERO,1,30)})
	TRCell():New(oSection1, 'Z1_IPREDE', "SZ1",,, 30, , {|| SUBSTR( (cAlias)->Z1_IPREDE,1,30)})

Return oReport

static function ReportPrint(oReport,cAlias,cOrdem)
	local oSection1 := oReport:Section(1)
	local cIDCLI    := SPACE(10)
	Local _aRet1    := {}
	Local aPergs1   := {}

	aadd(aPergs1, {1 , "Informe o usuario", cIDCLI, "", ".T.", "", ".T.", 60, .T.})

	If ParamBox(aPergs1, "Nova Data de Vencimento", _aRet1,,,,750,1000, /*oMainDlg*/,,.F.,.F.)
		IDCLI           := _aret1[1]

	EndIf
	oSection1:BeginQuery()
	BEGINSQL ALIAS cAlias

        SELECT Z1_IDCLI,
                Z1_PRNOME,
                Z1_UTNOME,
                Z1_PAIS,
                Z1_EMAIL,
                Z1_GENERO,
                Z1_IPREDE
        FROM %table:SZ1%
			WHERE
				Z1_IDCLI = %exp:IDCLI%


	ENDSQL
	oSection1:EndQuery()


	oSection1:Print()

return
