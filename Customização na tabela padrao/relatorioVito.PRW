#INCLUDE "TOTVS.CH"
#INCLUDE "REPORT.CH"

User function relaV()
	Local oRelato
	Private cAlias
	Private cPerg   := PadR( 'relatorii' ,10)

	oRelato := ReportDef()
	oRelato:PrintDialog()

return

Static function ReportDef()
	local oBreak1
	local oReport
	local oSection1
	local oSection2
	local oSection3
	// local oBreak1

	oReport  := TReport():New("relaV", 'Relatorio dos fornecedores',cPerg, {|oReport|ReportPrint(oReport)}, '')
	oReport:lParamPage := .F.

	oSection1 := TRSection():New(oReport,"TESTE1",{"SF1"})

	TRCell():New(oSection1, "F1_EMISSAO", "SF1", , , , , {||SF1->F1_EMISSAO })
	TRCell():New(oSection1, "F1_EST"    , "SF1", , , , , {||SF1->F1_EST })
	TRCell():New(oSection1, "F1_VALBRUT", "SF1", , , , , {||SF1->F1_VALBRUT })
	TRCell():New(oSection1, "F1_DESCONT", "SF1", , , , , {||SF1->F1_DESCONT  })
	TRCell():New(oSection1, "F1_TIPO"   , "SF1", , , , , {||SF1->F1_TIPO })

	oSection2 := TRSection():New(oSection1,"TESTE2",{"SF1","cAlias"})

	TRCell():New(oSection2, "F1_FILIAL" ,"SF1", , , , , {||SF1->F1_FILIAL  })
	TRCell():New(oSection2, "F1_FORNECE","SF1", , , , , {||SF1->F1_FORNECE })
	TRCell():New(oSection2, "F1_LOJA"   ,"SF1", , , , , {||SF1->F1_LOJA })
	TRCell():New(oSection2, "F1_EST"    ,"SF1", , , , , {||SF1->F1_EST   })
	TRCell():New(oSection2, "A2_END"    , "SA2", , , , , {||(cAlias)->A2_END  })
	TRCell():New(oSection2, "A2_NR_END" , "SA2", , , , , {||(cAlias)->A2_NR_END })
	TRCell():New(oSection2, "A2_BAIRRO" , "SA2", , , , , {||(cAlias)->A2_BAIRRO })

	oSection3 := TRSection():New(oSection2,"TESTE3",{"SD1"})
	TRCell():New(oSection3, "D1_FILIAL" , "SD1", , , , , {||SD1->D1_FILIAL })
	TRCell():New(oSection3, "D1_ITEM"   , "SD1", , , , , {||SD1->D1_ITEM })
	TRCell():New(oSection3, "D1_COD"    , "SD1", , , , , {||SD1->D1_COD })
	TRCell():New(oSection3, "D1_DESC "  , "SD1", , , , , {||SD1->D1_DESC })
	TRCell():New(oSection3, "D1_UM"     , "SD1", , , , , {||SD1->D1_UM  })
	TRCell():New(oSection3, "D1_QUANT"  , "SD1", , , , , {||SD1->D1_QUANT })
	TRCell():New(oSection3, "D1_VUNIT"  , "SD1", , , , , {||SD1->D1_VUNIT})
	TRCell():New(oSection3, "D1_TOTAL"  , "SD1", , , , , {||SD1->D1_TOTAL })

	oBreak1 := TRBreak():New(oSection3,oSection3:Cell("D1_TOTAL"),,.T.)

	TRFunction():New( oSection3:Cell('D1_TOTAL'),NIL, 'SUM', oBreak1,,,, .F., .F. )


Return oReport


//Aqui tera um reportPrint que mostrara como sera imprimido
static function ReportPrint(oReport)
	local oStatement
	Local cFinalQuery
	Local cQuery := ""
	local oSection1 := oReport:Section(1)
	local oSection2 := oReport:Section(1):Section(1)
	local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local nY := 1


	//cQuery      := "SELECT A2_END, A2_NR_END, A2_BAIRRO FROM ? WHERE  AND A2_COD = ? AND A2_LOJA = ? AND D_E_L_E_T_ <> '*'"

	cQuery      += " SELECT A2_END, A2_NR_END, A2_BAIRRO, F1_EMISSAO, "
	cQuery      += " F1_EST, F1_VALBRUT, F1_DESCONT, F1_TIPO, F1_FORNECE, F1_LOJA, F1_EST, "
	cQuery      += " D1_FILIAL, D1_ITEM, D1_COD, D1_DESC, D1_UM, D1_QUANT, D1_VUNIT, D1_TOTAL "
	cQuery      += " FROM " + RetSqlName("SF1990") + " SF1 "
	cQuery      += " INNER JOIN " + RetSqlName("SD1990") + " SD1 "
	cQuery      += " ON SF1.F1_DOC = SD1.D1_DOC "
	cQuery      += " AND SF1.F1_SERIE = SD1.D1_SERIE "
	cQuery      += " AND SF1.F1_FORNECE = SD1.D1_FORNECE "
	cQuery      += " AND SF1.F1_LOJA= SD1.D1_LOJA "
	cQuery      += " INNER JOIN " + RetSqlName("SA2990") + " SA2 "
	cQuery      += " ON SF1.F1_FORNECE = SA2.A2_COD "
	cQuery      += " AND SF1.F1_LOJA = SA2.A2_LOJA "
	cQuery      += " WHERE SF1.F1_FILIAL  = ? "
	cQuery      += " AND SF1.F1_DOC = ? "
	cQuery      += " AND SF1.F1_SERIE = ? "
	cQuery      += " AND SF1.F1_FORNECE = ? "
	cQuery      += " AND SF1.F1_LOJA = ? "

	//oStatement:SetQuery(cQuery)
	oStatement  := FWPreparedStatement():New(cQuery)
	oStatement:SetString(nY++,FWxFilial("SF1"))
	oStatement:SetString(nY++,SF1->F1_DOC)
	oStatement:SetString(nY++,SF1->F1_SERIE)
	oStatement:SetString(nY++,SF1->F1_FORNECE)
	oStatement:SetString(nY++,SF1->F1_LOJA)
	cFinalQuery := oStatement:GetFixQuery()
	cAlias := MPSysOpenQuery(cFinalQuery)

	oReport:PrintText("----------------------------------------------------------------------------- DADOS DA NOTA --------------------------------------------------------------------------------")

	oSection1:Init()
	oSection1:Cell( 'F1_EMISSAO' ):SetValue( SF1->F1_EMISSAO )
	oSection1:Cell( 'F1_EST' ):SetValue( SF1->F1_EST )
	oSection1:Cell( 'F1_VALBRUT' ):SetValue( SF1->F1_VALBRUT )
	oSection1:Cell( 'F1_DESCONT' ):SetValue( SF1->F1_DESCONT )
	oSection1:Cell( 'F1_TIPO' ):SetValue( SF1->F1_TIPO )

	oSection1:Printline()
	oSection1:Finish()

	oReport:SkipLine()
	oReport:PrintText("------------------------------------------------------------------------- INFORMAÇÕES DO FORNECEDOR ----------------------------------------------------------------------")

	oSection2:Init()
	oSection2:Cell( 'F1_FILIAL' ):SetValue(SF1->F1_FILIAL )
	oSection2:Cell( 'F1_FORNECE' ):SetValue(SF1->F1_FORNECE )
	oSection2:Cell( 'F1_LOJA' ):SetValue( SF1->F1_LOJA )
	oSection2:Cell( 'F1_EST' ):SetValue(SF1->F1_EST )
	oSection2:Cell( 'A2_END' ):SetValue((cAlias)->A2_END )
	oSection2:Cell( 'A2_NR_END' ):SetValue((cAlias)->A2_NR_END )
	oSection2:Cell( 'A2_BAIRRO' ):SetValue((cAlias)->A2_BAIRRO )
	oSection2:PrintLine()
	oSection2:Finish()

	oReport:SkipLine()
	oReport:PrintText("------------------------------------------------------------------------ INFORMAÇÕES DO PRODUTO -------------------------------------------------------------------------")


	oSection3:Init()
	While cAlias ->(!Eof())
		oSection3:Cell( 'D1_FILIAL' ):SetValue(SD1->D1_FILIAL )
		oSection3:Cell( 'D1_ITEM' ):SetValue(SD1->D1_ITEM )
		oSection3:Cell( 'D1_COD' ):SetValue(SD1->D1_COD )
		oSection3:Cell( 'D1_DESC ' ):SetValue(SD1->D1_DESC )
		oSection3:Cell( 'D1_UM' ):SetValue(SD1->D1_UM )
		oSection3:Cell( 'D1_QUANT' ):SetValue(SD1->D1_QUANT)
		oSection3:Cell( 'D1_VUNIT' ):SetValue(SD1->D1_VUNIT )
		oSection3:Cell( 'D1_TOTAL' ):SetValue(SD1->D1_TOTAL )
		oSection3:PrintLine()

	end
	oSection3:Finish()




return

