#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE 'REPORT.CH'
//Criando o browse(Tela que ira aparecer)
User Function AMVC02()
	local oBrowse

	//CriaÃ§Ã£o do objeto do tipo Browse
	oBrowse := FwmBrowse():New()

	//Definir qual a tabela que vai ser apresentada
	oBrowse:SetAlias("ZZ1")

	//Definir o titulo ou a descriÃ§Ã£o que sera apresentada no browse
	oBrowse:SetDescription("Controle de Transações bancarias")

	oBrowse:AddLegend("ZZ1_TIPOCC=='1'", "YELLOW", "Cliente exclusivo")
	oBrowse:AddLegend("ZZ1_TIPOCC=='2'", "RED", "Cliente Prime")
	oBrowse:AddLegend("ZZ1_TIPOCC=='3'", "BLUE", "Cliente Personalizado")

	oBrowse:DisableDetails()

	oBrowse:SetMenuDef("A02MVC")

	oBrowse:activate()

Return

//Definindo menuDef
Static Function MenuDef()
	private aRotina := {}

	ADD OPTION aRotina TITLE "visualizar" ACTION "VIEWDEF.A02MVC" OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.A02MVC" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.A02MVC" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "excluir"    ACTION "VIEWDEF.A02MVC" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Legenda"    ACTION "u_LegA02MVC"    OPERATION 8  ACCESS 0

return aRotina


//definindo as legendas
User function legA02MVC()

	local aLegenda  := {}
	local cCadastro := "Controle de transações bancarias - aula 02 MVC"

	AADD(aLegenda, {"BR_AMARELO"  , "Cliente exclusivo"   } )
	AADD(aLegenda, {"BR_VERMELHO"  , "Cliente Prime"      } )
	AADD(aLegenda, {"BR_AZUL"  , "Cliente Personalizado"  } )

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return


//Definindo a modelDef
Static Function ModelDef()

	local oModel := MPFormModel():New("A02MVCM")
	local oStruZZ1 := FWFormStruct(1,"ZZ1")
	local oStruZZ2 := FWFormStruct(1,"ZZ2",{|x|AllTrim(x)<>"ZZ2_CODCOR"})
	local bLinOK := {|oStruZZ2|VldLinOK(oStruZZ2)}
	local aGatilhos := {}
	local nX := 0

	//Adicionando um gatilhoadmi
	AADD(aGatilhos, FWStruTrigger( "ZZ1_TIPOCC",;                                                                        //Campo Origem
	"ZZ1_CHQESP",;                                                                        //Campo Destino
	"IIF(FwFldGet('ZZ1_TIPOCC')=='1',2000,IIF(FwFldGet('ZZ1_TIPOCC')=='2',4000,10000))",; //Regra de Preenchimento
	.F.,;                                                                                 //Ira Posicionar?
	"",;                                                                                  //Alias de Posicionamento
	0,;                                                                                   //Indice de Posicionamento
	'',;                                                                                  //Chave de Posicionamento
	NIL,;                                                                                 //Condicao para execicao
	"01");                                                                                //Sequencia do gatilho
	)

	For nX := 1 to Len(aGatilhos)
		oStruZZ1:AddTrigger(aGatilhos[NX][01],;
			aGatilhos[NX][02],;
			aGatilhos[NX][03],;
			aGatilhos[NX][04])
	Next


	oStruZZ1:SetProperty("*", MODEL_FIELD_VALID, {|| .T. } )
	oStruZZ1:SetProperty("ZZ1_CODIGO", MODEL_FIELD_WHEN, {|| .T. } )
	oStruZZ1:SetProperty("ZZ1_SALDO", MODEL_FIELD_WHEN, {|| .T. } )
	oStruZZ2:SetProperty("ZZ2_ITEM" , MODEL_FIELD_WHEN, {|| .T. } )
	oStruZZ2:SetProperty("ZZ2_TIPO" , MODEL_FIELD_INIT, {|| IIF(oModel:GetId() == "ZZ2_GRIDc","1","2") } )

	oModel:AddFields("ZZ1_TOPO",/*owner*/,oStruZZ1)
	oModel:GetModel("ZZ1_TOPO"):SetPrimaryKey({"ZZ1_FILIAL","ZZ1_CODIGO"})

	//credito
	oModel:AddGrid("ZZ2_GRIDc", "ZZ1_TOPO",oStruZZ2,bLinOK)
	oModel:GetModel("ZZ2_GRIDc"):SetOptional(.T.)
	oModel:GetModel("ZZ2_GRIDc"):SetLoadFilter({{"ZZ2_TIPO","'1'"}})

	//Debito
	oModel:AddGrid("ZZ2_GRIDd", "ZZ1_TOPO",oStruZZ2,bLinOK)
	oModel:GetModel("ZZ2_GRIDd"):SetOptional(.T.)
	oModel:GetModel("ZZ2_GRIDd"):SetLoadFilter({{"ZZ2_TIPO","'2'"}})

	oModel:SetRelation("ZZ2_GRIDc",{{"ZZ2_FILIAL","xFilial('ZZ2')"},{"ZZ2_CODCOR","ZZ1_CODIGO"}},ZZ2->(IndexKey(1)) )
	oModel:GetModel("ZZ2_GRIDc"):SetUniqueLine({"ZZ2_ITEM","ZZ2_TIPO"})

	oModel:SetRelation("ZZ2_GRIDd",{{"ZZ2_FILIAL","xFilial('ZZ2')"},{"ZZ2_CODCOR","ZZ1_CODIGO"}},ZZ2->(IndexKey(1)) )
	oModel:GetModel("ZZ2_GRIDd"):SetUniqueLine({"ZZ2_ITEM","ZZ2_TIPO"})

	oModel:SetDescription("Controle de transações - MVC modelo 2")
	oModel:GetModel("ZZ1_TOPO"):SetDescription("Informações dos correntistas")
	oModel:GetModel("ZZ2_GRIDc"):SetDescription("Transações de credito")
	oModel:GetModel("ZZ2_GRIDd"):SetDescription("Transações de debito")

ReturN oModel
//Definindo a validação
Static Function VldLinOK(oStruZZ2)
	local lRet := .T.

	if !oStruZZ2:IsDeleted() // Verifica se a linha nao foi deletada
		IF fWFldGet("ZZ2_VALOR") > 1000 .and. fWFldGet("ZZ2_TIPO") == "2"
			lRet := .F.
			Help( ,, "HELP" ,, "Nao e possivel realizar um saque maior de que R$ 1.000,00", 1, 0)
		endif
	endif

return lRet
//Definindo a viewDef

Static Function ViewDef()

	local oView      := Nil
	local cCmpFil1   := "ZZ1_CODIGO|ZZ1_NOME|ZZ1_CEL|ZZ1_TEL|"
	local cCmpFil2   := "ZZ1_AGENC|ZZ1_CC|ZZ1_TIPOCC|ZZ1_SALDO|"
	local oModel     := FwLoadModel("A02MVC")
	local oStruZZ1_1 := FWFormStruct(2,"ZZ1",{|X| Alltrim(x) + "|" $ cCmpFil1})
	local oStruZZ1_2 := FWFormStruct(2,"ZZ1",{|X| Alltrim(x) + "|" $ cCmpFil2})
	local oStruZZ2c   := FWFormStruct(2,"ZZ2")
	local oStruZZ2d   := FWFormStruct(2,"ZZ2")


	oView := FWFormView():New()
	oView:SetModel(oModel)


	oView:AddField("VIEW_ZZ1_1", oStruZZ1_1, "ZZ1_TOPO")
	oView:AddField("VIEW_ZZ1_2", oStruZZ1_2, "ZZ1_TOPO")
	oView:AddGrid("VIEW_ZZ2c", oStruZZ2c, "ZZ2_GRIDc")
	oView:AddGrid("VIEW_ZZ2d", oStruZZ2d, "ZZ2_GRIDd")

	oView:CreateHorizontalBox("CABEC", 30 )
	oView:CreateHorizontalBox("GRID",  70 )

	oView:EnableTitle("VIEW_ZZ1_1", "Correntista")
	oView:EnableTitle("VIEW_ZZ1_2", "Conta corrente")
	oView:EnableTitle("VIEW_ZZ2c", "Transações de credito")
	oView:EnableTItle("VIEW_ZZ2d", "Transações de debito")

	oStruZZ2c:RemoveField("ZZ2_CODCOR")
	oStruZZ2d:RemoveField("ZZ2_CODCOR")

	oStruZZ2c:RemoveField("ZZ2_TIPO")
	oStruZZ2d:RemoveField("ZZ2_TIPO")

	oView:CreateFolder("PASTAS", "CABEC")
	oView:AddSheet("PASTAS", "ABA01", "Informações do correntista")
	oView:AddSheet("PASTAS", "ABA02", "Informações da conta corrente")

	oView:CreateFolder("PASTA_GRID","GRID")
	oView:AddSheet("PASTA_GRID", "ABA_GRIDc", "Transações de credito")
	oView:AddSheet("PASTA_GRID", "ABA_GRIDd", "Transações de debito")


	oView:CreateHorizontalBox("CABEC_01", 100, , , "PASTAS","ABA01")
	oView:CreateHorizontalBox("CABEC_02", 100, , , "PASTAS","ABA02")

	oView:CreateHorizontalBox("GRIDc",100, , ,"PASTA_GRID","ABA_GRIDc")
	oView:CreateHorizontalBox("GRIDd",100, , ,"PASTA_GRID","ABA_GRIDd")


	oView:SetOwnerView("VIEW_ZZ1_1","CABEC_01")
	oView:SetOwnerView("VIEW_ZZ1_2","CABEC_02")
	oView:SetOwnerView("VIEW_ZZ2c","GRIDc")
	oView:SetOwnerView("VIEW_ZZ2d","GRIDd")

	oView:AddIncrementField("VIEW_ZZ2c", "ZZ2_ITEM")
	oView:AddIncrementField("VIEW_ZZ2d", "ZZ2_ITEM")

	oView:SetCloseOnOk({||.F.})

return oView

//Definindo VldTudoOK

Static function VldTudoOk(oModel)
	local lRet := .T.
	local oModelZZ2 := oModel:GetModel("ZZ2_GRID")
	local nSldCor := FwFldGet("ZZ1_SALDO")
	local nVlrChqEs := 0
	local nX := 0

	if oModel:GetModel("ZZ2_TIPOCC") == 1
		nVlrChqEs := 2000
	elseif oModel:GetModel("ZZ2_TIPOCC") == 2
		nVlrChqEs := 4000
	else
		nVlrChqEs := 10000
	ENDIF

	for nX := 1 to oModelZZ2:Length()
		oModelZZ2:Goline(nX)
		if oModelZZ2:IsEmpty() .and. oModelZZ2:IsDeleted()
			if oModelZZ2:GetValue("ZZZ_TIPO") == 1
				nSldCor += oModelZZ2:GetValue("ZZ2_VALOR")
			else
				nSldCor += oModelZZ2:GetValue("ZZ2_VALOR")
			endif
		endif
	NEXT

	if (nSldCor + nVlrChqEs) < 0
		help( ,, "HELP" ,, "O limite do correntista foi excedido! ", 1, 0)
		lRet := .F.
	ENDIF

return lRet

//usando modelCancel
Static function ModeCancel(oModel)
	local lRet := .T.

	Help( ,, "HELP" ,, "Cancelou a transação", 1, 0)

return lRet

//usando saveModel

Static function SaveModel(oModel)
	local lRet := .T.
	local oModelZZ2 := oModel:GetModel("ZZ2_GRID")
	local nSldCor := FwFieldGet("ZZ1_SALDO")
	local nOperation := oModel:GetOperation()
	local nX := 0

	If nOperation == MODEL_OPERATION_UPDATE .OR. nOperation == MODEL_OPERATION_INSERT
		for nX := 1 to oModelZZ2:length()
			oModelZZ2:Goline(nX)
			if !oModelZZ2:IsDeleted() .and. !oModelZZ2:IsEmpty()
				if oModelZZ2:GetValue("ZZ2_TIPO") =="1"
					nSldCor += oModelZZ2:GetValue("ZZ2_VALOR")
				else
					nSldCor += oModelZZ2:GetValue("ZZ2_VALOR")
				endif

			ENDIF

		Next

		oModel:LoadValue("ZZ1_TOPO", "ZZ1_SALDO" ,nSldCor)



	endif

	FwFormComit(oModel)


Return lRet


