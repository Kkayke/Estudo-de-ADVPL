#INCLUDE "TOTVS.CH"

User Function relatu()

	Local oRelato
	Private cPerg := PadR('CRMR01FF',10)
	//Retorna um alias para ser utilizado no record set definido em PadR()
	Private cAlias := GetNextAlias()
	Private oSection1

	// Primeiros abriremos um browse para fazer as perguntas
	If Pergunte(cPerg, .T.)
		oRelato := ReportDef()

		// Tela de impressÃ£o do relatÃ³rio
		oRelato:PrintDialog()
	EndIf
Return

Static Function ReportDef()

	Local oReport

	oReport := TReport():New(cPerg,'RelaÃ§Ã£o de clientes',cPerg,{||ReportPrint()},,.T.)

	// Define a orientaÃ§Ã£o de pÃ¡gina do relatÃ³rio como Paisagem
	oReport:SetLandScape(.T.)

	// Define se serÃ¡ permitida a alteraÃ§Ã£o dos parÃ¢metros do relatÃ³rio
	oReport:HideParamPage()

	oSection1 := TRSection():New(oReport,"Relatorio de usuarios", {cAlias})
	IF(MV_PAR05 <> 1)
		TRCell():New(oSection1, 'Z1_FILIAL', cAlias)
		TRCell():New(oSection1, 'Z1_IDCLI' , cAlias)
		TRCell():New(oSection1, 'Z1_EMAIL' , cAlias)
		TRCell():New(oSection1, 'Z1_PRNOME', cAlias)
		TRCell():New(oSection1, 'Z1_UTNOME', cAlias)
		TRCell():New(oSection1, 'Z1_PAIS'  , cAlias)
		TRCell():New(oSection1, 'Z1_GENERO', cAlias)
		TRCell():New(oSection1, 'Z1_IPREDE', cAlias)
	ELSE
		TRCell():New(oSection1, 'Z1_FILIAL', cAlias)
		TRCell():New(oSection1, 'Z1_IDCLI' , cAlias)
		TRCell():New(oSection1, 'Z1_PAIS'  , cAlias)
	ENDIF

Return oReport

static function ReportPrint()

	// 1- primeiro valida como vai ser inprimido os dados
	IF(MV_PAR05 <> 1)

		BeginSql Alias cAlias
                SELECT
                    Z1_FILIAL,
                    Z1_IDCLI,
                    CONVERT(varchar(5000),Z1_EMAIL) Z1_EMAIL,
                    Z1_PRNOME,
                    Z1_UTNOME,
                    Z1_PAIS,
                    Z1_GENERO,
                    Z1_IPREDE
                FROM
                    %Table:SZ1% SZ1
                WHERE Z1_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                AND   Z1_PAIS BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                AND SZ1.%NotDel%

		ENDSQL

	ELSE

		BeginSql Alias cAlias
                SELECT
                    Z1_FILIAL,
                    COUNT(Z1_IDCLI) Z1_IDCLI,
                    Z1_PAIS
                FROM
                    %Table:SZ1% SZ1
                WHERE Z1_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
                AND   Z1_PAIS BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
                AND SZ1.%NotDel%
                GROUP BY Z1_FILIAL,
                        Z1_PAIS
                ORDER BY Z1_PAIS

		ENDSQL

	ENDIF


	// 2 - impressÃ£o do relatÃ³rio
	oSection1:Print()
return

