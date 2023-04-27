*&---------------------------------------------------------------------*
*& Report ZTM_COCKPIT_DELETE_CTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztm_cockpit_delete_cte.

DATA: gs_chave TYPE zttm_gkot001,
      gt_t001  TYPE RANGE OF zttm_gkot001,
      gt_t002  TYPE RANGE OF zttm_gkot002,
      gt_t003  TYPE RANGE OF zttm_gkot003,
      gt_t006  TYPE RANGE OF zttm_gkot006.

SELECT-OPTIONS: s_chave  FOR gs_chave-acckey.

START-OF-SELECTION.

  IF s_chave IS NOT INITIAL.

    SELECT * INTO TABLE @DATA(lt_T001) FROM zttm_gkot001
      WHERE acckey IN @s_chave.

    IF sy-subrc IS INITIAL.

      DELETE zttm_gkot001 FROM TABLE lt_T001.

    ENDIF.

    SELECT * INTO TABLE @DATA(lt_T002) FROM zttm_gkot002
     WHERE acckey IN @s_chave.

    IF sy-subrc IS INITIAL.

      DELETE zttm_gkot002 FROM TABLE lt_T002.

    ENDIF.

    SELECT * INTO TABLE @DATA(lt_T003) FROM zttm_gkot003
     WHERE acckey IN @s_chave.

    IF sy-subrc IS INITIAL.

      DELETE zttm_gkot003 FROM TABLE lt_T003.

    ENDIF.

    SELECT * INTO TABLE @DATA(lt_T006) FROM zttm_gkot006
   WHERE acckey IN @s_chave.

    IF sy-subrc IS INITIAL.

      DELETE zttm_gkot006 FROM TABLE lt_T006.

    ENDIF.

  ENDIF.
