#INCLUDE 'TOTVS.CH '
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMBROWSE.CH'
//Criando o browse(Tela que ira aparecer)
user function aula03()
	local oBrowse

	//Criação do objeto do tipo Browse
	oBrowse        := FwmBrowse()  :New()

	//Definir qual a tabela que vai ser apresentada
	oBrowse:SetAlias("SZ1")

	//Definir o titulo ou a descrição que sera apresentada no browse
	oBrowse:SetDescription("Cadastro de Usuarios customizados")

//Criando as legendas e filtros para o browse
	oBrowse:AddLegend("Z1_STATUS == 'f' ","RED","Inativo")
	oBrowse:AddLegend("Z1_STATUS == 't' ","GREEN","ativo")

	oBrowse:DisableDetails()

	oBrowse:SetMenuDef("aula03")

	//ativando o browse
	oBrowse:Activate()

return

//Criando a menuDef

Static Function MenuDef()
	local aRotina  := {}

	ADD OPTION aRotina TITLE "visualizar" ACTION "VIEWDEF.aula03" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.aula03" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.aula03" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "excluir" ACTION "VIEWDEF.aula03" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Legenda" ACTION "u_Legaula03" OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Importa��o" ACTION "u_IMPORTA" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Relatorio" ACTION "u_zTstExc1" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Relatorio2" ACTION "u_relat" OPERATION 1 ACCESS 0

return aRotina
//Definindo a modelDef
Static Function ModelDef()
	local oModel
	local oStruSZ1

	oModel         := MPFormModel():New("aula03M")

	oStruSZ1       := FWFormStruct(1,"SZ1")

	oModel:AddFields("SZ1MASTER",/*Owner*/,oStruSZ1 )

	oModel:SetDescription("Modelo de dados - Cadastro de usuarios")

	oModel:GetModel("SZ1MASTER"):SetDescription("Dados dos usuarios")

	oModel:SetPrimaryKey( {"Z1_FILIAL"  , "Z1_IDCLI"} )


return oModel

//Definindo função ViewDef
Static function ViewDef()
	local oModel
	local oStruSZ1
	local oView

	oModel         := FwLoadModel("aula03")

	oStruSZ1       := FWFormStruct(2,"SZ1")

	oView          := FWFormView() :New()

	oView:SetModel(oModel)

	oView:AddField("VIEW_SZ1",oStruSZ1,"SZ1MASTER")

	oView:CreateHorizontalBox("FORMULARIO",100)

	oView:SetOwnerView("VIEW_SZ1", "FORMULARIO")


return oView
//Criando os icones das legendas

User function Legaula03()
	local aLegenda := {}
	aadd(aLegenda, {"BR_VERMELHO", "Inativo"})
	aadd(aLegenda, {"BR_VERDE"   , "Ativo"})

	BrwLegenda("Tipos de usuarios", "Legenda", aLegenda)

return Nil

