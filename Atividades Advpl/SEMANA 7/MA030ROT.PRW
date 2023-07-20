#INCLUDE "TOTVS.CH"

User Function MA030ROT()
	Local aRet := {}

	aAdd( aRet, { "Doc.Word", "U_criarWord", 0, 2 } ) //Cadastro de Bancos
	aAdd( aRet, { "Relatorio em PDF", "u_CriaPdf", 0, 2 } ) //Cadastro de Bancos
	aAdd( aRet, { "Relatorio em Excel", "U_RelExcel", 0, 2 } ) //Cadastro de Bancos

Return aRet
