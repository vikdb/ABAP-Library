CLASS zcl_bc_dms_toolkit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF t_doc_key,
             dokar TYPE draw-dokar,
             doknr TYPE draw-doknr,
             dokvr TYPE draw-dokvr,
             doktl TYPE draw-doktl,
           END OF t_doc_key.

    CLASS-METHODS:
      create_doc
        IMPORTING
          !is_key          TYPE t_doc_key
          !iv_file_name    TYPE filep
          !iv_file_content TYPE orblk
        RAISING
          zcx_bc_function_subrc,

      get_doc_content
        IMPORTING
          !is_key         TYPE t_doc_key
        EXPORTING
          !es_description TYPE dktxt
          !et_txt         TYPE sdokcntascs
          !et_bin         TYPE sdokcntbins
        RAISING
          zcx_bc_file_read,

      get_doc_list
        IMPORTING !iv_dokar      TYPE draw-dokar
        RETURNING VALUE(rt_list) TYPE dms_tbl_drat.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF c_content_provide,
                 internal_table TYPE dms_content_provide VALUE 'TBL',
               END OF c_content_provide.

ENDCLASS.



CLASS zcl_bc_dms_toolkit IMPLEMENTATION.

  METHOD create_doc.
    DATA(lt_files) = VALUE cvapi_tbl_doc_files( ( filename = iv_file_name ) ).

    DATA(lt_content) = VALUE dms_tbl_drao( ( dokar = is_key-dokar
                                             doknr = is_key-doknr
                                             dokvr = is_key-dokvr
                                             doktl = is_key-doktl
                                             appnr = 2
                                             zaehl = 1
                                             orln  = 0 " ?
                                             orbkl = 0 " ?
                                             orblk = iv_file_content ) ).

    DATA(ls_messages) = VALUE messages( ).

    CALL FUNCTION 'CVAPI_DOC_CHECKIN'
      EXPORTING
        pf_dokar           = is_key-dokar
        pf_doknr           = is_key-doknr
        pf_dokvr           = is_key-dokvr
        pf_doktl           = is_key-doktl
        pf_content_provide = c_content_provide-internal_table
      IMPORTING
        psx_message        = ls_messages
      TABLES
        pt_files_x         = lt_files
        pt_content         = lt_content.

    CASE ls_messages-msg_type.
      WHEN zcl_bc_applog_facade=>c_msgty_a OR
           zcl_bc_applog_facade=>c_msgty_e OR
           zcl_bc_applog_facade=>c_msgty_x.

        RAISE EXCEPTION TYPE zcx_bc_function_subrc
          EXPORTING
            textid     = zcx_bc_function_subrc=>function_returned_error_txt
            funcname   = 'CVAPI_DOC_CHECKIN'
            error_text = CONV #( ls_messages-msg_txt ).

      WHEN OTHERS.
        COMMIT WORK AND WAIT.
    ENDCASE.

  ENDMETHOD.


  METHOD get_doc_content.
    CLEAR: et_txt, et_bin, es_description.

    TRY.
        DATA(lt_docfiles) = VALUE bapi_tt_doc_files2( ).
        DATA(lt_description) = VALUE tt_dms_bapi_doc_drat( ).

        CALL FUNCTION 'BAPI_DOCUMENT_GETDETAIL2'
          EXPORTING
            documenttype         = is_key-dokar
            documentnumber       = is_key-doknr
            documentpart         = is_key-doktl
            documentversion      = is_key-dokvr
            getactivefiles       = abap_false
            getdocdescriptions   = abap_true
            getdocfiles          = abap_true
          TABLES
            documentfiles        = lt_docfiles
            documentdescriptions = lt_description.

        IF lt_docfiles IS INITIAL.
          RAISE EXCEPTION TYPE zcx_bc_file_read
            EXPORTING
              textid    = zcx_bc_file_read=>file_doesnt_exist
              file_path = |{ is_key-dokar } { is_key-doknr } { is_key-doktl } { is_key-dokvr }|.
        ENDIF.

        ASSIGN lt_docfiles[ 1 ] TO FIELD-SYMBOL(<ls_docfile>). " Tek dosya olacağı varsayıldı

        CALL FUNCTION 'SCMS_DOC_READ'
          EXPORTING
            stor_cat              = <ls_docfile>-storagecategory
            doc_id                = <ls_docfile>-file_id
          TABLES
            content_txt           = et_txt
            content_bin           = et_bin
          EXCEPTIONS
            bad_storage_type      = 1
            bad_request           = 2
            unauthorized          = 3
            comp_not_found        = 4
            not_found             = 5
            forbidden             = 6
            conflict              = 7
            internal_server_error = 8
            error_http            = 9
            error_signature       = 10
            error_config          = 11
            error_format          = 12
            error_parameter       = 13
            error                 = 14
            OTHERS                = 15
            ##FM_SUBRC_OK.

        zcx_bc_function_subrc=>raise_if_sysubrc_not_initial( 'SCMS_DOC_READ' ).

        es_description = VALUE #( lt_description[ 1 ]-description DEFAULT space ).

      CATCH cx_root INTO DATA(lo_diaper).
        RAISE EXCEPTION TYPE zcx_bc_file_read
          EXPORTING
            textid    = zcx_bc_file_read=>cant_read_file
            previous  = lo_diaper
            file_path = |{ is_key-dokar } { is_key-doknr } { is_key-doktl } { is_key-dokvr }|.
    ENDTRY.
  ENDMETHOD.


  METHOD get_doc_list.
    SELECT * FROM drat
             WHERE dokar EQ @iv_dokar
             INTO CORRESPONDING FIELDS OF TABLE @rt_list.

    SORT rt_list BY dokar doknr doktl dokvr langu DESCENDING.
    DELETE ADJACENT DUPLICATES FROM rt_list COMPARING dokar doknr doktl dokvr.
  ENDMETHOD.

ENDCLASS.