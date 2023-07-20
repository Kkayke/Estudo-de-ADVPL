#INCLUDE 'TOTVS.CH'
#INCLUDE 'REPORT.CH'

User function CriaPdf()

	private oReport
	private cAlias := getNextAlias()

	oReport := xPrintRel()
	oReport:PrintDialog()

Return

/*/{Protheus.doc} xPrintRel
	Imprimir Relatório

	@author  Nome
	@example Exemplos
	@param   [Nome_do_Parametro],Tipo_do_Parametro,Descricao_do_Parametro
	@return  Especifica_o_retorno
	@table   Tabelas
	@since   20-07-2023
/*/
Static Function xPrintRel()

	local oReport
	local oSection1

	oReport    := TReport():New("Relatorio em PDF",'Relatorio PDF',{|oReport|ReportPrint(oReport,cAlias)})
	oReport:SetLandScape(.T.)
	oReport:SetTotalInLine(.F.)
	oReport:HideParamPage()

	oSection1 := TRSection():New(oReport,cAlias)
	TRCell():New(oSection1, 'A1_COD', cAlias)
	TRCell():New(oSection1, 'A1_NOME',, cAlias)
	TRCell():New(oSection1, 'A1_LOJA',, cAlias)
	TRCell():New(oSection1, 'A1_TIPO', cAlias)
	TRCell():New(oSection1, 'A1_ESTADO', cAlias)
	TRCell():New(oSection1, 'A1_MUN', cAlias)
	TRCell():New(oSection1, 'A1_END', cAlias)

Return oReport

static function ReportPrint(oReport,cAlias,cOrdem)
	local oSection1b := oReport:Section(1)

	oSection1b:BeginQuery()
	BeginSql Alias cAlias
                SELECT
                    A1_COD,
					A1_NOME,
					A1_LOJA,
					A1_TIPO,
					A1_ESTADO,
					A1_MUN,
					A1_END
                FROM
                    %Table:SA1% SA1
			WHERE D_E_L_E_T_ = ' '
	EndSql

	oSection1b:EndQuery()

	// oReport:SetMeter((cAlias)->(RecCount()))

	oSection1b:Print()
Return
































return
