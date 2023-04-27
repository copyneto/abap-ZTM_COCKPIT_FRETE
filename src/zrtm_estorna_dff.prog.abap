*&---------------------------------------------------------------------*
*& Report ZRTM_ESTORNA_DFF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrtm_estorna_dff.

* Tabelas internas
DATA : lt_sfir_root TYPE /scmtms/t_sfir_root_k,
       lt_tor_id    TYPE /scmtms/t_tor_id,
       lt_message   TYPE fpmgb_t_messages,
       lv_acc_key   TYPE j_1b_nfe_access_key_dtel44.

SELECT-OPTIONS : s_key FOR lv_acc_key NO INTERVALS.

IF s_key IS NOT INITIAL.
  SELECT tor_id
    FROM zttm_gkot001
    INTO TABLE lt_tor_id
  WHERE acckey IN s_key.

  IF sy-subrc IS INITIAL.
    CALL METHOD /scmtms/cl_tor_helper_root=>get_key_from_torid
      EXPORTING
        it_torid  = lt_tor_id
      IMPORTING
        et_torkey = DATA(it_torkey).

    IF it_torkey IS NOT INITIAL.
      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = it_torkey
          iv_association = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root
          iv_fill_data   = abap_true
        IMPORTING
          et_data        = lt_sfir_root ).

      IF lt_sfir_root IS NOT INITIAL.
        DELETE lt_sfir_root WHERE lifecycle <> 04. " Posted

        CHECK lt_sfir_root IS NOT INITIAL.

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key )->do_action(
          EXPORTING
            iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-cancel_accruals
            it_key        = CORRESPONDING #( lt_sfir_root MAPPING key = key )
          IMPORTING
            eo_message    = DATA(lo_message)
            et_failed_key = DATA(lt_failed_key) ).

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key )->do_action(
          EXPORTING
            iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-cancel
            it_key        = CORRESPONDING #( lt_sfir_root MAPPING key = key )
          IMPORTING
            eo_message    = lo_message
            et_failed_key = lt_failed_key ).

        IF lt_failed_key IS INITIAL.
          /scmtms/cl_ui_msgbuffer_cmn=>convert_messages(
            EXPORTING
              io_message = lo_message
            CHANGING
              ct_message = lt_message ).

          /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save(
            IMPORTING
              ev_rejected = DATA(lv_rejected)
              eo_message  = lo_message ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
