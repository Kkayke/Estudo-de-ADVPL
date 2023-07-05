#INCLUDE 'TOTVS.CH'

User function telao()
	Local oFont
	Local oSay

	oMsDialog := MSDialog():New(180,180,450,700,'Escolha uma tabela para enviar o produto',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	oTButton1 := TButton():New( 002, 130, "Tabela de preço",oMsDialog,{||tela1()}, 70,70,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton2 := TButton():New( 002, 040, "Pedido de venda",oMsDialog,{||tela2()}, 70,70,,,.F.,.T.,.F.,,.F.,,,.F. )
	oFont := TFont():New('Bold italic',,-18,.T.)
	oSay:= TSay():New(090,70,{||'Escolha uma tabela'},oMsDialog,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oMsDialog:ACTIVATE()

return
