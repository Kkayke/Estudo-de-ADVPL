
//Bibliotecas
#Include "TOTVS.CH"
#Include "TOPCONN.CH"
#INCLUDE "FWMBROWSE.CH"

//Constantes
#Define STR_PULA Chr(13)+Chr(10)

/*/{Protheus.doc} zTstExc1
Como vai ser gerado o excel
@type function
@version 12.1.33
@author Kayke
@since 26/05/2023
@return variant,
/*/
User Function zTstExc1()

	Local aArea    := GetArea()
	Local cArquivo := GetTempPath()+ 'zTstExc1.xml'
	Local cQuery   := ""
	Local oExcel
	Local oFWMsExcel

	//Pegando os dados
	cQuery := " SELECT "                                        + STR_PULA
	cQuery += "     Z1_IDCLI, "                                 + STR_PULA
	cQuery += "     Z1_PRNOME, "                                + STR_PULA
	cQuery += "     Z1_UTNOME, "                                + STR_PULA
	cQuery += "     Z1_PAIS, "                                  + STR_PULA
	cQuery += "   CONVERT(varchar(5000),Z1_EMAIL) Z1_EMAIL, "   + STR_PULA
	cQuery += "     Z1_GENERO, "                                + STR_PULA
	cQuery += "     Z1_IPREDE "                                 + STR_PULA
	cQuery += " FROM "                                          + STR_PULA
	cQuery += "     " + RetSQLName('SZ1') + " SZ1 "             + STR_PULA
	cQuery += " WHERE "                                         + STR_PULA
	cQuery += "    Z1_FILIAL = '" + FWxFilial('SZ1') + "' "     + STR_PULA
	cQuery += "     AND D_E_L_E_T_ = ' ' "                      + STR_PULA
	cQuery += " ORDER BY "                                      + STR_PULA
	cQuery += "     Z1_FILIAL "                                 + STR_PULA
	TCQuery cQuery New Alias "QRYPRO"

	//Criando o objeto que irá gerar o conteúdo do Excel

	oFWMsExcel    := FWMSExcel():New()
	//Aba 02 - Usuarios
	oFWMsExcel:AddworkSheet("Usuarios")
	//Criando a Tabela
	oFWMsExcel:AddTable("Usuarios","Usuarios")

	// Adicionando colunas e fazendo a relção com o objeto
	oFWMsExcel:AddColumn( "Usuarios","Usuarios","ID",1,,.t.)
	oFWMsExcel:AddColumn( "Usuarios","Usuarios","Nome",1,,.t.)
	oFWMsExcel:AddColumn( "Usuarios","Usuarios","Sobrenome",1,,.t.)
	oFWMsExcel:AddColumn( "Usuarios","Usuarios","Pais ",1,,.t.)
	oFWMsExcel:AddColumn( "Usuarios","Usuarios","email",1,,.t.)
	oFWMsExcel:AddColumn( "Usuarios","Usuarios","genero ",1,,.t.)
	oFWMsExcel:AddColumn( "Usuarios","Usuarios","IP DE REDE",1,,.t.)

	//Criando as Linhas... Enquanto não for fim da query
	While !(QRYPRO->(EoF()))
		oFWMsExcel:AddRow("Usuarios","Usuarios",{;
			QRYPRO->Z1_IDCLI,;
			QRYPRO->Z1_PRNOME,;
			QRYPRO->Z1_UTNOME,;
			QRYPRO->Z1_PAIS,;
			QRYPRO->Z1_EMAIL,;
			Sexo(QRYPRO->Z1_GENERO),;
			QRYPRO->Z1_IPREDE;
			})

		//Pulando Registro
		QRYPRO->(DbSkip())
	EndDo

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo) //Abre uma planilha
	oExcel:SetVisible(.T.) //Visualiza a planilha

	QRYPRO->(DbCloseArea())
	RestArea(aArea)
Return

/*/{Protheus.doc} Sexo
Retorna o genero traduzido
@type function
@version 12.1.33
@author Kayke
@since 26/05/2023
@param Genero, variant, param_Character
@return variant, return_Chacacter
/*/
Static Function Sexo(Genero)

	Local cGenero := ''

	IF(Alltrim(Genero) $ 'Male' )
		cGenero       := 'Homem'
	elseIF(AllTrim(Genero) $ 'Female' )
		cGenero       := 'Mulher'
	else
		cGenero       := Genero
	ENDIF

Return cGenero

static function Opcao()

	if Z1_STATUS == "f"
		FWAlertError("Não é possivel imprimir usuarios inativos", "Impressão invalida")

	endif


return
