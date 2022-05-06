INTERFACE zsu_es_constants
  PUBLIC .
  CONSTANTS:

    c_custom_grp_endpoint      TYPE zsu_es_detail-fieldname         VALUE 'ENDPOINT_GROUP',
    c_custom_grp_apikey        TYPE zsu_es_detail-fieldname         VALUE 'APIKEY_GROUP',
    c_custom_dtl_ariba_token   TYPE zsu_es_detail-configurationid   VALUE 'ARIBA_TOKEN',
    c_custom_url               TYPE zsu_es_detail-customizingvalue  VALUE 'https://api-eu.ariba.com/v2/oauth/token',
    c_custom_dtl_ariba_api_key TYPE zsu_es_detail-configurationid   VALUE 'ARIBA_APIKEY',
    c_custom_dtl_auth          TYPE zsu_es_detail-customizingvalue  VALUE 'Basic NDA5ZmUyYmEtNDYwYi00NGU2LWEyYzktOGRiNThkNjQ1NDEzOlhiOVBqbndJUkhhb0hGNVZCbUZlUTU4TUs3VHdOZnZy',
    c_custom_accept            TYPE zsu_es_detail-customizingvalue  VALUE '*/*',
    c_custom_connection        TYPE zsu_es_detail-customizingvalue  VALUE 'keep-alive',
    c_custom_content           TYPE zsu_es_detail-customizingvalue  VALUE 'application/x-www-form-urlencoded',
    c_custom_encoding          TYPE zsu_es_detail-customizingvalue  VALUE 'gzip, deflate, br',
    c_custom_body              TYPE zsu_es_detail-customizingvalue  VALUE 'grant_type=openapi_2lo',
    c_custom_acceptkey         TYPE zsu_es_detail-configurationid  VALUE 'ACCEPT',
    c_custom_connkey           TYPE zsu_es_detail-configurationid  VALUE 'CONNECTION',
    c_custom_contentkey        TYPE zsu_es_detail-configurationid  VALUE 'CONTENT',
    c_custom_encodekey         TYPE zsu_es_detail-configurationid  VALUE 'ENCODING',
    c_custom_bodykey           TYPE zsu_es_detail-configurationid  VALUE 'BODY',
    c_custom_urlkey            TYPE zsu_es_detail-configurationid  VALUE 'URL'.

ENDINTERFACE.
