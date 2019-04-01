-- Bibliografie: https://stackoverflow.com/questions/24808240/how-to-run-http-web-service-request-from-pl-sql-package
-- https://gist.github.com/ser1zw/3757715

DROP TABLE MY_XML_TABLE;
CREATE TABLE MY_XML_TABLE (id_data NUMBER, extracted_data CLOB);
/
 
DECLARE
    request_http UTL_HTTP.REQ;
    response UTL_HTTP.RESP;
    counter NUMBER;
    myBuffer VARCHAR2(2500);
    extracted_infos CLOB;
 
   PROCEDURE my_first_http_request(url VARCHAR2) as
        BEGIN
        UTL_HTTP.SET_RESPONSE_ERROR_CHECK(FALSE);
        request_http := UTL_HTTP.BEGIN_REQUEST(url, 'GET' ,'HTTP/1.1');
        UTL_HTTP.SET_HEADER(request_http, 'User-Agent', 'Mozilla/4.0');
        response := UTL_HTTP.GET_RESPONSE(request_http);
        DBMS_OUTPUT.PUT_LINE('The status code for the current response is:' || response.status_code);
       
        IF response.status_code = 200 THEN
          BEGIN
             extracted_infos := EMPTY_CLOB;
             LOOP
                 UTL_HTTP.READ_TEXT(response, myBuffer, LENGTH(myBuffer));
                 extracted_infos := extracted_infos || myBuffer;
                 DBMS_OUTPUT.PUT_LINE(extracted_infos);
             END LOOP;
             UTL_HTTP.END_RESPONSE(response);
             EXCEPTION
                WHEN UTL_HTTP.END_OF_BODY THEN
                    UTL_HTTP.END_RESPONSE(response);
                END;
        ELSE
          DBMS_OUTPUT.PUT_LINE('FAIL');
          UTL_HTTP.END_RESPONSE(response);
        END IF;
    END my_first_http_request;
BEGIN
    my_first_http_request('help.websiteos.com/websiteos/example_of_a_simple_html_page.htm');
END;