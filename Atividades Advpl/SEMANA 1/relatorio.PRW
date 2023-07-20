#INCLUDE "TOTVS.CH"
#INCLUDE 'REPORT.CH'

User Function rel()

	Local oRelato
	Private cPerg := PadR('RESP0505',10)
	//Retorna um alias para ser utilizado no record set definido em PadR()
	Private cAlias := GetNextAlias()

	oRelato := ReportDef()

	// Tela de impressão do relatório
	oRelato:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Private oSection1
	// Primeiros abriremos um browse para fazer as perguntas
	Pergunte(cPerg, .T.)

	oReport:= TReport():New(cPerg,'Teste de relatorio',cPerg,{|oReport|ReportPrint(oReport,cAlias)},'123')

	// Define a orientação de página do relatório como Paisagem
	oReport:SetLandScape(.T.)

	// Define se será permitida a alteração dos parâmetros do relatório
	oReport:HideParamPage()

	oSection1 := TRSection():New(oReport,"????? ??? ???? ??? ???? ", {cAlias})
	TRCell():New(oSection1, 'ZZ1_CODIGO', cAlias)
	TRCell():New(oSection1, 'ZZ1_NOME', cAlias)
	TRCell():New(oSection1, 'ZZ1_TIPOCC', cAlias)
	TRCell():New(oSection1, 'ZZ1_CEL', cAlias)
	TRCell():New(oSection1, 'ZZ1_CC', cAlias)

Return oReport

static function ReportPrint(oReport,cAlias,cOrdem)

	local oSection1 := oReport:Section(1)

	oSection1:BeginQuery()

	BeginSql Alias cAlias
            SELECT
                ZZ1_CODIGO,
                ZZ1_NOME,
                ZZ1_AGENC,
                ZZ1_CC,
                ZZ1_TIPOCC
            FROM
            %Table:ZZ1%
            WHERE D_E_L_E_T_ = ' '
	EndSql

	oSection1:EndQuery()

	oSection1:Print()

return
