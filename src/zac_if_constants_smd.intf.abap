INTERFACE zac_if_constants_smd
  PUBLIC .

    CONSTANTS: c_custom_grp_endpoint      TYPE zac_fname_master    VALUE 'ENDPOINT_GROUP',
               c_custom_grp_apikey        TYPE zac_fname_master    VALUE 'APIKEY_GROUP',
               c_custom_dtl_ariba_token   TYPE zac_configurationid VALUE 'ARIBA_TOKEN',
               c_custom_dtl_ariba_api_key TYPE zac_configurationid VALUE 'ARIBA_APIKEY',
               c_custom_auth              TYPE zac_customvalue     VALUE 'Basic NDA5ZmUyYmEtNDYwYi00NGU2LWEyYzktOGRiNThkNjQ1NDEzOlhiOVBqbndJUkhhb0hGNVZCbUZlUTU4TUs3VHdOZnZy',
               c_custom_content           TYPE zac_customvalue     VALUE 'application/x-www-form-urlencoded',
               c_custom_accept            TYPE zac_customvalue     VALUE '*/*',
               c_custom_encoding          TYPE zac_customvalue     VALUE 'gzip, deflate, br',
               c_custom_connection        TYPE zac_customvalue     VALUE 'keep-alive',
               c_custom_body              TYPE zac_customvalue     VALUE 'grant_type=openapi_2lo',
               c_custom_acceptkey         TYPE zac_configurationid VALUE 'ACCEPT',
               c_custom_connkey           TYPE zac_configurationid VALUE 'CONNECTION',
               c_custom_contentkey        TYPE zac_configurationid VALUE 'CONTENT',
               c_custom_encodekey         TYPE zac_configurationid VALUE 'ENCODING',
               c_custom_bodykey           TYPE zac_configurationid VALUE 'BODY',
               c_custom_single            TYPE zac_fname           VALUE 'SINGLE',
               c_custom_urlkey            TYPE zac_configurationid VALUE 'URL',
               c_custom_url               TYPE zac_customvalue     VALUE 'https://api-eu.ariba.com/v2/oauth/token'.
ENDINTERFACE.
