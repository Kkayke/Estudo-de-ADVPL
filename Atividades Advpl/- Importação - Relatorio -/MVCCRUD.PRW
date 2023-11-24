#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMBROWSE.CH'
#INCLUDE "REPORT.CH"
//Criando o browse(Tela que ira aparecer)
user function MVCCRUD()
	local oBrowse

	//Criação do objeto do tipo Browse
	oBrowse:= FwmBrowse():New()

	//Definir qual a tabela que vai ser apresentada
	oBrowse:SetAlias("SZ1")

	//Definir o titulo ou a descrição que sera apresentada no browse
	oBrowse:SetDescription("Cadastro de usuarios")

//Criando as legendas e filtros para o browse

	oBrowse:DisableDetails()

	oBrowse:AddLegend("Z1_STATUS == 'f' ","RED"," Usuario inativo")
	oBrowse:AddLegend("Z1_STATUS == 't' ","GREEN","Usuario ativo")

	oBrowse:SetMenuDef("MVCCRUD")

	//ativando o browse
	oBrowse:Activate()

return

//Criando a menuDef

Static Function MenuDef()
	local aRotina  := {}

	ADD OPTION aRotina TITLE "visualizar" ACTION "VIEWDEF.MVCCRUD" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.MVCCRUD" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.MVCCRUD" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "excluir" ACTION "VIEWDEF.MVCCRUD" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Legenda" ACTION "u_LegMVCCRUD" OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Importação" ACTION "u_IMPORTA" OPERATION 3 ACCESS 0

return aRotina

//Definindo a modelDef
Static Function ModelDef()
	local oModel
	local oStruSZ1

	oModel := MPFormModel():New("MVCCRUDM")

	oStruSZ1 := FWFormStruct(1,"SZ1")

	oModel:AddFields("SZ1MASTER",/*Owner*/,oStruSZ1 )

	oModel:SetDescription("Modelo de dados - Cadastro de usuario")

	oModel:GetModel("SZ1MASTER"):SetDescription("Dados do usuario")

	oModel:SetPrimaryKey( {"Z1_FILIAL"  , "Z1_IDCLI"} )


return oModel

//Definindo função ViewDef
Static function ViewDef()
	local oModel
	local oStruSZ1
	local oView

	oModel         := FwLoadModel("MVCCRUD")

	oStruSZ1       := FWFormStruct(2,"SZ1")

	oView          := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField("VIEW_SZ1",oStruSZ1,"SZ1MASTER")

	oView:CreateHorizontalBox("FORMULARIO",100)

	oView:SetOwnerView("VIEW_SZ1", "FORMULARIO")

return oView
//Criando os icones das legendas

User function LegMVCCRUD()
	local aLegenda := {}


	aadd(aLegenda, {"BR_VERMELHO", "Usuario inativo"})
	aadd(aLegenda, {"BR_VERDE"   , "Usuario ativo"})

	BrwLegenda("Tipos de clientes", "Legenda", aLegenda)

return Nil
