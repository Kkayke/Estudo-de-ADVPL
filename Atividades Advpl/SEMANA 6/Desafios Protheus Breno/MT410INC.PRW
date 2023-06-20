#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MT410INC
Ponto de entrada que grava o registro no campo C5_EMISSAO
@type Ponto de entrada
@version 0.1
@author Kayke
@since 05/06/2023
/*/

User function MT410INC()
	local lRet      := .T.

	dDatinha        := M->C5_EMISSAO +2

	If RecLock("SC5", .F.)
		SC5->C5_EMISSAO := DataValida(dDatinha,.T.)
		SC5->(MsUnlock())
	endif

RETURN lRet

