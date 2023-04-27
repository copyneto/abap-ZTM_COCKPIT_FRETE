class ZCLTM_GET_PROCESS_CTE definition
  public
  final
  create public .

public section.

  interfaces /XNFE/IF_BADI_GET_PROCESS_CTE .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_GET_PROCESS_CTE IMPLEMENTATION.


  METHOD /xnfe/if_badi_get_process_cte~get_business_process.


    INCLUDE /xnfe/constants_cte.

    "Verifica se o cenário atribuido, foi o básico
    IF ev_proctyp = gc_proctyp_cte-ctebasic.

      DATA(lv_cnpj_base_rem)  = is_inctehd-cnpj_rem(8).
      DATA(lv_cnpj_base_dest) = is_inctehd-cnpj_dest(8).

      "Verifica se a raiz do CNPJ do tomador é igual ao CNPJ do remente ou ao CNPJ do destinatário
      "Se sim, atribui o cenário flex
      CASE is_inctehd-cnpj_derived_tom.
        WHEN is_inctehd-cnpj_rem.
          IF lv_cnpj_base_rem = lv_cnpj_base_dest.
            ev_proctyp = gc_proctyp_cte-cteflxbl.
          ENDIF.
        WHEN is_inctehd-cnpj_dest.
          IF lv_cnpj_base_rem = lv_cnpj_base_dest.
            ev_proctyp = gc_proctyp_cte-cteflxbl.
          ENDIF.
      ENDCASE.

      "Para os tipos 0 Normal, 1 Complemento e 3  Substituição, atribui o cenário flex
      IF ev_proctyp = gc_proctyp_cte-ctebasic AND is_inctehd-tpcte CA '013'.
        ev_proctyp = gc_proctyp_cte-cteflxbl.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
