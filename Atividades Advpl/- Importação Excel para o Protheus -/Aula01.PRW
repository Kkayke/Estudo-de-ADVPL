//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

//Posições do Array
Static nPosID    := 1 //Coluna A no Excel
Static nPriNome  := 2 //Coluna B no Excel
Static nUltNome  := 3 //Coluna C no Excel
Static nPais     := 4 //Coluna D no Excel
Static nEmail    := 5 //Coluna e no Excel
Static nGenero   := 6 //Coluna f no Excel
Static nIpende   := 7 //Coluna g no Excel
Static nStatus   := 8 //Coluna h no Excel

User Function IMPORTA()
	Local aArea      := GetArea()
	Private cArqOri  := ""

	//Mostra o Prompt para selecionar arquivos
	cArqOri          := tFileDialog( "CSV files (*.csv) ", 'Seleï¿½ï¿½o de Arquivos' , , , .F., )

	//Se tiver o arquivo de origem
	If ! Empty(cArqOri)

		//Somente se existir o arquivo e for com a extensï¿½o CSV
		If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt( '.' , cArqOri) + 1, 3)) == 'CSV'
			Processa({|| fImporta() }, "Importando...")
		Else
			MsgStop("Arquivo e/ou extensï¿½o invï¿½lida!", "Atenï¿½ï¿½o")
		EndIf
	EndIf

	RestArea(aArea)
Return

Static Function fImporta()
	Local aArea      := GetArea()
	Local cArqLog    := "zImpCSV_" + dToS(Date()) + "_" + StrTran(Time(), ':' , '-' ) + ".txt"
	Local nTotLinhas := 0
	Local cLinAtu    := ""
	Local nLinhaAtu  := 0
	Local aLinha     := {}
	Local oArquivo
	Local aLinhas
	local cIDuser    := ""
	local cPrimeiro  := ""
	local cUltimo    := ""
	local cPais      := ""
	local cEmail     := ""
	local cGenero    := ""
	local cIpendere  := ""
	local cStatus    := ""
	Private cDirLog  := GetTempPath() + "x_importacao\"
	Private cLog     := ""
	private aColun
//Se a pasta de log nï¿½o existir, cria ela
	If ! ExistDir(cDirLog)
		MakeDir(cDirLog)
	EndIf

	//Definindo o arquivo a ser lido
	oArquivo         := FWFileReader():New(cArqOri)

	//Se o arquivo pode ser aberto
	If (oArquivo:Open())

		//Se nï¿½o for fim do arquivo
		If ! (oArquivo:EoF())

			//Definindo o tamanho da rï¿½gua
			aLinhas          := oArquivo:GetAllLines()
			nTotLinhas       := Len(aLinhas)
			ProcRegua(nTotLinhas)

			//Mï¿½todo GoTop nï¿½o funciona (dependendo da versï¿½o da LIB), deve fechar e abrir novamente o arquivo
			oArquivo:Close()
			oArquivo         := FWFileReader():New(cArqOri)
			oArquivo:Open()

			//Enquanto tiver linhas
			While (oArquivo:HasLine())

				//Incrementa na tela a mensagem
				nLinhaAtu++
				IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")

				//Pegando a linha atual e transformando em array
				cLinAtu          := oArquivo:GetLine()
				aLinha           := StrTokArr(cLinAtu, ";")
				aColun           := StrTokArr(aLinha[1], ',' )

				//Se nï¿½o for o cabeï¿½alho (encontrar o texto "Cï¿½digo" na linha atual)
				If ! Empty(cLinAtu)

					//Zera as variaveis
					cIDuser          := aColun[1] //aLinha [nPosID]
					cPrimeiro        := aColun[2] //aLinha [nPriNome]
					cUltimo          := aColun[3] //aLinha [nUltNome]
					cPais            := aColun[4] //aLinha [nPais]
					cEmail           := aColun[5] //aLinha [nEmail]
					cGenero          := aColun[6] //aLinha [nGenero]
					cIpendere        := aColun[7] //aLinha [nIpende]
					cStatus          := aColun[8] //aLinha [nStatus]

					DbSelectArea( "SZ1" )
					SZ1->(DbSetOrder(1)) // Filial + Cï¿½digo + Loja

					//Se conseguir posicionar no fornecedor
					IF ! SZ1->(DBSeek(cFilAnt+cIDuser))

						RecLock( "SZ1" , .T.)
						SZ1->Z1_FILIAL   := FWCodFil() // ou xFilial que Retorna a filial utilizada por um determinado arquivo e na qual o usuï¿½rio se logou no sistema.
						SZ1->Z1_IDCLI    := cIDuser
						SZ1->Z1_PRNOME   := cPrimeiro
						SZ1->Z1_UTNOME   := cUltimo
						SZ1->Z1_PAIS     := cPais
						SZ1->Z1_EMAIL    := cEmail
						SZ1->Z1_GENERO   := cGenero
						SZ1->Z1_IPREDE   := cIpendere
						SZ1->Z1_STATUS   := cStatus
						SZ1->(MsUnlock())
					ENDIF
				Else

					cLog             := "- Lin" + cValToChar(nLinhaAtu) + "Linha vazia" + CRLF
				EndIf

			EndDo

			//Se tiver log, mostra ele
			If ! Empty(cLog)
				cLog             := "Processamento finalizado, abaixo as mensagens de log: " + CRLF + cLog
				MemoWrite(cDirLog + cArqLog, cLog)
				ShellExecute("OPEN", cArqLog, "", cDirLog, 1)
			EndIf

		Else
			MsgStop("Arquivo nï¿½o tem conteï¿½do!", "Atenï¿½ï¿½o")
		EndIf
		//Fecha o arquivo
		oArquivo:Close()
	Else
		MsgStop("Arquivo nï¿½o pode ser aberto!", "Atenï¿½ï¿½o")
	EndIf


	RestArea(aArea)
Return
