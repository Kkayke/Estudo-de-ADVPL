#INCLUDE "TOTVS.CH"

user function rela()


	private dGet3 := Date()
	private cTGet1
	private cTGet2
	private cTGet4
	private cTGet5



	oMsDialog := MSDialog():New(180,180,850,850,'TESTE',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	cTGet1 := Space(15)
	oTGet1 := TGet():New( 30,01, {|u| iif( Pcount( )>0,cTGet1 := u,cTGet1 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )
	oSay:= TSay():New(24,01,{||'Digite seu nome'},oMsDialog,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	cTGet2 := Space(15)
	oTGet2 := TGet():New( 50,01, {|u| iif( Pcount( )>0,cTGet2 := u,cTGet2 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,, )
	oSay:= TSay():New(40,01,{||'Digite seu endereço'},oMsDialog,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	dGet3:=CTOD(SPACE(8))
	oGet3 := TGet():New( 070, 01, { | u | iIf( PCount() == 0, dGet3, dGet3 := u ) },oMsDialog, ;
		060, 010, "@D",, 0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,Dtoc(dGet3),,,,.T. )
	oSay:= TSay():New(60,01,{||'Digite sua data de nascimento'},oMsDialog,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	cTGet4 := Space(15)
	oTGet4 := TGet():New( 90,01, {|u| iif( Pcount( )>0,cTGet4 := u,cTGet4 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet4,,,, )
	oSay:= TSay():New(84,01,{||'Digite sua Cidade'},oMsDialog,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)


	cTGet5 := Space(15)
	oTGet5 := TGet():New( 110,01, {|u| iif( Pcount( )>0,cTGet5 := u,cTGet5 ) },oMsDialog,086,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet5,,,, )
	oSay:= TSay():New(104,01,{||'Digite seu estado'},oMsDialog,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oTButton := TButton():New( 30, 112, "Gravar",oMsDialog,{||grava(cTGet1,cTGet2,dGet3,cTGet4,cTGet5)}, 40,40,,,.F.,.T.,.F.,,.F.,,,.F. )


	oMsDialog:activate()

RETURN

static function grava(cNome,cEnd,dNasci,cCidade,cEstado)

	oTGet6 := TGet():New( 30,200,{||cTGet1},oMsDialog,086,19,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTGet1,,,, )
	oTGet7 := TGet():New( 50,200,{||cTGet2},oMsDialog,086,19,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTGet2,,,, )
	oTGet8 := TGet():New( 70,200,{||dGet3},oMsDialog,086,19,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,Dtoc(dGet3),,,, )
	oTGet9 := TGet():New( 90,200,{||cTGet4},oMsDialog,086,19,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTGet4,,,, )
	oTGet10 := TGet():New( 110,200,{||cTGet5},oMsDialog,086,19,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTGet5,,,, )

RETURN
