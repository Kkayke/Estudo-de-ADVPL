#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE 'FWMVCDEF.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} Ponto de entrada do cadastro de produto
Após inclusão de um produto no cadastro de produto
@author  Kayke
@since   19/06/2023
@version 22.10
/*/
//-------------------------------------------------------------------
User Function MT010INC()
	Local oFont
	Local oSay

	//=================================Tela que ira dar as opções para o usuario==========================\\

	oMsDialog := MSDialog():New(180,180,450,700,'Escolha uma tabela para enviar o produto',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	oTButton1 := TButton():New( 002, 130, "Tabela de preço",oMsDialog,{||tela1()}, 70,70,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 002, 040, "Pedido de venda",oMsDialog,{||tela2()}, 70,70,,,.F.,.T.,.F.,,.F.,,,.F. )
	oFont := TFont():New('Bold italic',,-18,.T.)
	oSay:= TSay():New(090,70,{||'Escolha uma tabela'},oMsDialog,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)


	oMsDialog:ACTIVATE()

Return

Static function tela1()
	Local cProduto := AllTrim(M->B1_COD)
	Local nOpr := 4
	Local oDlg := MSDialog():New(180,180,920,1280,'Tabelas Protheus',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	//Criando a markBrowse
	oTela := FWMarkBrowse():New()
	oTela:SetOwner(oDlg)
	oTela:AddButton("Confirmar",{||u_OMS1(cProduto,nOpr)},,3,0)
	oTela:SetAlias("DA0")

	oTela:SetUseFilter(.F.)
	oTela:SetOnlyFields({"DA0_CODTAB","DA0_DESCRI","DA0_DATDE","DA0_HORADE","DA0_HORATE","DA0_TPHORA","DA0_ATIVO" })
	oTela:SetDescription("Seleção de cadastro da tabela de preço")
	oTela:SetFieldMark( 'DA0_OK' )//PEGAR MESMO TAMANHO DE CAMPO DA E1_OK
	oTela:DisableReport()

	oTela:Activate()
	oDlg:Activate()

return

Static function tela2()
	Local cProduto := AllTrim(M->B1_COD)
	Local nOpr     := 4
	Local oDlg     := MSDialog()    :New(180, 180, 920, 1280, 'Tabelas Protheus', , , , , CLR_BLACK, CLR_WHITE, , , .T.)
	//Criando a markBrowse
	oTela          := FWMarkBrowse():New()
	oTela:SetOwner(oDlg)
	oTela:AddButton("Confirmar",{||u_MAT4(oTela,cProduto,nOpr)},,3,0)
	oTela:SetAlias("SC5")
	oTela:SetUseFilter(.F.)
	oTela:SetOnlyFields({"C5_NUM"                     , "C5_TIPO ", "C5_CLIENTE", "C5_LOJACLI", "C5_LOJAENT", "C5_CONDPAG"})
	oTela:SetDescription("Seleção de cadastro do pedidos de venda")
	oTela:SetFieldMark( 'C5_CONOK' ) //PEGAR MESMO TAMANHO DE CAMPO DA E1_OK
	oTela:DisableReport()

	oTela:Activate()
	oDlg:Activate()

return
