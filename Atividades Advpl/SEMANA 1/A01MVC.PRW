#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMBROWSE.CH'
//Criando o browse(Tela que ira aparecer)
   user function A01MVC()
   local oBrowse

   //Criação do objeto do tipo Browse
   oBrowse := FwmBrowse():New()

   //Definir qual a tabela que vai ser apresentada
   oBrowse:SetAlias("SB1")

   //Definir o titulo ou a descrição que sera apresentada no browse
   oBrowse:SetDescription("Cadastro de produtos - aula 01 mvc")

//Criando as legendas e filtros para o browse

   oBrowse:AddLegend("B1_TIPO == 'PA'","YELLOW","Produto acabado")
   oBrowse:AddLegend("B1_TIPO == 'PI'","ORANGE","Produto intermediario")
   oBrowse:AddLegend("B1_TIPO == 'MP'","BLUE","Materia prima")
   oBrowse:AddLegend("B1_TIPO == 'MO'","RED"," M�o de obra")
   oBrowse:AddLegend("B1_TIPO == 'EM'","GREEN","Embalagem")

   oBrowse:DisableDetails()

   oBrowse:SetMenuDef("A01MVC")

   //ativando o browse
   oBrowse:Activate()

   return

//Criando a menuDef

   Static Function MenuDef()
   local aRotina := {}

   AADD(aRotina, {"Pesquisar" , "PesqBrw", 0, 1, 0, Nil           })
   AADD(aRotina, {"Visualizar", "VIEWDEF.A01MVC", 0, 6, 0, Nil    })
   AADD(aRotina, {"alterar"   , "VIEWDEF.A01MVC", 0, 2, 0, Nil    })
   AADD(aRotina, {"incluir"   , "VIEWDEF.A01MVC", 0, 3, 0, Nil    })
   AADD(aRotina, {"Excluir"   , "VIEWDEF.A01MVC", 0, 4, 0, Nil    })
   AADD(aRotina, {"Legenda"   , "U_LegMVC01", 0, 5, 0, Nil        })

   return aRotina

//Definindo a modelDef
   Static Function ModelDef()
   local oModel    
   local oStruSB1

   oModel   := MPFormModel():New("A01MVCM")
   
   oStruSB1 := FWFormStruct(1,"SB1")

   oModel:AddFields("SB1MASTER",/*Owner*/,oStruSB1 )

   oModel:SetDescription("Modelo de dados - Cadastro de produto")

   oModel:GetModel("SB1MASTER"):SetDescription("Dados do produto")

   oModel:SetPrimaryKey( {"B1_FILIAL", "B1_COD"} )


   return oModel

//Definindo função ViewDef
   Static function ViewDef()
   local oModel
   local oStruSB1
   local oView

   oModel   := FwLoadModel("A01MVC")
   
   oStruSB1 := FWFormStruct(2,"SB1")

   oView    := FWFormView():New()

   oView:SetModel(oModel)

   oView:AddField("VIEW_SB1",oStruSB1,"SB1MASTER")

   oView:CreateHorizontalBox("FORMULARIO",100)

   oView:SetOwnerView("VIEW_SB1", "FORMULARIO")


   return oView
//Criando os icones das legendas

   User function LegMVC01()
   local aLegenda := {}

   AADD(aLegenda,{"BR_AMARELO"  ,"Produto Acabado"       })
   AADD(aLegenda,{"BR_LARANJA"  ,"Produto Intermediario" })
   AADD(aLegenda,{"BR_AZUL"     ,"Materia Prima"         })
   AADD(aLegenda,{"BR_VERMELHO" ,"M�o de obra"           })
   AADD(aLegenda,{"BR_VERDE"    ,"Embalagem"             })

   BrwLegenda("Tipos de produto", "Legenda", aLegenda)

   return Nil

   