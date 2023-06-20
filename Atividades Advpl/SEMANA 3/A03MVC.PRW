#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} COMG03AU
|=========================================================================================================================|
|                                                                                                                         |
|  Aqui teremos a criação da tela que ira aparecer no protheus, juntamente com algumas classes como a MsDialog            |
|                                                                                                                         |
|=========================================================================================================================|
@type MsDialog
@version 1
@author Kayke
|========================================================================================================================================|
|                                                                                                                                        |
| Foi pedido para que Crie uma tela antiga dentro do protheus para que o usuario grave suas informações dentro do banco de dados         |                                                                                                                                        |
|                                                                                                                                        |
|========================================================================================================================================|
/*/


User function a03mvc()

	private dGet3 := Date()
	private cTGet1
	private cTGet2
	private cTGet4
	private cTGet5
	private cTGet11

	oMsDialog := MSDialog():New(100,100,850,850,'TESTE',,,,,CLR_WHITE,CLR_WHITE,,,.T.)

	cTGet1 := Space(15)
	oTGet1 := TGet():New( 30,01, {|u| iif( Pcount( )>0,cTGet1 := u,cTGet1 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
	oSay:= TSay():New(24,01,{||'Digite seu nome'},oMsDialog,,,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)

	cTGet2 := Space(15)
	oTGet2 := TGet():New( 50,01, {|u| iif( Pcount( )>0,cTGet2 := u,cTGet2 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,, )
	oSay:= TSay():New(40,01,{||'Digite seu endereço'},oMsDialog,,,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)

	dGet3:=CTOD(SPACE(8))
	oGet3 := TGet():New( 070, 01, { | u | iIf( PCount() == 0, dGet3, dGet3 := u ) },oMsDialog, ;
		060, 010, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,Dtoc(dGet3),,,,.T. )
	oSay:= TSay():New(60,01,{||'Digite sua data de nascimento'},oMsDialog,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	cTGet4 := Space(15)
	oTGet4 := TGet():New( 90,01, {|u| iif( Pcount( )>0,cTGet4 := u,cTGet4 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet4,,,, )
	oSay:= TSay():New(84,01,{||'Digite sua Cidade'},oMsDialog,,,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)

	cTGet5 := Space(15)
	oTGet5 := TGet():New( 110,01, {|u| iif( Pcount( )>0,cTGet5 := u,cTGet5 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet5,,,, )
	oTGet5:cF3 := 'EST'
	oSay:= TSay():New(104,01,{||'Digite seu estado'},oMsDialog,,,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)

	cTGet11 := Space(30)
	oTGet11 := TGet():New( 130,01, {|u| iif( Pcount( )>0,cTGet11 := u,cTGet11 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet11,,,, )
	oSay:= TSay():New(120,01,{||'Digite seu email'},oMsDialog,,,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)

	oTButton := TButton():New( 30, 112, "Gravar",oMsDialog,{||grava(cTGet1,cTGet2,DGet3,cTGet4,cTGet5)}, 40,40,,,.F.,.T.,.F.,,.F.,,,.F. )

	oMsDialog:Activate()

return


/*/{Protheus.doc} COMG03AU
|=========================================================================================================================|
|                                                                                                                         |
|  Aqui tera a criação dos Tget que irao mostrar oque foi gravado dentro da MsDialog                                      |
|                                                                                                                         |
|=========================================================================================================================|
@type MsDialog
@version 1
@author Kayke
/*/

static function grava(cNome,cEnd,dNasci,cCidade,cEstado,cEmail)

	oTGet6  := TGet():New(30 , 200, {||cTGet1} , oMsDialog, 086, 19, "@!", , 0, , , .F., , .T., , .F., , .F., .F., , .T., .F., , cTGet1     , , , ,)
	oTGet7  := TGet():New(50 , 200, {||cTGet2} , oMsDialog, 086, 19, "@!", , 0, , , .F., , .T., , .F., , .F., .F., , .T., .F., , cTGet2     , , , ,)
	oTGet8  := TGet():New(70 , 200, {||dGet3}  , oMsDialog, 086, 19, "@!", , 0, , , .F., , .T., , .F., , .F., .F., , .F., .F., , Dtoc(dGet3), , , ,)
	oTGet9  := TGet():New(90 , 200, {||cTGet4} , oMsDialog, 086, 19, "@!", , 0, , , .F., , .T., , .F., , .F., .F., , .T., .F., , cTGet4     , , , ,)
	oTGet10 := TGet():New(110, 200, {||cTGet5} , oMsDialog, 086, 19, "@!", , 0, , , .F., , .T., , .F., , .F., .F., , .T., .F., , cTGet5     , , , ,)
	oTGet11 := TGet():New(110, 200, {||cTGet11}, oMsDialog, 086, 19, "@!", , 0, , , .F., , .T., , .F., , .F., .F., , .T., .F., , cTGet11    , , , ,)



	//Gravando com o ReckLock
	//Selecionando qual tabela devera ser gravada
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" USER "Admin" PASSWORD " "

	DbSelectArea("LAT")
	RecLock("LAT", .T.)
	LAT->LAT_FILIAL := xFilial("LAT")
	LAT->LAT_STATUS := cTGet1
	LAT->LAT_NASCI  := dGet3
	LAT->LAT_MARCA  := cTGet5
	LAT->LAT_CIDADE := cTGet4
	LAT->LAT_END    := cTGet2
	LAT->LAT_EMAIL  := cTGet11

	MsUnLock() // Confirma e finaliza a operação

	RESET ENVIRONMENT





RETURN
