CLASS zcl_fi_toolkit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_documents ,
        bukrs TYPE bseg-bukrs,
        belnr TYPE bseg-belnr,
        gjahr TYPE bseg-gjahr,
        buzei TYPE bseg-buzei,
      END OF t_documents .
    TYPES:
      tt_documents TYPE STANDARD TABLE OF t_documents WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_hesap,
        sube   TYPE rfposxext-konto,
        merkez TYPE rfposxext-konto,
      END OF ty_hesap .
    TYPES:
      tt_hesap TYPE STANDARD TABLE OF ty_hesap .
    TYPES:
      BEGIN OF ty_bseg,
        bukrs TYPE bseg-bukrs,
        belnr TYPE bseg-belnr,
        gjahr TYPE bseg-gjahr,
        buzei TYPE bseg-buzei,
        kunnr TYPE bseg-kunnr,
        lifnr TYPE bseg-lifnr,
        hkont TYPE bseg-hkont,
        koart TYPE bseg-koart,
        vbeln TYPE bseg-vbeln,
        vbel2 TYPE bseg-vbel2,
        posn2 TYPE bseg-posn2,
        gkont TYPE bseg-hkont,
        konto TYPE kunnr,
        anln1 TYPE bseg-anln1,
        anln2 TYPE bseg-anln2,
      END OF ty_bseg .
    TYPES:
      BEGIN OF ty_konto,
        bukrs TYPE bukrs,
        konto TYPE konto,
      END OF ty_konto .
    TYPES:
      BEGIN OF ty_devir_items,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        buzei TYPE buzei,
        bukrs TYPE bukrs,
        konto TYPE hkont,
        shkzg TYPE shkzg,
        dmshb TYPE dmbtr,
        dmbe2 TYPE dmbe2,
        dmbe3 TYPE dmbe3,
        umskz TYPE umskz,
        filkd TYPE filkd,
        wrbtr TYPE wrbtr,
        waers TYPE waers,
        gsber TYPE gsber,
      END OF ty_devir_items .
    TYPES:
      BEGIN OF ty_devir,
        bukrs TYPE bukrs,
        konto TYPE hkont,
        shkzg TYPE shkzg,
        dmshb TYPE dmbtr,
        dmbe2 TYPE dmbe2,
        dmbe3 TYPE dmbe3,
        umskz TYPE umskz,
        filkd TYPE filkd,
        wrbtr TYPE wrbtr,
        waers TYPE waers,
        gsber TYPE gsber,
      END OF ty_devir .
    TYPES:
      tt_devir TYPE STANDARD TABLE OF ty_devir .
    TYPES:
      BEGIN OF t_doc_xblnr,
        bukrs TYPE bkpf-bukrs,
        belnr TYPE bkpf-belnr,
        gjahr TYPE bkpf-gjahr,
        xblnr TYPE bkpf-xblnr,
      END OF t_doc_xblnr .
    TYPES:
      tt_doc_xblnr TYPE STANDARD TABLE OF t_doc_xblnr WITH DEFAULT KEY .
    TYPES:
      tt_blart TYPE HASHED TABLE OF blart WITH UNIQUE KEY primary_key COMPONENTS table_line .

    CONSTANTS c_koart_kunnr TYPE koart VALUE 'D' ##NO_TEXT.
    CONSTANTS c_koart_lifnr TYPE koart VALUE 'K' ##NO_TEXT.
    CONSTANTS c_borc TYPE shkzg VALUE 'S' ##NO_TEXT.
    CONSTANTS c_alacak TYPE shkzg VALUE 'H' ##NO_TEXT.
    CONSTANTS c_mal_hareketi TYPE awtyp VALUE 'MKPF' ##NO_TEXT.
    CONSTANTS c_satinalma_faturasi TYPE awtyp VALUE 'RMRP' ##NO_TEXT.
    CONSTANTS c_satis_faturasi TYPE awtyp VALUE 'VBRK' ##NO_TEXT.
    CONSTANTS c_musteri_hf_talebi TYPE auart VALUE 'ZAH1' ##NO_TEXT.

    CLASS-METHODS check_iban_duplicate
      IMPORTING
        !it_iban       TYPE zfitt_iban_rng
        !iv_get_vendor TYPE abap_bool DEFAULT abap_true
        !iv_get_client TYPE abap_bool DEFAULT abap_true
        !it_lifnr      TYPE zqmtt_lifnr OPTIONAL
        !it_kunnr      TYPE range_kunnr_tab OPTIONAL
      RAISING
        zcx_fi_iban .
    CLASS-METHODS convert_datum_to_gdatu
      IMPORTING
        !iv_datum       TYPE datum
      RETURNING
        VALUE(rv_gdatu) TYPE tcurr-gdatu .
    CLASS-METHODS get_iban_codes
      IMPORTING
        !it_iban        TYPE zfitt_iban_rng OPTIONAL
        !iv_get_vendor  TYPE abap_bool DEFAULT abap_true
        !iv_get_client  TYPE abap_bool DEFAULT abap_true
        !it_lifnr       TYPE zqmtt_lifnr OPTIONAL
        !it_kunnr       TYPE range_kunnr_tab OPTIONAL
      RETURNING
        VALUE(rt_tiban) TYPE zfitt_tiban .
    CLASS-METHODS modify_report_falgll03_flbxn
      IMPORTING
        !ir_data TYPE REF TO data .
    CLASS-METHODS devir_fblxn
      IMPORTING
        !it_hesap TYPE tt_hesap
      EXPORTING
        !et_devir TYPE tt_devir .
    CLASS-METHODS display_fi_doc_in_gui
      IMPORTING
        !iv_belnr TYPE bkpf-belnr
        !iv_bukrs TYPE bkpf-bukrs
        !iv_gjahr TYPE bkpf-gjahr .
    CLASS-METHODS ekstre_fblxn
      CHANGING
        !ct_items TYPE it_rfposxext
      RAISING
        zcx_bc_table_content .
    CLASS-METHODS get_bkpf_xblnr
      CHANGING
        !ct_doc TYPE tt_doc_xblnr .
    CLASS-METHODS get_company_long_text
      IMPORTING
        !iv_bukrs      TYPE bukrs
      RETURNING
        VALUE(rv_text) TYPE string
      RAISING
        zcx_bc_table_content .
    CLASS-METHODS update_xblnr
      IMPORTING
        !it_xblnr           TYPE tt_doc_xblnr
        !iv_commit_each_doc TYPE abap_bool DEFAULT abap_false
      RAISING
        zcx_bc_class_method .
    CLASS-METHODS clear_customer_open_items
      IMPORTING
        !im_kunnr       TYPE kunnr
        !im_bukrs       TYPE bukrs
        VALUE(im_waers) TYPE waers OPTIONAL
        !it_belnr       TYPE re_t_xcfr_belnr .
    CLASS-METHODS clear_vendor_open_items
      IMPORTING
        !im_lifnr       TYPE lifnr
        !im_bukrs       TYPE bukrs
        !it_belnr       TYPE re_t_xcfr_belnr
        VALUE(im_waers) TYPE waers OPTIONAL .
    CLASS-METHODS determine_due_date
      IMPORTING
        !im_document    TYPE zfis_accdocument_key
      RETURNING
        VALUE(re_netdt) TYPE netdt .
    CLASS-METHODS denklestirerek_transfer_kaydi
      IMPORTING
        !is_bkpf TYPE bkpf
        !it_bseg TYPE tt_documents .
    CLASS-METHODS validate_zhrtip
      IMPORTING
        !iv_bukrs          TYPE bukrs
        !iv_acc_first_char TYPE char1
        !iv_zhrtip         TYPE zhrtip
      RAISING
        zcx_fi_zhrtip .

    CLASS-METHODS get_domestic_import_doc_types RETURNING VALUE(rt_blart) TYPE tt_blart.

    CLASS-METHODS get_import_document_types
      IMPORTING
        !iv_include_foreign  TYPE abap_bool DEFAULT abap_true
        !iv_include_domestic TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rt_blart)      TYPE tt_blart .

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF t_company_long_text,
        bukrs TYPE bukrs,
        text  TYPE string,
      END OF t_company_long_text .
    TYPES:
      BEGIN OF t_dg_cache,
        datum TYPE datum,
        gdatu TYPE tcurr-gdatu,
      END OF t_dg_cache .
    TYPES:
      tt_dg_cache TYPE HASHED TABLE OF t_dg_cache WITH UNIQUE KEY primary_key COMPONENTS datum .
    TYPES:
      BEGIN OF t_kna1,
        kunnr TYPE kunnr,
        name1 TYPE name1_gp,
      END OF t_kna1 .
    TYPES:
      tt_company_long_text TYPE HASHED TABLE OF t_company_long_text WITH UNIQUE KEY primary_key COMPONENTS bukrs .

    TYPES:
      BEGIN OF ty_anla_key        ,
        bukrs TYPE anla-bukrs,
        anln1 TYPE anla-anln1,
        anln2 TYPE anla-anln2,
      END OF ty_anla_key,
      tt_anla_key TYPE TABLE OF ty_anla_key.
    TYPES:
      BEGIN OF t_anla         ,
        bukrs TYPE anla-bukrs,
        anln1 TYPE anla-anln1,
        anln2 TYPE anla-anln2,
        txt50 TYPE anla-txt50,
      END OF t_anla .
    TYPES:
      tt_anla
          TYPE HASHED TABLE OF t_anla
          WITH UNIQUE KEY primary_key COMPONENTS bukrs anln1 anln2 .
    TYPES:
      BEGIN OF t_bkpf                 ,
        bukrs     TYPE bkpf-bukrs,
        belnr     TYPE bkpf-belnr,
        gjahr     TYPE bkpf-gjahr,
        stblg     TYPE bkpf-stblg,
        stjah     TYPE bkpf-stjah,
        awtyp     TYPE bkpf-awtyp,
        awkey     TYPE bkpf-awkey,
        xreversal TYPE bkpf-xreversal,
        xstov     TYPE bkpf-xstov,
        bstat     TYPE bkpf-bstat,
      END OF t_bkpf .
    TYPES:
      tt_bkpf
          TYPE HASHED TABLE OF t_bkpf
          WITH UNIQUE KEY primary_key COMPONENTS bukrs belnr gjahr .
    TYPES:
      BEGIN OF t_vbkd,
        vbeln TYPE vbkd-vbeln,
        bstkd TYPE vbkd-bstkd,
      END OF t_vbkd .
    TYPES:
      tt_vbkd
          TYPE SORTED TABLE OF vbkd
          WITH NON-UNIQUE KEY vbeln .
    TYPES:
      BEGIN OF t_rbkp,
        belnr TYPE rbkp-belnr,
        gjahr TYPE rbkp-gjahr,
        stblg TYPE rbkp-stblg,
        stjah TYPE rbkp-stjah,
      END OF t_rbkp .
    TYPES:
      tt_rbkp
          TYPE SORTED TABLE OF rbkp
          WITH NON-UNIQUE KEY belnr gjahr .
    TYPES:
      BEGIN OF t_skat,
        ktopl TYPE skat-ktopl,
        saknr TYPE skat-saknr,
        txt50 TYPE skat-txt50,
      END OF t_skat .
    TYPES:
      tt_skat
          TYPE HASHED TABLE OF t_skat
          WITH UNIQUE KEY primary_key COMPONENTS ktopl saknr .
    TYPES:
      BEGIN OF t_lfa1,
        lifnr TYPE lfa1-lifnr,
        name1 TYPE lfa1-name1,
      END OF t_lfa1 .
    TYPES:
      tt_lfa1
          TYPE HASHED TABLE OF t_lfa1
          WITH UNIQUE KEY primary_key COMPONENTS lifnr .
    TYPES:
      BEGIN OF t_mseg,
        mblnr TYPE mseg-mblnr,
        mjahr TYPE mseg-mjahr,
        smbln TYPE mseg-smbln,
        sjahr TYPE mseg-sjahr,
      END OF t_mseg .
    TYPES:
      tt_mseg
          TYPE SORTED TABLE OF mseg
          WITH NON-UNIQUE KEY mblnr mjahr .

    TYPES : BEGIN OF ty_bseg_key,
              bukrs TYPE bseg-bukrs,
              belnr TYPE bseg-belnr,
              gjahr TYPE bseg-gjahr,
              buzei TYPE bseg-buzei,
            END OF ty_bseg_key,
            tt_bseg_key TYPE TABLE OF ty_bseg_key.
    TYPES:

      BEGIN OF ty_mkpf_key,
        mblnr TYPE mkpf-mblnr,
        mjahr TYPE mkpf-mjahr,
      END OF ty_mkpf_key .
    TYPES:
      tt_mkpf_key TYPE TABLE OF ty_mkpf_key .
    TYPES:
      BEGIN OF ty_rbkp_key,
        belnr TYPE rbkp-belnr,
        gjahr TYPE rbkp-gjahr,
      END OF ty_rbkp_key .
    TYPES:
      tt_rbkp_key TYPE TABLE OF ty_rbkp_key .
    TYPES:
      BEGIN OF ty_vbrp,
        vbeln TYPE vbrp-vbeln,
        vgtyp TYPE vbrp-vgtyp,
        vgbel TYPE vbrp-vgbel,
        bstkd TYPE vbkd-bstkd,
      END OF ty_vbrp .
    TYPES:
      tt_vbrp TYPE SORTED TABLE OF ty_vbrp
                  WITH NON-UNIQUE KEY vbeln .
    TYPES:
      BEGIN OF ty_vbrk_key,
        vbeln TYPE vbrk-vbeln,
      END OF ty_vbrk_key,
      tt_vbrk_key  TYPE TABLE OF ty_vbrk_key,

      tt_ith_blart TYPE STANDARD TABLE OF zfit_ith_blart WITH DEFAULT KEY.

    CONSTANTS c_tabname_t001 TYPE tabname VALUE 'T001' ##NO_TEXT.
    CLASS-DATA gt_company_long_text TYPE tt_company_long_text .
    CLASS-DATA gt_dg_cache TYPE tt_dg_cache .
    CLASS-DATA gt_import_doc_type_cache TYPE tt_ith_blart .

    CLASS-METHODS get_sd_inv
      IMPORTING
        !it_vbrk_key   TYPE tt_vbrk_key
      RETURNING
        VALUE(rt_vbrp) TYPE tt_vbrp .
ENDCLASS.



CLASS zcl_fi_toolkit IMPLEMENTATION.


  METHOD check_iban_duplicate.

    DATA(lt_tiban) = get_iban_codes(
      it_iban       = it_iban
      iv_get_vendor = iv_get_vendor
      iv_get_client = iv_get_client
      it_lifnr      = it_lifnr
      it_kunnr      = it_kunnr
    ).

    CHECK lt_tiban IS NOT INITIAL.

    ASSIGN lt_tiban[ 1 ] TO FIELD-SYMBOL(<ls_tiban>).

    RAISE EXCEPTION TYPE zcx_fi_iban
      EXPORTING
        textid     = zcx_fi_iban=>already_used
        iban       = <ls_tiban>-iban
        party      = COND #( WHEN <ls_tiban>-kunnr IS NOT INITIAL THEN <ls_tiban>-kunnr
                             WHEN <ls_tiban>-lifnr IS NOT INITIAL THEN <ls_tiban>-lifnr
                           )
        party_type = COND #( WHEN <ls_tiban>-kunnr IS NOT INITIAL THEN TEXT-110
                             WHEN <ls_tiban>-lifnr IS NOT INITIAL THEN TEXT-111
                           ).

  ENDMETHOD.


  METHOD clear_customer_open_items.

    TRY.
        DATA(lo_bdc) = NEW zcl_bc_bdc( ).

        lo_bdc->add_scr(
          iv_prg = 'SAPMF05A'
          iv_dyn = '131'
        ).

        lo_bdc->add_fld(:
          iv_nam = 'BDC_OKCODE' iv_val = '/00' ),
          iv_nam = 'RF05A-XNOPS'   iv_val = 'X' ),
          iv_nam = 'RF05A-XPOS1(03)'   iv_val = 'X' ),
          iv_nam = 'RF05A-AGKON' iv_val = CONV #( im_kunnr ) ),
          iv_nam = 'BKPF-BUKRS' iv_val = CONV #( im_bukrs ) ).
        lo_bdc->add_fld( iv_nam = 'BKPF-WAERS' iv_val = CONV #( im_waers ) ).


        LOOP AT it_belnr INTO DATA(ls_belnr).
          lo_bdc->add_scr(
            iv_prg = 'SAPMF05A'
            iv_dyn = '731'
          ).
          lo_bdc->add_fld(:
            iv_nam = 'BDC_OKCODE' iv_val = '/00' ),
            iv_nam = 'BDC_CURSOR'   iv_val = 'RF05A-SEL01(01)' ),
            iv_nam = 'RF05A-SEL01(01)'   iv_val = CONV #( ls_belnr ) ).
        ENDLOOP.
        lo_bdc->add_fld(:
          iv_nam = 'BDC_OKCODE' iv_val = '=PA' ) .

        lo_bdc->add_scr(
          iv_prg = 'SAPDF05X'
          iv_dyn = '3100'
        ).

        lo_bdc->add_fld(:
          iv_nam = 'BDC_OKCODE' iv_val = '=WAIT_USER' ) .

        lo_bdc->submit(
            iv_tcode  = 'F-32'
            is_option = VALUE #( dismode = zcl_bc_bdc=>c_dismode_error )
        ).


    ENDTRY.











  ENDMETHOD.


  METHOD clear_vendor_open_items.

    TRY.
        DATA(lo_bdc) = NEW zcl_bc_bdc( ).

        lo_bdc->add_scr(
          iv_prg = 'SAPMF05A'
          iv_dyn = '131'
        ).

        lo_bdc->add_fld(:
          iv_nam = 'BDC_OKCODE' iv_val = '/00' ),
          iv_nam = 'RF05A-XNOPS'   iv_val = 'X' ),
          iv_nam = 'RF05A-XPOS1(03)'   iv_val = 'X' ),
          iv_nam = 'RF05A-AGKON' iv_val = CONV #( im_lifnr ) ),
          iv_nam = 'BKPF-BUKRS' iv_val = CONV #( im_bukrs ) ).
        IF im_waers IS NOT INITIAL.
          lo_bdc->add_fld( iv_nam = 'BKPF-WAERS' iv_val = CONV #( im_waers ) ).
        ENDIF.

        LOOP AT it_belnr INTO DATA(ls_belnr).
          lo_bdc->add_scr(
            iv_prg = 'SAPMF05A'
            iv_dyn = '731'
          ).
          lo_bdc->add_fld(:
            iv_nam = 'BDC_OKCODE' iv_val = '/00' ),
            iv_nam = 'BDC_CURSOR'   iv_val = 'RF05A-SEL01(01)' ),
            iv_nam = 'RF05A-SEL01(01)'   iv_val = CONV #( ls_belnr ) ).
        ENDLOOP.
        lo_bdc->add_fld(:
          iv_nam = 'BDC_OKCODE' iv_val = '=PA' ) .

        lo_bdc->add_scr(
          iv_prg = 'SAPDF05X'
          iv_dyn = '3100'
        ).

        lo_bdc->add_fld(:
          iv_nam = 'BDC_OKCODE' iv_val = '=WAIT_USER' ) .

        lo_bdc->submit(
            iv_tcode  = 'F-44'
            is_option = VALUE #( dismode = zcl_bc_bdc=>c_dismode_error ) "VOL-5818
*            is_option = value #( dismode = zcl_bc_bdc=>c_dismode_all )
        ).


    ENDTRY.











  ENDMETHOD.


  METHOD convert_datum_to_gdatu.

    DATA lv_datxt TYPE char10.

    ASSIGN gt_dg_cache[
        KEY primary_key
        COMPONENTS datum = iv_datum
    ] TO FIELD-SYMBOL(<ls_cache>).

    IF sy-subrc NE 0.

      DATA(ls_cache) = VALUE t_dg_cache( datum = iv_datum ).

      WRITE iv_datum TO lv_datxt.

      CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
        EXPORTING
          input  = lv_datxt
        IMPORTING
          output = ls_cache-gdatu.

      INSERT ls_cache INTO TABLE gt_dg_cache ASSIGNING <ls_cache>.

    ENDIF.

    rv_gdatu = <ls_cache>-gdatu.

  ENDMETHOD.


  METHOD denklestirerek_transfer_kaydi.
    DATA:
      lv_group TYPE apqi-groupid,
      lv_mode  TYPE rfpdo-allgazmd VALUE 'E'.
    DATA:
      lt_blntab  TYPE STANDARD TABLE OF blntab ##NEEDED,
      lt_ftclear TYPE STANDARD TABLE OF ftclear ##NEEDED,
      lt_ftpost  TYPE STANDARD TABLE OF ftpost ##NEEDED,
      ls_ftpost  TYPE  ftpost ##NEEDED,
      lt_fttax   TYPE STANDARD TABLE OF fttax ##NEEDED.

    lv_group = sy-tcode.
**********************************************************************
*Definition
    DEFINE ftpost.
      CLEAR ls_ftpost.
      ls_ftpost-stype = &1.
      ls_ftpost-count = &2.
      ls_ftpost-fnam = &3.
      WRITE &4 TO ls_ftpost-fval.
      CONDENSE ls_ftpost-fval.
      APPEND ls_ftpost TO lt_ftpost.
    END-OF-DEFINITION.

    IF it_bseg IS NOT INITIAL.
      SELECT bukrs ,belnr ,gjahr, buzei, koart,umskz FROM bseg
        INTO TABLE @DATA(lt_bseg)
        FOR ALL ENTRIES IN @it_bseg
        WHERE
          bukrs EQ @it_bseg-bukrs AND
          belnr EQ @it_bseg-belnr AND
          gjahr EQ @it_bseg-gjahr AND
          buzei EQ @it_bseg-buzei .                     "#EC CI_NOORDER
    ENDIF.

    LOOP AT lt_bseg INTO DATA(ls_bseg) .
      IF sy-tabix = 1.
        DATA: lv_fname(5) TYPE c.
        CONCATENATE 'BLAR' ls_bseg-koart INTO lv_fname.
        DATA: lv_blart TYPE bkpf-blart.
        SELECT SINGLE (lv_fname) FROM t041a INTO lv_blart
          WHERE auglv = 'UMBUCHNG'.

        ftpost 'K' '1' 'BKPF-BUKRS' ls_bseg-bukrs.
        ftpost 'K' '1' 'BKPF-BLART' lv_blart.
        ftpost 'K' '1' 'BKPF-BLDAT' is_bkpf-bldat.
        ftpost 'K' '1' 'BKPF-BUDAT' is_bkpf-budat.
        ftpost 'K' '1' 'BKPF-XBLNR' is_bkpf-xblnr.
        ftpost 'K' '1' 'BKPF-WAERS' is_bkpf-waers.
        ftpost 'K' '1' 'BKPF-BKTXT' is_bkpf-bktxt.
      ENDIF.
      APPEND INITIAL LINE TO lt_ftclear REFERENCE INTO DATA(lr_ftclear).
      lr_ftclear->agkoa = ls_bseg-koart.
      lr_ftclear->agbuk = ls_bseg-bukrs.
      lr_ftclear->selfd = 'BELNR'.
      IF ls_bseg-umskz NE space.
        lr_ftclear->agums = ls_bseg-umskz.

      ENDIF.
      lr_ftclear->xnops = abap_true.
      CONCATENATE ls_bseg-belnr
                  ls_bseg-gjahr
                  ls_bseg-buzei
             INTO lr_ftclear->selvon.
    ENDLOOP.
    CALL FUNCTION 'POSTING_INTERFACE_START'
      EXPORTING
        i_function         = 'C'    " Using Call Transaction
        i_group            = lv_group
        i_mode             = lv_mode
        i_update           = 'S'
        i_user             = sy-uname
        i_xbdcc            = 'X'
      EXCEPTIONS
        client_incorrect   = 1
        function_invalid   = 2
        group_name_missing = 3
        mode_invalid       = 4
        update_invalid     = 5
        OTHERS             = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING
        i_auglv                    = 'UMBUCHNG'
        i_tcode                    = 'FB05'
      TABLES
        t_blntab                   = lt_blntab
        t_ftclear                  = lt_ftclear
        t_ftpost                   = lt_ftpost
        t_fttax                    = lt_fttax
      EXCEPTIONS
        clearing_procedure_invalid = 1
        clearing_procedure_missing = 2
        table_t041a_empty          = 3
        transaction_code_invalid   = 4
        amount_format_error        = 5
        too_many_line_items        = 6
        company_code_invalid       = 7
        screen_not_found           = 8
        no_authorization           = 9
        OTHERS                     = 10.
    IF sy-subrc = 0 .
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'POSTING_INTERFACE_END'
      EXCEPTIONS
        session_not_processable = 1
        OTHERS                  = 2 ##FM_SUBRC_OK.








  ENDMETHOD.


  METHOD determine_due_date.
    DATA: i_faede TYPE faede,
          e_faede TYPE faede.

    SELECT SINGLE
        shkzg, koart, zfbdt, zbd1t,
        zbd2t, zbd3t, rebzg, rebzt
      FROM bseg
      WHERE
        bukrs EQ @im_document-bukrs AND
        gjahr EQ @im_document-gjahr AND
        belnr EQ @im_document-belnr AND
        buzei EQ @im_document-buzei
      INTO CORRESPONDING FIELDS OF @i_faede.

    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        i_faede                    = i_faede
*       I_GL_FAEDE                 =
      IMPORTING
        e_faede                    = e_faede
      EXCEPTIONS
        account_type_not_supported = 1
        OTHERS                     = 2.

    IF sy-subrc <> 0  ##NEEDED.
* Implement suitable error handling here
    ENDIF .

    re_netdt = e_faede-netdt.




  ENDMETHOD.


  METHOD devir_fblxn.

    DATA : lv_keydt TYPE sy-datum,
           lt_devir TYPE TABLE OF ty_devir_items,
           ls_devir TYPE ty_devir.

    FIELD-SYMBOLS  : <lt_budat> TYPE range_date_t,
                     <lt_saknr> TYPE fagl_mm_t_range_saknr,
                     <lt_bukrs> TYPE tpmy_range_bukrs,
                     <lv_odk>   TYPE any,
                     <lv_apar>  TYPE any.

    CLEAR et_devir.

    CASE sy-cprog.
      WHEN 'RFITEMAP'.
        ASSIGN ('(RFITEMAP)SO_BUDAT[]') TO <lt_budat>.
        ASSIGN ('(RFITEMAP)KD_BUKRS[]') TO <lt_bukrs>.
        ASSIGN ('(RFITEMAP)X_SHBV') TO <lv_odk>.
        ASSIGN ('(RFITEMAP)X_APAR') TO <lv_apar>.

        IF NOT (
          <lt_budat> IS ASSIGNED AND
          <lt_bukrs> IS ASSIGNED AND
          <lv_odk>   IS ASSIGNED AND
          <lv_apar>  IS ASSIGNED
        ).
          RETURN.
        ENDIF.

      WHEN 'RFITEMGL'.
        ASSIGN ('(RFITEMGL)SO_BUDAT[]') TO <lt_budat>.
        ASSIGN ('(RFITEMGL)SD_BUKRS[]') TO <lt_bukrs>.
        ASSIGN ('(RFITEMGL)X_SHBV') TO <lv_odk>.

        IF NOT (
          <lt_budat> IS ASSIGNED AND
          <lt_bukrs> IS ASSIGNED AND
          <lv_odk>   IS ASSIGNED
        ).
          RETURN.
        ENDIF.

      WHEN 'RFITEMAR'.
        ASSIGN ('(RFITEMAR)SO_BUDAT[]') TO <lt_budat>.
        ASSIGN ('(RFITEMAR)DD_BUKRS[]') TO <lt_bukrs>.
        ASSIGN ('(RFITEMAR)X_SHBV') TO <lv_odk>.
        ASSIGN ('(RFITEMAR)X_APAR') TO <lv_apar>.

        IF NOT (
          <lt_budat> IS ASSIGNED AND
          <lt_bukrs> IS ASSIGNED AND
          <lv_odk>   IS ASSIGNED AND
          <lv_apar>  IS ASSIGNED
        ).
          RETURN.
        ENDIF.

      WHEN OTHERS.
        RETURN.
    ENDCASE.



    READ TABLE <lt_budat> INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_budat>).
    IF sy-subrc EQ 0.
      lv_keydt = <ls_budat>-low - 1.
    ELSE.
      RETURN.
    ENDIF.

    CLEAR :lt_devir,et_devir.

    CASE sy-cprog.
      WHEN 'RFITEMAP'.

        IF it_hesap IS INITIAL.
          RETURN.
        ENDIF.

        SELECT
               belnr
               gjahr
               buzei
               bukrs
               lifnr
               shkzg
               dmbtr
               dmbe2
               dmbe3
               umskz
               filkd
               wrbtr
               waers
               INTO TABLE lt_devir
               FROM bsik
               FOR ALL ENTRIES IN it_hesap
               WHERE bukrs IN <lt_bukrs> AND
                     budat LE lv_keydt AND
                     ( lifnr EQ it_hesap-sube OR lifnr EQ it_hesap-merkez ).
        SELECT
               belnr
               gjahr
               buzei
               bukrs
               lifnr
               shkzg
               dmbtr
               dmbe2
               dmbe3
               umskz
               filkd
               wrbtr
               waers
               APPENDING TABLE lt_devir
               FROM bsak
               FOR ALL ENTRIES IN it_hesap
               WHERE bukrs IN <lt_bukrs> AND
                     budat LE lv_keydt AND
                     augdt GT lv_keydt AND
                     ( lifnr EQ it_hesap-sube OR lifnr EQ it_hesap-merkez ).
        IF <lv_apar> EQ abap_true.
          SELECT
                 belnr
                 gjahr
                 buzei
                 bukrs
                 kunnr
                 shkzg
                 dmbtr
                 dmbe2
                 dmbe3
                 umskz
                 filkd
                 wrbtr
                 waers
                 APPENDING TABLE lt_devir
                 FROM bsid
                 FOR ALL ENTRIES IN it_hesap
                 WHERE bukrs IN <lt_bukrs> AND
                       budat LE lv_keydt AND
                       ( kunnr EQ it_hesap-sube OR kunnr EQ it_hesap-merkez ).
          SELECT
                 belnr
                 gjahr
                 buzei
                 bukrs
                 kunnr
                 shkzg
                 dmbtr
                 dmbe2
                 dmbe3
                 umskz
                 filkd
                 wrbtr
                 waers
                 APPENDING TABLE lt_devir
                 FROM bsad
                FOR ALL ENTRIES IN it_hesap
                 WHERE bukrs IN <lt_bukrs> AND
                       budat LE lv_keydt AND
                       augdt GT lv_keydt AND
                       ( kunnr EQ it_hesap-sube OR kunnr EQ it_hesap-merkez ).
        ENDIF.
      WHEN 'RFITEMGL'.
        ASSIGN ('(RFITEMGL)SD_SAKNR[]') TO <lt_saknr>.
        IF sy-subrc EQ 0.

          SELECT
                 belnr
                 gjahr
                 buzei
                 bukrs
                 hkont AS konto
                 shkzg
                 dmbtr AS dmshb
                 dmbe2
                 dmbe3
*                 umskz
*                 filkd
                 wrbtr
                 waers
                 INTO CORRESPONDING FIELDS OF TABLE lt_devir ##TOO_MANY_ITAB_FIELDS
                 FROM bsis
                 WHERE bukrs IN <lt_bukrs> AND
                       budat LE lv_keydt AND
                       hkont IN <lt_saknr>.
          SELECT
                 belnr
                 gjahr
                 buzei
                 bukrs
                 hkont AS konto
                 shkzg
                 dmbtr AS dmshb
                 dmbe2
                 dmbe3
*                 umskz
*                 filkd
                 wrbtr
                 waers
                 APPENDING CORRESPONDING FIELDS OF TABLE lt_devir ##TOO_MANY_ITAB_FIELDS
                 FROM bsas
                 WHERE bukrs IN <lt_bukrs> AND
                       budat LE lv_keydt AND
                       augdt GT lv_keydt AND
                       hkont IN <lt_saknr>.
        ENDIF.
      WHEN 'RFITEMAR'.

        IF it_hesap IS INITIAL.
          RETURN.
        ENDIF.

        SELECT
               belnr
               gjahr
               buzei
               bukrs
               kunnr
               shkzg
               dmbtr
               dmbe2
               dmbe3
               umskz
               filkd
               wrbtr
               waers
               gsber
               INTO TABLE lt_devir
               FROM bsid
               FOR ALL ENTRIES IN it_hesap
               WHERE bukrs IN <lt_bukrs> AND
                     budat LE lv_keydt AND
                     ( kunnr EQ it_hesap-sube OR kunnr EQ it_hesap-merkez ).
        SELECT
               belnr
               gjahr
               buzei
               bukrs
               kunnr
               shkzg
               dmbtr
               dmbe2
               dmbe3
               umskz
               filkd
               wrbtr
               waers
               gsber
               APPENDING TABLE lt_devir
               FROM bsad
              FOR ALL ENTRIES IN it_hesap
               WHERE bukrs IN <lt_bukrs> AND
                     budat LE lv_keydt AND
                     augdt GT lv_keydt AND
                     ( kunnr EQ it_hesap-sube OR kunnr EQ it_hesap-merkez ).
        IF <lv_apar> EQ abap_true.
          SELECT
                 belnr
                 gjahr
                 buzei
                 bukrs
                 lifnr
                 shkzg
                 dmbtr
                 dmbe2
                 dmbe3
                 umskz
                 filkd
                 wrbtr
                 waers
                 gsber
                 APPENDING TABLE lt_devir
                 FROM bsik
                 FOR ALL ENTRIES IN it_hesap
                 WHERE bukrs IN <lt_bukrs> AND
                       budat LE lv_keydt AND
                       ( lifnr EQ it_hesap-sube OR lifnr EQ it_hesap-merkez ).
          SELECT
                 belnr
                 gjahr
                 buzei
                 bukrs
                 lifnr
                 shkzg
                 dmbtr
                 dmbe2
                 dmbe3
                 umskz
                 filkd
                 wrbtr
                 waers
                 gsber
                 APPENDING TABLE lt_devir
                 FROM bsak
                 FOR ALL ENTRIES IN it_hesap
                 WHERE bukrs IN <lt_bukrs> AND
                       budat LE lv_keydt AND
                       augdt GT lv_keydt AND
                       ( lifnr EQ it_hesap-sube OR lifnr EQ it_hesap-merkez ).



        ENDIF.
    ENDCASE.

    IF <lv_odk> IS INITIAL.
      DELETE lt_devir WHERE umskz IS NOT INITIAL.
    ENDIF.

    LOOP AT it_hesap ASSIGNING FIELD-SYMBOL(<ls_hesap>)
            WHERE merkez IS NOT INITIAL.
      DELETE lt_devir WHERE konto EQ <ls_hesap>-merkez AND filkd NE <ls_hesap>-sube.
    ENDLOOP.

    LOOP AT lt_devir ASSIGNING FIELD-SYMBOL(<ls_devir>).
      IF <ls_devir>-shkzg EQ c_alacak.
        MULTIPLY <ls_devir>-dmshb BY -1.
        MULTIPLY <ls_devir>-dmbe2 BY -1.
        MULTIPLY <ls_devir>-dmbe3 BY -1.
        MULTIPLY <ls_devir>-wrbtr BY -1.
      ENDIF.
      CLEAR <ls_devir>-shkzg.
      CLEAR <ls_devir>-umskz.
*{  EDIT  Berrin Ulus 25.04.2016 15:05:25
* HAR-9421
      CLEAR : <ls_devir>-filkd.
*}  EDIT  Berrin Ulus 25.04.2016 15:05:25
      CLEAR ls_devir.
      MOVE-CORRESPONDING <ls_devir> TO ls_devir.
      COLLECT ls_devir INTO et_devir.
    ENDLOOP.


  ENDMETHOD.


  METHOD display_fi_doc_in_gui.

    SET PARAMETER ID:
      'BLN' FIELD iv_belnr,
      'BUK' FIELD iv_bukrs,
      'GJR' FIELD iv_gjahr.

    CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.       "#EC CI_CALLTA

  ENDMETHOD.


  METHOD ekstre_fblxn.
    "--------->> written by mehmet sertkaya 18.12.2015 11:29:39
*--------------------------------------------------------------------*
* E K S T R E
*--------------------------------------------------------------------*

    CHECK ct_items IS NOT INITIAL.
    CASE sy-cprog.
      WHEN 'RFITEMAP'.
        ASSIGN ('(RFITEMAP)X_AISEL') TO FIELD-SYMBOL(<lv_x_aisel>).
        ASSIGN ('(RFITEMAP)PA_VARI') TO FIELD-SYMBOL(<lv_vari>).

      WHEN 'RFITEMGL'.
        ASSIGN ('(RFITEMGL)X_AISEL') TO <lv_x_aisel>.
        ASSIGN ('(RFITEMGL)PA_VARI') TO <lv_vari>.

      WHEN 'RFITEMAR'.
        ASSIGN ('(RFITEMAR)X_AISEL') TO <lv_x_aisel>.
        ASSIGN ('(RFITEMAR)PA_VARI') TO <lv_vari>.

      WHEN 'ZSDP_RFITEMAR'.
        ASSIGN ('(ZSDP_RFITEMAR)X_AISEL') TO <lv_x_aisel>.
        ASSIGN ('(ZSDP_RFITEMAR)PA_VARI') TO <lv_vari>.

      WHEN OTHERS.
        RETURN.

    ENDCASE.

    IF sy-subrc EQ 0 AND sy-cprog(5) EQ 'RFITE'.
      IF <lv_vari> CS 'EKSTRE'.

        IF <lv_x_aisel> NE abap_true.
          MESSAGE TEXT-003 TYPE 'I'.
          RETURN.
        ENDIF.

        CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR' ##FM_SUBRC_OK
          EXPORTING
*           percentage =
            text   = TEXT-002
          EXCEPTIONS
            OTHERS = 1.


        "-->> changed by mehmet sertkaya 21.07.2016 13:52:32
        " HAR-10448 - Müşteri Ekstresinde XX belge ters kaydı
*          delete ct_items where blart eq 'XX' and gjahr ge '2016'.
        LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<ls_items>)
                    WHERE blart EQ zcl_fi_document_type=>get_customer_clearing_doc_type( ) AND
                          gjahr GE '2018'.
          DELETE ct_items WHERE belnr EQ <ls_items>-zzstblg AND gjahr EQ <ls_items>-zzstjah.
          DELETE ct_items.
        ENDLOOP.
        "-----------------------------<


        SORT ct_items BY konto budat ASCENDING.

        IF  ct_items IS INITIAL.
          RETURN.
        ENDIF.

*--------------------------------------------------------------------*
* Devirleri bul
*--------------------------------------------------------------------*
        DATA : lt_devir        TYPE TABLE OF ty_devir,
               lt_devir_sorted TYPE SORTED TABLE OF ty_devir
                               WITH NON-UNIQUE KEY bukrs konto,
               lv_konto_temp   TYPE hkont,
               lt_item_devir   TYPE it_rfposxext,
*               lt_item_sum_top type it_rfposxext,
               lt_item_sum     TYPE it_rfposxext,
               ls_item_devir   TYPE LINE OF it_rfposxext,
               ls_item_sum     TYPE LINE OF it_rfposxext,
               ls_item_sum_    TYPE LINE OF it_rfposxext,
               lv_tabix        TYPE sy-tabix,
               ls_devir        TYPE ty_devir,
*               lt_devir_merkez type sorted table of ty_devir with unique key bukrs konto ##NEEDED,
               ls_devir_merkez TYPE ty_devir,
               lt_mkpf_key     TYPE tt_mkpf_key,
               lt_rbkp_key     TYPE tt_rbkp_key,
               lt_rbkp         TYPE tt_rbkp,
               lt_vbrk_key     TYPE tt_vbrk_key,
               lv_awkey        TYPE awkey,
               lt_mseg         TYPE tt_mseg,
               lt_vbrp         TYPE tt_vbrp,
               ls_hesap        TYPE ty_hesap,
               lt_hesap        TYPE tt_hesap,
               lt_t001         TYPE SORTED TABLE OF t001 WITH UNIQUE KEY bukrs ##NEEDED,
*               lv_konto        type konto,
               lt_konto        TYPE TABLE OF ty_konto,
               ls_konto        TYPE ty_konto,
               lc_green        TYPE col_item VALUE 'C51',
               lc_yellow       TYPE col_item VALUE 'C31'.

        LOOP AT ct_items ASSIGNING <ls_items>.
          CLEAR ls_hesap.
          ls_hesap-sube = <ls_items>-konto.
          COLLECT ls_hesap INTO lt_hesap.
          ls_konto-bukrs = <ls_items>-bukrs.
          ls_konto-konto = <ls_items>-konto.
          COLLECT ls_konto INTO lt_konto.
        ENDLOOP.
        ASSIGN  ('(SAPLFI_ITEMS)GB_CENTRAL_ITEMS') TO FIELD-SYMBOL(<lv_merkez>).
        IF sy-subrc EQ 0.
          IF <lv_merkez> EQ abap_true.
            CASE sy-cprog.
              WHEN 'RFITEMAR' OR 'ZSDP_RFITEMAR'.
                SELECT bukrs, kunnr, knrze INTO TABLE @DATA(lt_knb1) FROM knb1
                    FOR ALL ENTRIES IN @lt_hesap
                    WHERE kunnr EQ @lt_hesap-sube AND
                          knrze NE @space.
                SORT lt_knb1 BY bukrs kunnr.
                LOOP AT lt_knb1 ASSIGNING FIELD-SYMBOL(<ls_knb1>).
                  ls_hesap-sube = <ls_knb1>-kunnr.
                  ls_hesap-merkez = <ls_knb1>-knrze.
                  COLLECT ls_hesap INTO lt_hesap.
                ENDLOOP.

              WHEN 'RFITEMAP'.

                SELECT bukrs, lifnr, lnrze INTO TABLE @DATA(lt_lfb1) FROM lfb1
                    FOR ALL ENTRIES IN @lt_hesap
                    WHERE lifnr EQ @lt_hesap-sube AND
                          lnrze NE @space.
                SORT lt_lfb1 BY bukrs lifnr.
                LOOP AT lt_lfb1 ASSIGNING FIELD-SYMBOL(<ls_lfb1>).
                  ls_hesap-sube   = <ls_lfb1>-lifnr.
                  ls_hesap-merkez = <ls_lfb1>-lnrze.
                  COLLECT ls_hesap INTO lt_hesap.
                ENDLOOP.

            ENDCASE.
          ENDIF.
        ENDIF.
        SELECT * FROM t001  INTO TABLE lt_t001.

        zcl_fi_toolkit=>devir_fblxn(
                    EXPORTING it_hesap = lt_hesap
                    IMPORTING et_devir = lt_devir
                                             ).
        SORT lt_devir BY bukrs konto gsber.
        lt_devir_sorted = lt_devir.

        FREE  : lt_devir,lt_hesap.

*--------------------------------------------------------------------*
* Malzeme belgelerini al - sadece ters kayıt olanlar
*--------------------------------------------------------------------*
        LOOP AT ct_items ASSIGNING <ls_items>
           WHERE zzawtyp EQ c_mal_hareketi OR zzawtyp EQ  c_satinalma_faturasi
               OR  zzawtyp EQ  c_satis_faturasi.
          IF <ls_items>-zzawtyp EQ c_mal_hareketi.
            APPEND VALUE #( mblnr = <ls_items>-zzawkey(10)
                            mjahr = <ls_items>-zzawkey+10(4)
                           ) TO lt_mkpf_key.
          ELSEIF <ls_items>-zzawtyp EQ c_satinalma_faturasi.
            APPEND VALUE #( belnr = <ls_items>-zzawkey(10)
                            gjahr = <ls_items>-zzawkey+10(4)
                           ) TO lt_rbkp_key.
          ELSEIF <ls_items>-zzawtyp EQ c_satis_faturasi.
            APPEND <ls_items>-zzawkey(10) TO lt_vbrk_key.
          ENDIF.
        ENDLOOP.

        SORT lt_rbkp_key BY belnr gjahr.
        SORT lt_mkpf_key BY mblnr mjahr.
        SORT lt_vbrk_key BY vbeln.
        DELETE ADJACENT DUPLICATES FROM lt_mkpf_key COMPARING mblnr mjahr.
        DELETE ADJACENT DUPLICATES FROM lt_rbkp_key COMPARING belnr gjahr.
        DELETE ADJACENT DUPLICATES FROM lt_vbrk_key COMPARING vbeln.

        IF lt_rbkp_key IS NOT INITIAL.

          SELECT belnr, gjahr, stblg, stjah
            FROM rbkp
            FOR ALL ENTRIES IN @lt_rbkp_key
            WHERE
              belnr EQ @lt_rbkp_key-belnr AND
              gjahr EQ @lt_rbkp_key-gjahr
            INTO CORRESPONDING FIELDS OF TABLE @lt_rbkp.

          FREE lt_rbkp_key.
        ENDIF.

* ters kayıt olanların m.b. sini bul
        IF lt_mkpf_key IS NOT INITIAL.
          SELECT mblnr, mjahr, smbln, sjahr
            FROM mseg
            FOR ALL ENTRIES IN @lt_mkpf_key
            WHERE
              mblnr EQ @lt_mkpf_key-mblnr AND
              mjahr EQ @lt_mkpf_key-mjahr
            INTO CORRESPONDING FIELDS OF TABLE @lt_mseg.
          FREE lt_mkpf_key.
* ters kayıt olanların m.b. sini bul
        ENDIF.
        IF lt_vbrk_key[] IS NOT INITIAL.
          lt_vbrp = get_sd_inv( lt_vbrk_key ).
          FREE lt_vbrk_key.
* ters kayıt olanların m.b. sini bul
        ENDIF.
*--------------------------------------------------------------------*
* Ek alanları güncelle
*--------------------------------------------------------------------*
        SORT ct_items BY konto budat ASCENDING.

        LOOP AT ct_items ASSIGNING <ls_items>.
          lv_tabix = sy-tabix.

*  test kayıt belgesi
          IF <ls_items>-zzawtyp EQ c_mal_hareketi.
            READ TABLE lt_mseg WITH TABLE KEY mblnr = <ls_items>-zzawkey(10)
                                              mjahr = CONV #( <ls_items>-zzawkey+10(4) )
                                              ASSIGNING FIELD-SYMBOL(<ls_mseg>).
            IF sy-subrc EQ 0.
* mb 'nin ters kaydınınn faturası
* bu case çok az olacağını için direk bkpf 'e gidildi.
              CLEAR lv_awkey.
              IF <ls_mseg>-smbln IS  NOT INITIAL.
                lv_awkey = |{ <ls_mseg>-smbln }{ <ls_mseg>-sjahr }|.
              ELSE.
                READ TABLE lt_mseg WITH KEY smbln = <ls_mseg>-mblnr
                                            sjahr = <ls_mseg>-mjahr
                                            ASSIGNING <ls_mseg>.

                IF sy-subrc EQ 0.
                  lv_awkey = |{ <ls_mseg>-mblnr }{ <ls_mseg>-mjahr }|.
                ENDIF.
              ENDIF.

            ENDIF.

          ELSEIF <ls_items>-zzawtyp EQ c_satinalma_faturasi.
            READ TABLE lt_rbkp WITH TABLE KEY belnr = <ls_items>-zzawkey(10)
                                              gjahr = CONV #( <ls_items>-zzawkey+10(4) )
                                              ASSIGNING FIELD-SYMBOL(<ls_rbkp>).
            IF sy-subrc EQ 0.
* mb 'nin ters kaydınınn faturası
* bu case çok az olacağını için direk bkpf 'e gidildi.
              CLEAR lv_awkey.
              IF <ls_rbkp>-stblg IS  NOT INITIAL.
                lv_awkey = |{ <ls_rbkp>-stblg }{ <ls_rbkp>-stjah }|.
              ELSE.
                READ TABLE lt_rbkp WITH KEY stblg = <ls_rbkp>-belnr
                                            stjah = <ls_rbkp>-gjahr
                                            ASSIGNING <ls_rbkp>.

                IF sy-subrc EQ 0.
                  lv_awkey = |{ <ls_rbkp>-belnr }{ <ls_rbkp>-gjahr }|.
                ENDIF.
              ENDIF.

            ENDIF.
          ELSEIF <ls_items>-zzawtyp EQ c_satis_faturasi.
            READ TABLE lt_vbrp WITH TABLE KEY vbeln = <ls_items>-zzawkey(10)
                                        ASSIGNING FIELD-SYMBOL(<ls_vbrp>).
            IF sy-subrc EQ 0.
              IF <ls_vbrp>-vgtyp = 'J' OR <ls_vbrp>-vgtyp = 'T'.
                <ls_items>-zzteslimat = <ls_vbrp>-vgbel.
              ENDIF.
              <ls_items>-zzbstkd = <ls_vbrp>-bstkd.
            ENDIF.
          ENDIF.

          IF lv_awkey IS  NOT INITIAL.
            SELECT SINGLE belnr INTO <ls_items>-zzstblg FROM bkpf
                          WHERE awtyp = <ls_items>-zzawtyp AND
                                awkey = lv_awkey
                          ##WARN_OK .                   "#EC CI_NOORDER
            IF sy-subrc EQ 0.
              <ls_items>-zzstjah = <ls_items>-gjahr.
            ENDIF.
          ENDIF.
****************************************************************************************************

          IF lv_konto_temp IS INITIAL OR
             lv_konto_temp NE <ls_items>-konto.
* Devir kalemini ekle
            CLEAR : ls_devir,ls_devir_merkez.

            LOOP AT lt_devir_sorted INTO ls_devir
              WHERE bukrs = <ls_items>-bukrs
                AND konto = <ls_items>-konto.

              IF <lv_merkez> IS ASSIGNED.
                IF <lv_merkez> EQ abap_true.
                  CASE sy-cprog.
                    WHEN 'RFITEMAP'.
                      READ TABLE lt_lfb1 ASSIGNING <ls_lfb1>
                                         WITH KEY bukrs = <ls_items>-bukrs
                                                  lifnr = <ls_items>-konto BINARY SEARCH.
                      IF sy-subrc EQ 0.
                        LOOP AT lt_devir_sorted ASSIGNING FIELD-SYMBOL(<lfs_devir_sorted_lnrze>)
                                                WHERE bukrs = <ls_items>-bukrs
                                                  AND konto = <ls_lfb1>-lnrze.
*                          append <lfs_devir_sorted_lnrze> to lt_devir_merkez.
                          ADD <lfs_devir_sorted_lnrze>-dmshb TO ls_devir_merkez-dmshb.
                          ADD <lfs_devir_sorted_lnrze>-dmbe2 TO ls_devir_merkez-dmbe2.
                          ADD <lfs_devir_sorted_lnrze>-dmbe3 TO ls_devir_merkez-dmbe3.
                          ADD <lfs_devir_sorted_lnrze>-wrbtr TO ls_devir_merkez-wrbtr.
                        ENDLOOP.
                      ENDIF.
                    WHEN 'RFITEMAR' OR 'ZSDP_RFITEMAR'.
                      READ TABLE lt_knb1 ASSIGNING <ls_knb1>
                                         WITH KEY bukrs = <ls_items>-bukrs
                                                  kunnr = <ls_items>-konto BINARY SEARCH.
                      IF sy-subrc EQ 0.
                        LOOP AT lt_devir_sorted ASSIGNING FIELD-SYMBOL(<lfs_devir_sorted_knrze>)
                                                WHERE bukrs = <ls_items>-bukrs
                                                  AND konto = <ls_knb1>-knrze.
*                          append <lfs_devir_sorted_knrze> to lt_devir_merkez.
                          ADD <lfs_devir_sorted_knrze>-dmshb TO ls_devir_merkez-dmshb.
                          ADD <lfs_devir_sorted_knrze>-dmbe2 TO ls_devir_merkez-dmbe2.
                          ADD <lfs_devir_sorted_knrze>-dmbe3 TO ls_devir_merkez-dmbe3.
                          ADD <lfs_devir_sorted_knrze>-wrbtr TO ls_devir_merkez-wrbtr.
                        ENDLOOP.

                      ENDIF.
                  ENDCASE.
                ENDIF.
              ENDIF.

              CLEAR ls_item_devir.
              IF ls_devir-bukrs IS INITIAL.
                MOVE-CORRESPONDING ls_devir_merkez TO ls_item_devir  ##ENH_OK.
                ls_item_devir-wrshb =  ls_devir_merkez-wrbtr.
                ls_item_devir-waers =  ls_devir_merkez-waers.
              ELSE.
                ADD ls_devir_merkez-dmshb TO ls_devir-dmshb.
                ADD ls_devir_merkez-dmbe2 TO ls_devir-dmbe2.
                ADD ls_devir_merkez-dmbe3 TO ls_devir-dmbe3.
                ADD ls_devir_merkez-wrbtr TO ls_devir-wrbtr.

                MOVE-CORRESPONDING ls_devir TO ls_item_devir  ##ENH_OK.
                ls_item_devir-wrshb =  ls_devir-wrbtr.
                ls_item_devir-waers =  ls_devir-waers.

              ENDIF.

              ls_item_devir-zzname1_ku = <ls_items>-zzname1_ku.
              ls_item_devir-zzname1_li = <ls_items>-zzname1_li.
              ls_item_devir-konto = <ls_items>-konto.
              ls_item_devir-zuonr = TEXT-dvg.
              ls_item_devir-u_bktxt =  ls_item_devir-sgtxt  = |{ TEXT-004 }({ <ls_items>-konto })|.
              ls_item_devir-hwaer = <ls_items>-hwaer.
              ls_item_devir-hwae2 = <ls_items>-hwae2.
              ls_item_devir-hwae3 = <ls_items>-hwae3.
              IF ls_item_devir-dmshb LT 0.
                ls_item_devir-zzalacak_upb = ls_item_devir-dmshb * -1.
                ls_item_devir-zzalacak_2pb = ls_item_devir-dmbe2 * -1.
                ls_item_devir-zzalacak_3pb = ls_item_devir-dmbe3 * -1.
              ELSE.
                ls_item_devir-zzborc_upb = ls_item_devir-dmshb.
                ls_item_devir-zzborc_2pb = ls_item_devir-dmbe2.
                ls_item_devir-zzborc_3pb = ls_item_devir-dmbe3.
              ENDIF.
              ls_item_devir-bukrs = <ls_items>-bukrs.
              ls_item_devir-konto = <ls_items>-konto.
              ls_item_devir-color = lc_green.

              COLLECT ls_item_devir INTO lt_item_devir.

              CLEAR ls_item_sum.
              ls_item_sum-wrshb = ls_item_devir-wrshb.
              ls_item_sum-waers = ls_item_devir-waers.
              ls_item_sum-dmshb = ls_item_devir-dmshb.
              ls_item_sum-hwaer = ls_item_devir-hwaer.
              ls_item_sum_-hwaer = ls_item_sum-hwaer.

              ADD ls_item_sum-dmshb TO ls_item_sum_-dmshb.

              ls_item_sum-color = lc_yellow.
*              collect ls_item_sum into lt_item_sum_top."kullanılmıyor
            ENDLOOP.
            IF sy-subrc NE 0.
* devir yoksa boş devir yazısı yazalım.
              CLEAR ls_item_devir.
              ls_item_devir-bukrs = <ls_items>-bukrs.
              ls_item_devir-konto = <ls_items>-konto.
              ls_item_devir-zuonr = TEXT-dvg.
              ls_item_devir-color = lc_green.
              ls_item_devir-zzname1_ku = <ls_items>-zzname1_ku.
              ls_item_devir-zzname1_li = <ls_items>-zzname1_li.
              ls_item_devir-u_bktxt =  ls_item_devir-sgtxt  = |{ TEXT-004 }({ <ls_items>-konto })|.
              INSERT ls_item_devir INTO ct_items INDEX lv_tabix.

              ls_item_sum_-bukrs = <ls_items>-bukrs.
              ls_item_sum_-konto = <ls_items>-konto.
              ls_item_sum_-zzname1_ku = <ls_items>-zzname1_ku.
              ls_item_sum_-zzname1_li = <ls_items>-zzname1_li.
              ls_item_sum_-zuonr = TEXT-dvy.
              ls_item_sum_-color = lc_yellow.
              ls_item_sum_-u_bktxt =  ls_item_sum_-sgtxt  = |{ TEXT-004 }({ <ls_items>-konto })|.
              INSERT ls_item_sum_ INTO ct_items INDEX lv_tabix + 1.


            ELSE.
              ls_item_sum_-bukrs = <ls_items>-bukrs.
              ls_item_sum_-konto = <ls_items>-konto.
              ls_item_sum_-zzname1_ku = <ls_items>-zzname1_ku.
              ls_item_sum_-zzname1_li = <ls_items>-zzname1_li.
              ls_item_sum_-zuonr = TEXT-dvy.
              ls_item_sum_-color = lc_yellow.

              IF ls_item_sum_-dmshb LT 0.
                ls_item_sum_-zzalacak_upb = ls_item_sum_-dmshb.
              ELSE.
                ls_item_sum_-zzborc_upb = ls_item_sum_-dmshb.
              ENDIF.

              ls_item_sum_-u_bktxt =  ls_item_sum_-sgtxt  = |{ TEXT-004 }({ <ls_items>-konto })|.
              ls_item_devir = ls_item_sum_.
              APPEND ls_item_sum_ TO lt_item_devir.
              INSERT LINES OF lt_item_devir INTO ct_items INDEX lv_tabix.
              FREE lt_item_devir.
            ENDIF.
            CLEAR ls_item_sum_.

          ENDIF.

          IF <ls_items>-shkzg EQ c_alacak.
            <ls_items>-zzalacak_upb = <ls_items>-dmshb * -1.
            <ls_items>-zzalacak_2pb = <ls_items>-dmbe2 * -1.
            <ls_items>-zzalacak_3pb = <ls_items>-dmbe3 * -1.
          ELSE.
            <ls_items>-zzborc_upb = <ls_items>-dmshb.
            <ls_items>-zzborc_2pb = <ls_items>-dmbe2.
            <ls_items>-zzborc_3pb = <ls_items>-dmbe3.
          ENDIF.

          <ls_items>-zzbakiye_upb =  ls_item_devir-dmshb =
                                     ls_item_devir-dmshb +
                                     <ls_items>-dmshb.

          <ls_items>-zzbakiye_2pb =  ls_item_devir-dmbe2 =
                                     ls_item_devir-dmbe2 +
                                     <ls_items>-dmbe2.

          <ls_items>-zzbakiye_3pb =  ls_item_devir-dmbe3 =
                                     ls_item_devir-dmbe3 +
                                     <ls_items>-dmbe3.


          lv_konto_temp = <ls_items>-konto.


        ENDLOOP.

        FREE : lt_mseg,lt_vbrp,lt_rbkp.
* dönem sonu bakiyeleri ekle
        LOOP AT lt_konto INTO ls_konto.
          REFRESH lt_item_sum.
          CLEAR ls_item_sum.
          CLEAR ls_item_sum_.
          LOOP AT ct_items ASSIGNING <ls_items>
            WHERE bukrs EQ ls_konto-bukrs
              AND konto EQ ls_konto-konto.
            lv_tabix = sy-tabix.
            CHECK <ls_items>-color NE lc_yellow.
            CHECK <ls_items>-hwaer IS NOT INITIAL.
            ls_item_sum-bukrs = <ls_items>-bukrs.
            ls_item_sum-konto = <ls_items>-konto.
            ls_item_sum-gsber = <ls_items>-gsber.
            ls_item_sum-wrshb = <ls_items>-wrshb.
            ls_item_sum-waers = <ls_items>-waers.
            ls_item_sum-dmshb = <ls_items>-dmshb.
            ls_item_sum-hwaer = <ls_items>-hwaer.
            ls_item_sum-zuonr = TEXT-dng.
            ls_item_sum-color = lc_green.
            ls_item_sum-u_bktxt =  ls_item_sum-sgtxt  = |{ TEXT-005 }({ <ls_items>-konto })|.

            ls_item_sum_-bukrs = <ls_items>-bukrs.
            ls_item_sum_-konto = <ls_items>-konto.
            ls_item_sum_-u_bktxt =  ls_item_sum-sgtxt  = |{ TEXT-005 }({ <ls_items>-konto })|.
            ls_item_sum_-zuonr = TEXT-dny.
            ls_item_sum_-color = lc_yellow.
            ADD ls_item_sum-dmshb TO ls_item_sum_-dmshb.
            ls_item_sum_-hwaer = ls_item_sum-hwaer.

            COLLECT ls_item_sum INTO lt_item_sum.
          ENDLOOP.

          ADD 1 TO lv_tabix.
          APPEND ls_item_sum_ TO lt_item_sum.
          APPEND INITIAL LINE TO lt_item_sum.

          INSERT LINES OF lt_item_sum INTO ct_items INDEX lv_tabix.

        ENDLOOP.
      ENDIF.
    ELSE.

      LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<ls_items1>)
          WHERE  zzawtyp EQ  c_satis_faturasi.
        IF <ls_items1>-zzawtyp EQ c_satis_faturasi.
          APPEND <ls_items1>-zzawkey(10) TO lt_vbrk_key.
        ENDIF.
      ENDLOOP.

      SORT lt_vbrk_key BY vbeln.
      DELETE ADJACENT DUPLICATES FROM lt_vbrk_key COMPARING vbeln.

      IF lt_vbrk_key[] IS NOT INITIAL.

        lt_vbrp = get_sd_inv( lt_vbrk_key ).
        FREE lt_vbrk_key.

        LOOP AT ct_items ASSIGNING <ls_items> WHERE zzawtyp EQ c_satis_faturasi.
          READ TABLE lt_vbrp INTO DATA(ls_vbrp)
                           WITH KEY vbeln = <ls_items>-zzawkey(10)
                                    BINARY SEARCH.
          IF sy-subrc EQ 0.
            IF ls_vbrp-vgtyp = 'J' OR ls_vbrp-vgtyp = 'T'.
              <ls_items>-zzteslimat = ls_vbrp-vgbel.
            ENDIF.
            <ls_items>-zzbstkd = ls_vbrp-bstkd.
          ENDIF.
        ENDLOOP.

      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD get_bkpf_xblnr.

    DATA lt_doc TYPE tt_doc_xblnr.

    CHECK ct_doc[] IS NOT INITIAL.

    SELECT bukrs belnr gjahr xblnr
           INTO CORRESPONDING FIELDS OF TABLE lt_doc
           FROM bkpf
           FOR ALL ENTRIES IN ct_doc
           WHERE bukrs EQ ct_doc-bukrs
             AND belnr EQ ct_doc-belnr
             AND gjahr EQ ct_doc-gjahr.

    SORT lt_doc BY bukrs belnr gjahr.

    LOOP AT ct_doc ASSIGNING FIELD-SYMBOL(<ls_doc_tar>).

      READ TABLE lt_doc ASSIGNING FIELD-SYMBOL(<ls_doc_src>)
                        WITH KEY bukrs = <ls_doc_tar>-bukrs
                                 belnr = <ls_doc_tar>-belnr
                                 gjahr = <ls_doc_tar>-gjahr
                        BINARY SEARCH.

      IF sy-subrc EQ 0.
        <ls_doc_tar>-xblnr = <ls_doc_src>-xblnr.
      ELSE.
        CLEAR <ls_doc_tar>-xblnr.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_company_long_text.

    ASSIGN gt_company_long_text[ KEY primary_key
                                 COMPONENTS bukrs = iv_bukrs
                               ] TO FIELD-SYMBOL(<ls_clt>).

    IF sy-subrc NE 0.

      DATA(ls_clt) = VALUE t_company_long_text( bukrs = iv_bukrs ).

      SELECT SINGLE adrnr, butxt
             INTO @DATA(ls_t001)
             FROM t001
             WHERE bukrs EQ @iv_bukrs.

      IF sy-subrc NE 0.
        RAISE EXCEPTION TYPE zcx_bc_table_content
          EXPORTING
            textid   = zcx_bc_table_content=>entry_missing
            objectid = CONV #( iv_bukrs )
            tabname  = c_tabname_t001.
      ENDIF.

      ls_clt-text = ls_t001-butxt.

      IF ls_t001-adrnr IS NOT INITIAL.

        SELECT SINGLE name1, name2, name3, name4
               INTO @DATA(ls_adrc)
               FROM adrc
               WHERE addrnumber EQ @ls_t001-adrnr
                 AND date_from  LE @sy-datum
                 AND date_to    GE @sy-datum
               ##WARN_OK .                              "#EC CI_NOORDER

        IF ls_adrc-name1 IS NOT INITIAL OR
           ls_adrc-name2 IS NOT INITIAL OR
           ls_adrc-name3 IS NOT INITIAL OR
           ls_adrc-name4 IS NOT INITIAL.

          ls_clt-text = |{ ls_adrc-name1 } { ls_adrc-name2 } { ls_adrc-name3 } { ls_adrc-name4 }|.

        ENDIF.

      ENDIF.

      INSERT ls_clt INTO TABLE gt_company_long_text ASSIGNING <ls_clt>.

    ENDIF.

    rv_text = <ls_clt>-text.

  ENDMETHOD.


  METHOD get_iban_codes.

    IF iv_get_vendor IS NOT INITIAL.

      SELECT lfa1~lifnr, tiban~*
        APPENDING CORRESPONDING FIELDS OF TABLE @rt_tiban
        FROM lfa1
             INNER JOIN lfbk ON lfbk~lifnr EQ lfa1~lifnr
             INNER JOIN tiban ON tiban~banks EQ lfbk~banks AND
                                 tiban~bankl EQ lfbk~bankl AND
                                 tiban~bankn EQ lfbk~bankn AND
                                 tiban~bkont EQ lfbk~bkont
        WHERE lfa1~lifnr IN @it_lifnr AND
              tiban~iban IN @it_iban
        ##TOO_MANY_ITAB_FIELDS.

    ENDIF.

    IF iv_get_client IS NOT INITIAL.

      SELECT kna1~lifnr, tiban~*
        APPENDING CORRESPONDING FIELDS OF TABLE @rt_tiban
        FROM kna1
             INNER JOIN knbk ON knbk~kunnr EQ kna1~kunnr
             INNER JOIN tiban ON tiban~banks EQ knbk~banks AND
                                 tiban~bankl EQ knbk~bankl AND
                                 tiban~bankn EQ knbk~bankn AND
                                 tiban~bkont EQ knbk~bkont
        WHERE kna1~lifnr IN @it_kunnr AND
              tiban~iban IN @it_iban
        ##TOO_MANY_ITAB_FIELDS.

    ENDIF.

  ENDMETHOD.

  METHOD get_domestic_import_doc_types.

    get_import_document_types( ). " Cache dolsun diye

    rt_blart = VALUE #( FOR _blart IN gt_import_doc_type_cache
                        WHERE ( is_foreign  EQ abap_true AND
                                is_domestic EQ abap_true )
                        ( _blart-blart ) ).

  ENDMETHOD.

  METHOD get_import_document_types.

    IF gt_import_doc_type_cache IS INITIAL.
      SELECT * FROM zfit_ith_blart INTO TABLE @gt_import_doc_type_cache.
    ENDIF.

    DATA(lt_returnable_blart) = gt_import_doc_type_cache.

    IF iv_include_domestic EQ abap_false.
      DELETE lt_returnable_blart WHERE is_domestic EQ abap_true.
    ENDIF.

    IF iv_include_foreign EQ abap_false.
      DELETE lt_returnable_blart WHERE is_foreign EQ abap_true.
    ENDIF.

    rt_blart = VALUE #( FOR _blart IN lt_returnable_blart ( _blart-blart ) ).

  ENDMETHOD.


  METHOD get_sd_inv.

    CHECK it_vbrk_key IS NOT INITIAL.

    SELECT DISTINCT vbrp~vbeln
                    vbrp~vgtyp
                    vbrp~vgbel
                    vbkd~bstkd
       INTO TABLE rt_vbrp
       FROM vbrp
       LEFT OUTER JOIN vbkd
               ON vbkd~vbeln EQ vbrp~aubel AND
                  vbkd~posnr EQ '000000'
       FOR ALL ENTRIES IN it_vbrk_key
       WHERE vbrp~vbeln EQ it_vbrk_key-vbeln.

  ENDMETHOD.


  METHOD modify_report_falgll03_flbxn.
*--------------------------------------------------------------------*
* written by mehmet sertkaya 17.12.2015 15:54:51
*--------------------------------------------------------------------*
* FBL*N veya FAGLL03 işlem kodundan iki ayrı yapıda tablo gelebilir.
*--------------------------------------------------------------------*
    DATA : lt_bkpf          TYPE tt_bkpf,
           lt_bseg          TYPE SORTED TABLE OF ty_bseg WITH NON-UNIQUE KEY bukrs belnr gjahr,
           lt_skat          TYPE tt_skat,
           lt_anla          TYPE tt_anla,
           lt_anla_key      TYPE tt_anla_key,
*           ls_skat          type skat,
           lt_temp          TYPE TABLE OF ty_bseg,
           ls_temp          TYPE ty_bseg,
           ls_rfpos         TYPE rfposxext,
           lv_bkpf_keyc     TYPE char21,
           lt_bseg_key      TYPE tt_bseg_key,
           lv_bkpf_key      TYPE bkpf_key,
           ls_bkpf_addon    TYPE bkpf_addon,
           lt_kunnr         TYPE TABLE OF kna1-kunnr,
           lt_lifnr         TYPE TABLE OF lfa1-lifnr,
           lt_kunnr_yp      TYPE TABLE OF kna1-kunnr,
           lt_lifnr_yp      TYPE TABLE OF lfa1-lifnr,
           lt_kna1_yp       TYPE SORTED TABLE OF t_kna1 WITH UNIQUE KEY kunnr,
           lt_kna1          TYPE SORTED TABLE OF t_kna1 WITH UNIQUE KEY kunnr,
           lt_lfa1_yp       TYPE tt_lfa1,
           lt_lfa1          TYPE tt_lfa1,
           lv_yevmiye       TYPE char100,
           lv_karsit_hesap  TYPE char100,
           lv_yevmiyex      TYPE char1,
           lv_karsit_hesapx TYPE char1,
           lv_main_program  TYPE sy-repid,
           lr_ktopl         TYPE RANGE OF ktopl,
           lt_hkont         TYPE TABLE OF bseg-hkont,
           lt_mkpf_key      TYPE tt_mkpf_key,
           lt_vbrk_key      TYPE tt_vbrk_key.

    FIELD-SYMBOLS : <lt_data>  TYPE STANDARD TABLE,
                    <lv_stblg> TYPE stblg.

    ASSIGN ir_data->* TO <lt_data>.

    IF sy-subrc NE 0 OR ( sy-subrc EQ 0 AND <lt_data> IS INITIAL ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR' ##FM_SUBRC_OK
      EXPORTING
        text   = TEXT-001
      EXCEPTIONS
        OTHERS = 1.


*--------------------------------------------------------------------*
* Seçim ekranı girişlerini oku
*--------------------------------------------------------------------*
*    case sy-tcode.
*      when 'FBL1N'. lv_main_program = 'RFITEMAP'.
*      when 'FBL3N'. lv_main_program = 'RFITEMGL'.
*      when 'FBL5N'. lv_main_program = 'RFITEMAR'.
*    endcase.

    lv_main_program = sy-cprog.

    IF lv_main_program IS NOT INITIAL.
      lv_yevmiye      = |({ lv_main_program })P_YEVMIY|.
      lv_karsit_hesap = |({ lv_main_program })P_KARSIT|.
      ASSIGN (lv_yevmiye) TO FIELD-SYMBOL(<lv_yevmiye>).
      IF sy-subrc EQ 0.
        lv_yevmiyex = <lv_yevmiye>.
      ENDIF.
      ASSIGN (lv_karsit_hesap) TO FIELD-SYMBOL(<lv_karsit_hesap>).
      IF sy-subrc EQ 0.
        lv_karsit_hesapx = <lv_karsit_hesap>.
      ENDIF.
    ENDIF.

*--------------------------------------------------------------------*
* Ek verileri doldur
*--------------------------------------------------------------------*
* anahtar alanları doldur
    CLEAR : ls_rfpos.

    LOOP AT <lt_data> ASSIGNING FIELD-SYMBOL(<ls_data>).
      MOVE-CORRESPONDING <ls_data> TO ls_rfpos.
      CLEAR ls_temp.
      ls_temp-bukrs = ls_rfpos-bukrs.
      ls_temp-belnr = ls_rfpos-belnr.
      ls_temp-gjahr = ls_rfpos-gjahr.
      COLLECT ls_temp INTO lt_temp .

      IF ls_rfpos-konto IS NOT INITIAL AND
         ls_rfpos-koart EQ 'D'.
        COLLECT ls_rfpos-konto INTO lt_kunnr.
        COLLECT ls_rfpos-filkd INTO lt_kunnr.
      ENDIF.
      IF ls_rfpos-konto IS NOT INITIAL AND
         ls_rfpos-koart EQ 'K'.
        COLLECT ls_rfpos-konto INTO lt_lifnr.
      ENDIF.

      IF ls_rfpos-zzawtyp EQ 'MKPF'.
        APPEND VALUE #( mblnr = ls_rfpos-zzawkey(10)
                        mjahr = ls_rfpos-zzawkey+10(4)
                     ) TO lt_mkpf_key.
      ENDIF.
      IF ls_rfpos-zzawtyp EQ 'VBRK'.
        APPEND VALUE #( vbeln = ls_rfpos-zzawkey(10)
                     ) TO lt_vbrk_key.
      ENDIF.
      IF ls_rfpos-blart EQ 'YP'.
        APPEND VALUE #( bukrs = ls_rfpos-bukrs
                        gjahr = ls_rfpos-sgtxt+13(4)
                        belnr = ls_rfpos-sgtxt+0(10)
                        buzei = ls_rfpos-sgtxt+10(3)   ) TO lt_bseg_key.
      ENDIF.
    ENDLOOP.

    SORT lt_vbrk_key BY vbeln.
    DELETE ADJACENT DUPLICATES FROM lt_vbrk_key COMPARING vbeln.

    SORT lt_mkpf_key BY mblnr mjahr.
    DELETE ADJACENT DUPLICATES FROM lt_mkpf_key COMPARING mblnr mjahr.

    IF lt_mkpf_key IS NOT INITIAL.
      SELECT mblnr,mjahr,bwart INTO TABLE @DATA(lt_mseg)
            FROM mseg
            FOR ALL ENTRIES IN @lt_mkpf_key
            WHERE mblnr EQ @lt_mkpf_key-mblnr AND
                  mjahr EQ @lt_mkpf_key-mjahr.
      SORT lt_mseg BY mblnr mjahr.
    ENDIF.
    IF lt_vbrk_key IS NOT INITIAL.
      SELECT vbrp~vbeln,lips~bwart INTO TABLE @DATA(lt_vbrp)
             FROM vbrp
             INNER JOIN lips
                     ON lips~vbeln EQ vbrp~vgbel
             FOR ALL ENTRIES IN @lt_vbrk_key
             WHERE vbrp~vbeln EQ @lt_vbrk_key-vbeln.
      SORT lt_vbrp BY vbeln.

    ENDIF.
    IF lt_bseg_key IS NOT INITIAL.
      SELECT bukrs,gjahr,belnr,buzei,lifnr,kunnr INTO TABLE @DATA(lt_bseg_yp)
        FROM bseg
        FOR ALL ENTRIES IN @lt_bseg_key
        WHERE bukrs EQ @lt_bseg_key-bukrs
          AND gjahr EQ @lt_bseg_key-gjahr
          AND belnr EQ @lt_bseg_key-belnr
          AND buzei EQ @lt_bseg_key-buzei.              "#EC CI_NOORDER

      SORT lt_bseg_yp BY bukrs gjahr belnr buzei.

      LOOP AT lt_bseg_yp INTO DATA(ls_bseg_yp).
        IF ls_bseg_yp-kunnr IS NOT INITIAL.
          COLLECT ls_bseg_yp-kunnr INTO lt_kunnr_yp.
        ENDIF.
        IF ls_bseg_yp-lifnr IS NOT INITIAL.
          COLLECT ls_bseg_yp-lifnr INTO lt_lifnr_yp.
        ENDIF.
      ENDLOOP.

      IF lt_kunnr_yp IS NOT INITIAL.
        SELECT kunnr name1
           INTO TABLE lt_kna1_yp FROM kna1
           FOR ALL ENTRIES IN lt_kunnr_yp
           WHERE kunnr EQ lt_kunnr_yp-table_line.
      ENDIF.
      IF lt_lifnr_yp IS NOT INITIAL.
        SELECT lifnr, name1
          FROM lfa1
          FOR ALL ENTRIES IN @lt_lifnr_yp
          WHERE lifnr EQ @lt_lifnr_yp-table_line
          INTO CORRESPONDING FIELDS OF TABLE @lt_lfa1_yp .
      ENDIF.

    ENDIF.


    IF sy-cprog EQ 'RFITEMAR' OR sy-cprog EQ 'ZSDP_RFITEMAR'.
      SELECT * INTO TABLE @DATA(lt_sube)
      FROM zfit_belge_sube
      FOR ALL ENTRIES IN @lt_temp
      WHERE bukrs EQ @lt_temp-bukrs AND
            belnr EQ @lt_temp-belnr AND
            gjahr EQ @lt_temp-gjahr.
      SORT lt_sube BY bukrs belnr gjahr.
      LOOP AT lt_sube REFERENCE INTO DATA(lr_sube).
        COLLECT lr_sube->subehes INTO lt_kunnr.
      ENDLOOP.
    ENDIF.
*--------------------------------------------------------------------*
* müşteri ve satıcılar
*--------------------------------------------------------------------*
    IF lt_kunnr IS NOT INITIAL.
      SELECT kunnr name1
         INTO TABLE lt_kna1 FROM kna1
         FOR ALL ENTRIES IN lt_kunnr
         WHERE kunnr EQ lt_kunnr-table_line.
    ENDIF.
    IF lt_lifnr IS NOT INITIAL.
      SELECT lifnr, name1
        FROM lfa1
        FOR ALL ENTRIES IN @lt_lifnr
        WHERE lifnr EQ @lt_lifnr-table_line
        INTO CORRESPONDING FIELDS OF TABLE @lt_lfa1 .
    ENDIF.

    IF lt_temp[] IS INITIAL.
      RETURN.
    ENDIF.

* belge başlık oku
    SELECT
        bukrs, belnr, gjahr, stblg, stjah,
        awtyp, awkey, xreversal, xstov , bstat
      FROM bkpf
      FOR ALL ENTRIES IN @lt_temp
      WHERE
        bukrs EQ @lt_temp-bukrs AND
        belnr EQ @lt_temp-belnr AND
        gjahr EQ @lt_temp-gjahr
      INTO CORRESPONDING FIELDS OF TABLE @lt_bkpf.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    LOOP AT <lt_data> ASSIGNING <ls_data>.
      MOVE-CORRESPONDING <ls_data> TO ls_rfpos.
      READ TABLE lt_bkpf
        ASSIGNING FIELD-SYMBOL(<ls_bkpf>)
        WITH TABLE KEY primary_key COMPONENTS
          bukrs = ls_rfpos-bukrs
          belnr = ls_rfpos-belnr
          gjahr = ls_rfpos-gjahr.

      CHECK sy-subrc EQ 0.

      IF ls_rfpos-zzawtyp EQ 'MKPF'.
        APPEND VALUE #( mblnr = ls_rfpos-zzawkey(10)
                        mjahr = ls_rfpos-zzawkey+10(4)
                     ) TO lt_mkpf_key.
      ENDIF.
      IF ls_rfpos-zzawtyp EQ 'VBRK'.
        APPEND VALUE #( vbeln = ls_rfpos-zzawkey(10)
                     ) TO lt_vbrk_key.
      ENDIF.
      IF ls_rfpos-blart EQ 'YP'.
        APPEND VALUE #( bukrs = ls_rfpos-bukrs
                        gjahr = ls_rfpos-sgtxt+13(4)
                        belnr = ls_rfpos-sgtxt+0(10)
                        buzei = ls_rfpos-sgtxt+10(3)   ) TO lt_bseg_key.
      ENDIF.
    ENDLOOP.

    DATA(lt_bkpf_l) = VALUE tt_bkpf( FOR ls_bkpff IN lt_bkpf WHERE ( bstat = 'L' ) ( ls_bkpff ) ) .
    DELETE lt_bkpf WHERE bstat EQ 'L'.
* belge kalemlerini oku
    IF lt_bkpf[] IS NOT INITIAL.
      SELECT bukrs
             belnr
             gjahr
             buzei
             kunnr
             lifnr
             hkont
             koart
             vbeln
             vbel2
             posn2
             anln1
             anln2
        INTO CORRESPONDING FIELDS OF TABLE lt_bseg ##TOO_MANY_ITAB_FIELDS
        FROM bseg
        FOR ALL ENTRIES IN lt_bkpf
        WHERE bukrs EQ lt_bkpf-bukrs AND
              belnr EQ lt_bkpf-belnr AND
              gjahr EQ lt_bkpf-gjahr.                   "#EC CI_NOORDER
    ENDIF.
    IF lt_bkpf_l[] IS NOT INITIAL.
      SELECT bukrs
             belnr
             gjahr
             buzei
             hkont
             koart
             anln1
             anln2
        APPENDING CORRESPONDING FIELDS OF TABLE lt_bseg ##TOO_MANY_ITAB_FIELDS
        FROM bseg_add
        FOR ALL ENTRIES IN lt_bkpf_l
        WHERE bukrs EQ lt_bkpf_l-bukrs AND
              belnr EQ lt_bkpf_l-belnr AND
              gjahr EQ lt_bkpf_l-gjahr.
    ENDIF.
**********************************************
* ek alanları bul

    SELECT * FROM t001 INTO TABLE @DATA(lt_t001)
      FOR ALL ENTRIES IN @lt_temp
      WHERE bukrs EQ @lt_temp-bukrs.

    LOOP AT lt_t001 ASSIGNING FIELD-SYMBOL(<ls_t001>).
      APPEND INITIAL LINE TO lr_ktopl REFERENCE INTO DATA(ls_ktopl).
      ls_ktopl->sign = 'I'.
      ls_ktopl->option = 'EQ'.
      ls_ktopl->low = <ls_t001>-ktopl.
    ENDLOOP.

    IF lt_bseg[] IS NOT INITIAL.
      LOOP AT lt_bseg INTO DATA(ls_bseg).
        COLLECT ls_bseg-hkont INTO lt_hkont.
        IF ls_bseg-anln1 IS NOT INITIAL.
          APPEND INITIAL LINE TO lt_anla_key ASSIGNING FIELD-SYMBOL(<ls_anla_key>).
          MOVE-CORRESPONDING ls_bseg TO <ls_anla_key>.
        ENDIF.
      ENDLOOP.
      SORT lt_anla_key.
      DELETE ADJACENT DUPLICATES FROM lt_anla_key COMPARING bukrs anln1 anln2.

      SELECT ktopl, saknr, txt50
        FROM skat
        FOR ALL ENTRIES IN @lt_hkont
        WHERE
          spras EQ @sy-langu AND
          ktopl IN @lr_ktopl AND
          saknr EQ @lt_hkont-table_line
        INTO CORRESPONDING FIELDS OF TABLE @lt_skat.

      IF lt_anla_key IS NOT INITIAL.
        SELECT bukrs, anln1, anln2, txt50
          FROM anla
          FOR ALL ENTRIES IN @lt_anla_key
          WHERE
            bukrs EQ @lt_anla_key-bukrs AND
            anln1 EQ @lt_anla_key-anln1 AND
            anln2 EQ @lt_anla_key-anln2
          INTO CORRESPONDING FIELDS OF TABLE @lt_anla.
      ENDIF.

    ENDIF.


    LOOP AT <lt_data> ASSIGNING <ls_data>.

      CLEAR : ls_temp,lt_temp,ls_rfpos.

      MOVE-CORRESPONDING <ls_data> TO ls_temp.
      MOVE-CORRESPONDING <ls_data> TO ls_rfpos.


*   Net vade tarihi düzeltilmesi.
      "--------->> add by mehmet sertkaya 21.12.2016 13:18:13
*     if ls_rfpos-blart eq 'TK'.
* Bütün Belge türlerinde yapılacağı için bu kısım kaldırıldı.
      "-----------------------------<<
      DATA(lv_zfbdt) = ls_rfpos-zfbdt.
      IF ls_rfpos-zbd3t IS NOT INITIAL .
        lv_zfbdt = lv_zfbdt + ls_rfpos-zbd3t.
      ELSEIF ls_rfpos-zbd2t IS NOT INITIAL .
        lv_zfbdt = lv_zfbdt + ls_rfpos-zbd2t.
      ELSEIF ls_rfpos-zbd1t IS NOT INITIAL .
        lv_zfbdt = lv_zfbdt + ls_rfpos-zbd1t.
      ENDIF.
      IF lv_zfbdt <> ls_rfpos-faedt .
        ls_rfpos-faedt = lv_zfbdt.
      ENDIF.
*    endif.


*--------------------------------------------------------------------*
* Referans anahtar
*--------------------------------------------------------------------*
      READ TABLE lt_bkpf
        ASSIGNING <ls_bkpf>
        WITH TABLE KEY primary_key COMPONENTS
          bukrs = ls_temp-bukrs
          belnr = ls_temp-belnr
          gjahr = ls_temp-gjahr.

      IF sy-subrc EQ 0.
        ls_rfpos-zzstblg = <ls_bkpf>-stblg.
        ls_rfpos-zzstjah = <ls_bkpf>-stjah.
        ls_rfpos-zzawtyp = <ls_bkpf>-awtyp.
        ls_rfpos-zzawkey = <ls_bkpf>-awkey.
        ls_rfpos-zzxreversal = <ls_bkpf>-xreversal.
        ls_rfpos-zzxstov     = <ls_bkpf>-xstov.

*{VOL-8570 at 03.04.2019
        ASSIGN COMPONENT 'U_STBLG' OF STRUCTURE <ls_data> TO <lv_stblg>.
        IF <lv_stblg> IS ASSIGNED.
          <lv_stblg>     = <ls_bkpf>-stblg.
        ENDIF.
*}VOL-8570

      ENDIF.



*--------------------------------------------------------------------*
* Yevmiye No
*--------------------------------------------------------------------*
      IF lv_yevmiyex EQ abap_true.

        TRY.

            DATA(lv_tabname) = SWITCH #(
              ls_rfpos-monat
              WHEN '01' THEN '/FITE/LDG_T009'
              WHEN '02' THEN '/FITE/LDG_T010'
              WHEN '03' THEN '/FITE/LDG_T011'
              WHEN '04' THEN '/FITE/LDG_T012'
              WHEN '05' THEN '/FITE/LDG_T013'
              WHEN '06' THEN '/FITE/LDG_T014'
              WHEN '07' THEN '/FITE/LDG_T015'
              WHEN '08' THEN '/FITE/LDG_T016'
              WHEN '09' THEN '/FITE/LDG_T017'
              WHEN '10' THEN '/FITE/LDG_T018'
              WHEN '11' THEN '/FITE/LDG_T019'
              WHEN '12' THEN '/FITE/LDG_T020'
            ).

            IF lv_tabname IS NOT INITIAL.

              SELECT SINGLE journal_no
                FROM (lv_tabname)
                WHERE
                  bukrs      EQ @ls_rfpos-bukrs AND
                  gjahr      EQ @ls_rfpos-gjahr AND
                  belnr      EQ @ls_rfpos-belnr AND
                  budat_long EQ @ls_rfpos-budat
                INTO @ls_rfpos-zzyevmiyeno.

            ENDIF.

          CATCH cx_root ##no_handler.

        ENDTRY.

        CLEAR lv_tabname.

      ENDIF.
*--------------------------------------------------------------------*
* Müşteri & Satıcı Adı
*--------------------------------------------------------------------*
      CASE ls_rfpos-koart.
        WHEN 'K'."satıcı adı

          ls_rfpos-zzname1_li = VALUE #(
            lt_lfa1[
                KEY primary_key COMPONENTS
                lifnr = ls_rfpos-konto
              ]-name1
            DEFAULT space
          ).

        WHEN 'D'."müşteri adı
          READ TABLE lt_kna1 ASSIGNING FIELD-SYMBOL(<ls_kna1>)
                             WITH TABLE KEY kunnr = ls_rfpos-konto.
          IF sy-subrc EQ 0.
            ls_rfpos-zzname1_ku = <ls_kna1>-name1.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
      IF ls_rfpos-filkd IS NOT INITIAL.
        READ TABLE lt_kna1 ASSIGNING <ls_kna1>
                           WITH TABLE KEY kunnr = ls_rfpos-filkd.
        IF sy-subrc EQ 0.
          ls_rfpos-zzfilkd_text = <ls_kna1>-name1.
        ENDIF.
      ENDIF.

      READ TABLE lt_sube ASSIGNING FIELD-SYMBOL(<ls_sube>)
                       WITH KEY bukrs = ls_temp-bukrs
                                  belnr = ls_temp-belnr
                                  gjahr = ls_temp-gjahr
                                  BINARY SEARCH.
      IF sy-subrc = 0.

        ls_rfpos-filkd = <ls_sube>-subehes.
*{  EDIT  Berrin Ulus 02.02.2016 18:27:22
*             ls_rfpos-ZZFILKD_TEXT = <ls_sube>-subead.
        READ TABLE lt_kna1 ASSIGNING <ls_kna1>
                           WITH TABLE KEY kunnr = <ls_sube>-subehes.
        IF sy-subrc EQ 0.
          ls_rfpos-zzfilkd_text = <ls_kna1>-name1.
        ENDIF.
*}  EDIT  Berrin Ulus 02.02.2016 18:27:22

      ENDIF.
*--------------------------------------------------------------------*
* Karşıt hesap
*--------------------------------------------------------------------*
      IF lv_karsit_hesapx EQ abap_true.
        "belge bölünmüş mü ?
        IF sy-cprog EQ 'RFITEMAP' OR sy-cprog EQ 'RFITEMAR' OR sy-cprog EQ 'ZSDP_RFITEMAR'.
          SELECT SINGLE awkey INTO @DATA(lv_awkey) FROM bkpf
                        WHERE bukrs EQ @ls_temp-bukrs AND
                              belnr EQ @ls_temp-belnr AND
                              gjahr EQ @ls_temp-gjahr AND
                              xsplit EQ 'X'.
          IF sy-subrc EQ 0.

            SELECT SINGLE bukrs, belnr, gjahr INTO @DATA(ls_bkpfx) FROM bkpf
                          WHERE bukrs EQ @ls_temp-bukrs AND
                                belnr NE @ls_temp-belnr AND
                                gjahr EQ @ls_temp-gjahr AND
                                awkey EQ @lv_awkey.     "#EC CI_NOORDER
            IF sy-subrc EQ 0.
              SELECT SINGLE buzei INTO @DATA(lv_buzei) FROM bseg
                            WHERE bukrs EQ @ls_bkpfx-bukrs AND
                                  belnr EQ @ls_bkpfx-belnr AND
                                  gjahr EQ @ls_bkpfx-gjahr AND
                                  hkont EQ '0899000200'. "#EC CI_NOORDER
            ENDIF.

            IF lv_buzei IS  NOT INITIAL.
              CALL FUNCTION 'GET_GKONT'
                EXPORTING
                  belnr           = ls_bkpfx-belnr
                  bukrs           = ls_bkpfx-bukrs
                  buzei           = lv_buzei
                  gjahr           = ls_bkpfx-gjahr
                  gknkz           = '3'
                IMPORTING
                  gkont           = ls_temp-gkont
                EXCEPTIONS
                  belnr_not_found = 1
                  buzei_not_found = 2
                  gknkz_not_found = 3
                  OTHERS          = 4 ##FM_SUBRC_OK.
            ELSE.
              CALL FUNCTION 'GET_GKONT'
                EXPORTING
                  belnr           = ls_temp-belnr
                  bukrs           = ls_temp-bukrs
                  buzei           = ls_temp-buzei
                  gjahr           = ls_temp-gjahr
                  gknkz           = '3'
                IMPORTING
                  gkont           = ls_temp-gkont
                EXCEPTIONS
                  belnr_not_found = 1
                  buzei_not_found = 2
                  gknkz_not_found = 3
                  OTHERS          = 4 ##FM_SUBRC_OK.
            ENDIF.
          ELSE.
            CALL FUNCTION 'GET_GKONT'
              EXPORTING
                belnr           = ls_temp-belnr
                bukrs           = ls_temp-bukrs
                buzei           = ls_temp-buzei
                gjahr           = ls_temp-gjahr
                gknkz           = '3'
              IMPORTING
                gkont           = ls_temp-gkont
              EXCEPTIONS
                belnr_not_found = 1
                buzei_not_found = 2
                gknkz_not_found = 3
                OTHERS          = 4 ##FM_SUBRC_OK.
          ENDIF.
        ENDIF.
      ENDIF.
      LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<ls_bseg>)
                      WHERE bukrs EQ ls_temp-bukrs AND
                            belnr EQ ls_temp-belnr AND
                            gjahr EQ ls_temp-gjahr .

        APPEND <ls_bseg> TO lt_temp.
        IF ls_temp-vbeln IS INITIAL.
          ls_temp-vbeln = <ls_bseg>-vbeln.
        ENDIF.
        IF ls_temp-vbel2 IS INITIAL.
          ls_temp-vbel2 = <ls_bseg>-vbel2.
        ENDIF.
        IF ls_temp-posn2 IS INITIAL.
          ls_temp-posn2 = <ls_bseg>-posn2.
        ENDIF.
        IF sy-cprog EQ 'RFITEMGL' OR sy-cprog EQ 'FAGL_ACCOUNT_ITEMS_GL'.
          IF <ls_bseg>-kunnr IS NOT INITIAL AND <ls_bseg>-koart EQ c_koart_kunnr.
            ls_temp-gkont = <ls_bseg>-kunnr.
          ELSEIF <ls_bseg>-lifnr IS NOT INITIAL AND <ls_bseg>-koart EQ c_koart_lifnr.
            ls_temp-gkont = <ls_bseg>-lifnr.
          ENDIF.
        ELSEIF ( sy-cprog EQ 'RFITEMAP' AND ls_temp-konto EQ ls_temp-gkont ) OR
               ( sy-cprog EQ 'RFITEMAR' AND ls_temp-konto EQ ls_temp-gkont ) OR
               ( sy-cprog EQ 'ZSDP_RFITEMAR' AND ls_temp-konto EQ ls_temp-gkont )
          .
          IF <ls_bseg>-hkont(4) NE '0320' AND
             <ls_bseg>-hkont(4) NE '0120'.
            ls_temp-gkont = <ls_bseg>-hkont.
          ENDIF.
        ENDIF.
      ENDLOOP.
      " HAR-13267 - Ekom faturalarında şube adı ve şube hesabı alanl
      " bu koşullara uyan az belge olduğundan performans dikkate alınmadı
*--------------------------------------------------------------------*
* ZEXP
*--------------------------------------------------------------------*
      IF ls_rfpos-zuonr(2) EQ 'EX' AND ls_rfpos-filkd IS INITIAL.

        SELECT SINGLE bkpf~* INTO @DATA(ls_bkpf)
          FROM
            zexpgrp
            INNER JOIN zexp_ex_fat ON zexp_ex_fat~ziinum EQ zexpgrp~iinum
            INNER JOIN bkpf ON
              bkpf~xblnr EQ zexp_ex_fat~vbeln AND
              bkpf~blart EQ 'RV'
          WHERE zexpgrp~ramno EQ @ls_rfpos-zuonr(12)
          ##WARN_OK.                                    "#EC CI_NOORDER
        IF sy-subrc NE 0.
          CLEAR ls_bkpf.
        ENDIF.

        " Aşağıdaki kodun benzeri, ZSDI_RFITEMAR01 ALACAK_BORC_DOL
        " içinde de var.

        SELECT SINGLE filkd
          INTO ls_rfpos-filkd
          FROM bseg
          WHERE (
            bukrs EQ ls_bkpf-bukrs AND
            belnr EQ ls_bkpf-belnr AND
            gjahr EQ ls_bkpf-gjahr AND
            filkd NE space
          ) ##WARN_OK.                                  "#EC CI_NOORDER

        SELECT SINGLE name1 INTO ls_rfpos-zzfilkd_text FROM kna1
           WHERE kunnr EQ ls_rfpos-filkd.
*->VOL-5051 08.03.2018 09:29:58  Erkan Göktaş
        IF ls_rfpos-filkd IS INITIAL AND
           ls_rfpos-rebzg IS NOT INITIAL AND
           ls_rfpos-gjahr EQ '2017'..
* 2017 belgeleri tamamen ödenmediği için belgelerin şubeleri bu şekilde dolduruluyor.
          SELECT SINGLE * FROM zfit_belge_sube INTO @DATA(ls_belge_sube)
            WHERE belnr = @ls_rfpos-rebzg
              AND bukrs = @ls_rfpos-bukrs
              AND gjahr = '2017'.
          IF sy-subrc = 0 .
            ls_rfpos-filkd = ls_belge_sube-subehes.
            ls_rfpos-zzfilkd_text = ls_belge_sube-subead.
          ENDIF.
        ENDIF.
*<- VOL-5051
        IF ls_rfpos-filkd IS INITIAL AND ls_rfpos-gjahr GT '2017'.
          SELECT SINGLE belnr INTO @DATA(lv_bsad_belnr) FROM bsad WHERE
                          augbl EQ @ls_rfpos-augbl AND
                          belnr NE @ls_rfpos-belnr AND
                          gjahr EQ '2017'.              "#EC CI_NOORDER
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM zfit_belge_sube INTO ls_belge_sube
            WHERE belnr EQ lv_bsad_belnr
            AND bukrs   EQ ls_rfpos-bukrs
            AND gjahr   EQ '2017'.
            IF sy-subrc EQ 0.
              ls_rfpos-filkd        = ls_belge_sube-subehes.
              ls_rfpos-zzfilkd_text = ls_belge_sube-subead.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.


      IF ls_rfpos-zzawtyp = 'MKPF'.

        READ TABLE lt_mseg INTO DATA(ls_mseg)
                   WITH KEY  mblnr = ls_rfpos-zzawkey(10)
                             mjahr = ls_rfpos-zzawkey+10(4)
                             BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_rfpos-zzbwart = ls_mseg-bwart.
        ENDIF.

      ELSEIF ls_rfpos-zzawtyp = 'VBRK'.

        READ TABLE lt_vbrp INTO DATA(ls_vbrp)
                   WITH KEY vbeln = ls_rfpos-zzawkey(10)
                            BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_rfpos-zzbwart = ls_vbrp-bwart.
        ENDIF.

      ENDIF.
      "--------->> add by mustafa sarıbaş 6.10.2017 10:00:00
      "VOL-1311 Ekstre (Müşteri/Satıcı/Defter-i Kebir)
      IF ls_rfpos-blart EQ 'YP'.

        READ TABLE lt_bseg_yp INTO ls_bseg_yp
                   WITH KEY bukrs = ls_rfpos-bukrs
                            gjahr = ls_rfpos-sgtxt+13(4)
                            belnr = ls_rfpos-sgtxt+0(10)
                            buzei = ls_rfpos-sgtxt+10(3)
                            BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF ls_bseg_yp-kunnr IS NOT INITIAL.

            ls_rfpos-zzkunnr = ls_bseg_yp-kunnr.

            READ TABLE lt_kna1 ASSIGNING <ls_kna1>
                               WITH TABLE KEY kunnr = ls_bseg_yp-kunnr.
            IF sy-subrc EQ 0.
              ls_rfpos-zzname1_ku = <ls_kna1>-name1.
            ENDIF.

          ENDIF.

          IF ls_bseg_yp-lifnr IS NOT INITIAL.

            ls_rfpos-zzlifnr = ls_bseg_yp-lifnr.

            ls_rfpos-zzname1_li = VALUE #(
              lt_lfa1_yp[
                  KEY primary_key COMPONENTS
                  lifnr = ls_bseg_yp-lifnr
                ]-name1
              DEFAULT space
            ).

          ENDIF.
        ENDIF.

      ENDIF.
      IF ls_rfpos-koart EQ 'K'.
        LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<ls_bseg_hkont>)
                        WHERE bukrs EQ ls_rfpos-bukrs AND
                              belnr EQ ls_rfpos-belnr AND
                              gjahr EQ ls_rfpos-gjahr .

          ls_rfpos-zzkarshsp = |{ ls_rfpos-zzkarshsp } { <ls_bseg_hkont>-hkont }|.
        ENDLOOP.
      ENDIF.

      READ TABLE lt_t001 INTO DATA(ls_t001)
      WITH KEY bukrs =  ls_rfpos-bukrs.

      ls_rfpos-zzname1_gl = VALUE #(
        lt_skat[
            KEY primary_key COMPONENTS
            ktopl = ls_t001-ktopl
            saknr = ls_rfpos-hkont
          ]-txt50
        DEFAULT space
      ).

      IF ls_rfpos-bschl BETWEEN '70' AND '75'.
* anln1 ve 2 alanları boş, onları okuyoruz.
        READ TABLE lt_bseg ASSIGNING FIELD-SYMBOL(<ls_bseg_read>)
          WITH TABLE KEY bukrs = ls_rfpos-bukrs
                         belnr = ls_rfpos-belnr
                         gjahr = ls_rfpos-gjahr .

        ls_rfpos-zzname1_dv = VALUE #(
          lt_anla[
              KEY primary_key COMPONENTS
              bukrs = ls_rfpos-bukrs
              anln1 = <ls_bseg_read>-anln1
              anln2 = <ls_bseg_read>-anln2
            ]-txt50
          DEFAULT space
        ).

      ENDIF.

      MOVE-CORRESPONDING ls_rfpos TO <ls_data>.
      MOVE-CORRESPONDING ls_temp TO <ls_data>.

    ENDLOOP.

  ENDMETHOD.


  METHOD update_xblnr.

    DATA: lv_mblnr_initial TYPE mblnr,
          lv_vbeln_initial TYPE vbeln_vl,
          lv_rbeln_initial TYPE re_belnr.

    LOOP AT it_xblnr ASSIGNING FIELD-SYMBOL(<ls_xblnr>).

      CALL FUNCTION 'J_1B_NFE_UPDATE_XBLNR'
        EXPORTING
          iv_xblnr = <ls_xblnr>-xblnr
          iv_rbeln = lv_rbeln_initial
          iv_mblnr = lv_mblnr_initial
          iv_vbeln = lv_vbeln_initial
          iv_bukrs = <ls_xblnr>-bukrs
          iv_belnr = <ls_xblnr>-belnr
          iv_gjahr = <ls_xblnr>-gjahr.

      CHECK iv_commit_each_doc EQ abap_true.
      COMMIT WORK AND WAIT.

    ENDLOOP.

    IF iv_commit_each_doc EQ abap_false.
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.


  METHOD validate_zhrtip.

    " Muaf işlem kodları """"""""""""""""""""""""""""""""""""""""""""

    CHECK NOT (
      sy-tcode EQ 'FB1D' OR
      sy-tcode EQ 'FB1K' OR
      sy-tcode EQ 'F.80' OR
      sy-tcode EQ 'FB08'
    ).

    " Muaf şirket kodları """""""""""""""""""""""""""""""""""""""""""
    " Tabloda Buffer olduğundan, özel Cache'leme yapmadım
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    SELECT SINGLE mandt
      FROM zfit_ifrs_haric
      WHERE bukrs EQ @iv_bukrs
      INTO @sy-mandt ##write_ok .

    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

    " Hatalı giriş kontrolü """""""""""""""""""""""""""""""""""""""""

    IF
      (
        iv_acc_first_char EQ '5' AND
        iv_zhrtip(2) NE 'OK'
      )
      OR
      (
        iv_acc_first_char EQ '9' AND
        iv_zhrtip+1(2) NE 'TH'
      ).

      RAISE EXCEPTION TYPE zcx_fi_zhrtip.

    ENDIF.

  ENDMETHOD.
ENDCLASS.