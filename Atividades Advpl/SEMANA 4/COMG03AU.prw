#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMBROWSE.CH'

STATIC cMeuApelido := Space(12)

/*/{Protheus.doc} COMG03AU
|=========================================================================================================================|
|                                                                                                                         |
|  Aqui teremos a criação da tela que ira aparecer no protheus, juntamente com algumas classes como a MsDialog            |
|                                                                                                                         |
|=========================================================================================================================|
@type function7
@version 0.1
@author Victor gabriel
@Manutenção feita por: Kayke Laurindo no dia 19/05/2023
|========================================================================================================================================|
|                                                                                                                                        |
| Foi pedido para que arrume alguns bugs como por exemplo a seleção de todas as caixas flutuantes e apelidos que não estavam aparecendo  |                                                                                                                                        |
|	de maneira coerente para os usuarios                                                                                                 |
|========================================================================================================================================|
/*/
User Function COMG03AU()
	Private lRet    := .t.
	Private cCodigo := Space(30)
	Private aApelidosValidos := {}

	lRet := Apelidos()

Return lRet

Static Function Apelidos()
	Local cCSSGet    := "QLineEdit{ border: 1px solid gray;border-radius: 3px;background-color: #ffffff;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
	Local cCSSButton := "QPushButton{background-repeat: none; margin: 2px;background-color: #ffffff;border-style: outset;border-width: 2px;border: 1px solid #C0C0C0;border-radius: 5px;border-color: #C0C0C0;font: bold 12px Arial;padding: 6px;QPushButton:pressed {background-color: #ffffff;border-style: inset;}"
	Local cMascara   := ""
	Local cTitCampo  := ""
	Local aCols      := {}
	Local aApelidos  := {}
	Local nI         := 0
	Local cCadastro  := "Cadastro de Apelidos"
	Local lChkFil    := .f.
	Private oFC08    := TFont():New('Courier New', , -12, .F.)
	Private oNo      := LoadBitmap(GetResources(),"LBNO")
	Private oOk      := LoadBitmap(GetResources(),"LBOK")
	Private oDlg     := Nil
	Private oChkFil  := Nil
	Private oCodigo  := Nil
	Private oBrwPrc  := Nil

	aApelidos := U_FwLoadApelidos()
	For nI := 1 To Len(aApelidos)
		AAdd(aApelidosValidos,{aApelidos[nI][1],Alltrim(aApelidos[nI][2]),AllTrim(aApelidos[nI][3])})
	Next

	oDlg := MsDialog():New( 0, 0, 280, 500, cCadastro,,,.F.,,,,, oMainWnd,.T.,, ,.F. )

	aHead   := {"Ok","Código","Descrição"}

	oBrwPrc := TCBrowse():New(023,005,245,095,,aHead,aCols,oDlg,,,,,{||},,oFC08,,,,,.F.,,.T.,{||},.F.,,,)

	oCodigo := TGet():New( 003, 005,{|u| if(PCount()>0,cCodigo:=u,cCodigo)},oDlg,205, 010,cMascara,{|| },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"",cCodigo,,,,,,,cTitCampo + ": ",1 )
	oCodigo:SetCss(cCSSGet)

	oChkFil := TCheckBox():New(122, 080, "Escolher todos", {| u | If( PCount() == 0, lChkFil, lChkFil := u ) }, oDlg, 50, 10, , {||(),oBrwPrc:Refresh(.F.)}, , , , , .F., .T., , .F.,)

	//Seta o array da listbox
	oBrwPrc:SetArray(aApelidosValidos)

	oBrwPrc:bLDblClick := {|| fMarca( oBrwPrc:nAt ) }

	oBrwPrc:bLine :={||{if (aApelidosValidos[oBrwPrc:nAt,1],oOk,oNo),;
		aApelidosValidos[oBrwPrc:nAt,2],;
		aApelidosValidos[oBrwPrc:nAt,3]}}

	oButton1 := TButton():New(008, 212," &Pesquisar ",oDlg,{|| Processa({|| FiltroFIL(oBrwPrc:nAT,@aApelidosValidos,@cCodigo) },"Carregando dados..........") },037,013,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton1:SetCss(cCSSButton)

	SButton():New(122, 005 , 001, {|| ConfApelidos(oBrwPrc:nAt,@aApelidosValidos,@lRet)}, oDlg, .T., ,)
	SButton():New(122, 040 , 002, {|| oDlg:End()}  , oDlg, .T., ,)

	oDlg:Activate( oDlg:bLClicked, oDlg:bMoved, oDlg:bPainted,.T.,,,, oDlg:bRClicked, )

Return lRet

/*/{Protheus.doc} ConfApelidos
@author Victor gabriel
@Manutenção feita no dia 19/05/2023
@Manutenção feita por: Kayke Laurindo
@version 0.1
|========================================================================================================================================|
|                                                                                                                                        |
| Aqui Nessa função o apelido sera ajustado para quando o usuario for adicionar em seu perfil dentro do protheus, ele esteja   |                                                                                                                                        |
|                                                                                                                                        |
|========================================================================================================================================|
/*/
Static Function ConfApelidos(_nPos, aApelidosValidos, lRet)

	Local nF      := 0
	Local cApelidos := ""

	For nF := 1 To Len(aApelidosValidos)
		If aApelidosValidos[nF][1]
			cApelidos += AllTrim(aApelidosValidos[nF][3]) + ""
		EndIf
	Next nF

	lRet := .T.

	oDlg:End()

Return

/*/{Protheus.doc} COMG03AI
@author Vitor Gabriel
@Manutenção feita por : Kayke Laurindo
@Manutenção feita no dia 19/05/2023
@version 0.1
|===========================================================================|
|Aqui sera apenas dado o apelido do usuario para o perfil selecionado       |
|                                                                           |
|===========================================================================|
/*/
User Function COMG03AV()

	Local cRet := ""

	cRet := cMeuApelido

Return (cRet)

/*/{Protheus.doc} FiltroF3P
@author Vitor gabriel
@Manutenção feita por: Kayke Laurindo
@Manutenção feita no dia 19/05/2023
@version 0.1
|===========================================================================|
|Função que vai filtrar os apelidos que foram validados seguindo cada regra |
|                                                                           |
|===========================================================================|
/*/

Static Function FiltroFIL(nLinha,aApelidosValidos,cRetCpo)

	Local nI

	For nI := 1 To Len(aApelidosValidos)

		If AllTrim(cRetCpo) $ aApelidosValidos[nI][2] .or. AllTrim(cRetCpo) $ aApelidosValidos[nI][3]
			oBrwPrc:nAt := nI
			oBrwPrc:Refresh()
			Exit
		EndIf

	Next nI

Return

/*/{Protheus.doc} fMarca
@author vitor gabriel
@Manutenção feita por :Kayke Laurindo
@Feita no dia 19/05/2023
@version 0.1
|===========================================================================|
|Função que ira marcar as caixinhas flutuantes quando o usuario clicar nela |
|                                                                           |
|===========================================================================|
/*/
Static Function fMarca(nLinha)

	aApelidosValidos[nLinha,01] := !(aApelidosValidos[nLinha,01])

Return

/*/{Protheus.doc} FwLoadApelidos
@author vitor gabriel
@Manutenção feita por :Kayke Laurindo
@Feita no dia 19/05/2023
@version 0.1
|===========================================================================|
|Função que sera definida o nome de cada apelido dado pelo usuario          |
|                                                                           |
|===========================================================================|
/*/

User Function FwLoadApelidos()
	aApelidos := {}

	aAdd(aApelidos,{.F.,"01","Sandy"})
	aAdd(aApelidos,{.F.,"02","Plankton"})
	aAdd(aApelidos,{.F.,"03","Bob Esponja"})
	aAdd(aApelidos,{.F.,"04","Patrick"})

Return aApelidos

