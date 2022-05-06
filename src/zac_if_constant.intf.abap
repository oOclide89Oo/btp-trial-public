INTERFACE zac_if_constant
  PUBLIC .

    CONSTANTS: c_custom_grp_endpoint      TYPE zrap_fieldname                  VALUE 'ENDPOINT_GROUP',
               c_custom_grp_apikey        TYPE zrap_fieldname                  VALUE 'APIKEY_GROUP',
               c_custom_dtl_ariba_token   TYPE zrap_ac_detail-configurationid  VALUE 'ARIBA_TOKEN',
               c_custom_dtl_ariba_api_key TYPE zrap_ac_detail-configurationid  VALUE 'ARIBA_APIKEY',
               c_custom_auth              TYPE zrap_ac_detail-customizingvalue VALUE 'Basic NDA5ZmUyYmEtNDYwYi00NGU2LWEyYzktOGRiNThkNjQ1NDEzOlhiOVBqbndJUkhhb0hGNVZCbUZlUTU4TUs3VHdOZnZy',
               c_custom_content           TYPE zrap_ac_detail-customizingvalue VALUE 'application/x-www-form-urlencoded',
               c_custom_accept            TYPE zrap_ac_detail-customizingvalue VALUE '*/*',
               c_custom_encoding          TYPE zrap_ac_detail-customizingvalue VALUE 'gzip, deflate, br',
               c_custom_connection        TYPE zrap_ac_detail-customizingvalue VALUE 'keep-alive',
               c_custom_body              TYPE zrap_ac_detail-customizingvalue VALUE 'grant_type=openapi_2lo',
               c_custom_acceptkey         TYPE zrap_ac_detail-configurationid  VALUE 'ACCEPT',
               c_custom_connkey           TYPE zrap_ac_detail-configurationid  VALUE 'CONNECTION',
               c_custom_contentkey        TYPE zrap_ac_detail-configurationid  VALUE 'CONTENT',
               c_custom_encodekey         TYPE zrap_ac_detail-configurationid  VALUE 'ENCODING',
               c_custom_bodykey           TYPE zrap_ac_detail-configurationid  VALUE 'BODY'.
ENDINTERFACE.
