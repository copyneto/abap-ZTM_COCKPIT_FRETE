CLASS zcltm_grc_cte_to_cockpit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /xnfe/if_badi_flexible_step_ct .
    INTERFACES if_badi_interface .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_grc_cte_to_cockpit IMPLEMENTATION.


  METHOD /xnfe/if_badi_flexible_step_ct~step_before_dacte.

    TRY.
        DATA(lr_gko_process) = NEW zcltm_gko_process( iv_new       = abap_true
                                                      iv_tpdoc     = zcltm_gko_process=>gc_tpdoc-cte
                                                      iv_tpprocess = zcltm_gko_process=>gc_tpprocess-automatico
                                                      iv_xml       = iv_xml                                  ).
        lr_gko_process->process( ).
        lr_gko_process->persist( ).

        lr_gko_process->get_data(
          IMPORTING
            es_gko_header      = DATA(ls_gko_header)
*          es_gko_compl       =
*          et_gko_attachments =
*          et_gko_references  =
*          et_gko_acckey_po   =
*          et_gko_logs        =
*          et_gko_events      =
        ).
* Processamento de cálculo de custo da OF após integração do documento de frete.
        SELECT SINGLE cenario FROM zttm_gkot001
          INTO @DATA(lv_cenario)
          WHERE acckey = @ls_gko_header-acckey.
        IF lv_cenario = '02'.
          TRY.
              lr_gko_process->reprocess( ).
              lr_gko_process->persist( ).
              lr_gko_process->free( ).
            CATCH zcxtm_gko_process INTO DATA(lo_cxtm_gko_process).
              IF lo_cxtm_gko_process IS BOUND.
                lo_cxtm_gko_process->display( ).
              ENDIF.
              et_bapiret2 = lo_cxtm_gko_process->get_bapi_return( ).
          ENDTRY.
        ENDIF.

        lr_gko_process->free( ).

      CATCH zcxtm_gko_process INTO DATA(lr_cxtm_gko_process).
        IF lr_cxtm_gko_process IS BOUND.
          lr_cxtm_gko_process->display( ).
        ENDIF.
        et_bapiret2 = lr_cxtm_gko_process->get_bapi_return( ).
    ENDTRY.

  ENDMETHOD.


  METHOD /xnfe/if_badi_flexible_step_ct~step_after_dacte.
  ENDMETHOD.


  METHOD /xnfe/if_badi_flexible_step_ct~step_after_dacteos.
  ENDMETHOD.


  METHOD /xnfe/if_badi_flexible_step_ct~step_before_dacteos.
  ENDMETHOD.
ENDCLASS.
