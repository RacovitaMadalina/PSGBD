SET SERVEROUTPUT ON;
CLEAR SCREEN;
/
DECLARE
    CONN            UTL_TCP.CONNECTION;
    RETVAL          BINARY_INTEGER;
    L_RESPONSE      VARCHAR2(1000) := '';
    L_TEXT          VARCHAR2(1000);    
BEGIN
    
    --Deschidem conexiunea...
    CONN := UTL_TCP.OPEN_CONNECTION(
        REMOTE_HOST   => '127.0.0.1',
        REMOTE_PORT   => 8010,
        TX_TIMEOUT    => 10
    );
    
    L_TEXT := 'Hello there...';
    --Scriem in socket...
    RETVAL := UTL_TCP.WRITE_LINE(CONN,L_TEXT);
    UTL_TCP.FLUSH(CONN);
    
    --Verificam daca am primit ceva si citim raspunsul din socket...
    BEGIN
        WHILE UTL_TCP.AVAILABLE(CONN, 10) > 0 LOOP
            L_RESPONSE := L_RESPONSE ||  UTL_TCP.GET_LINE(CONN,TRUE);
        END LOOP;
    EXCEPTION
        WHEN UTL_TCP.END_OF_INPUT THEN
            NULL;
    END;

    DBMS_OUTPUT.PUT_LINE('Response from Socket Server : ' || L_RESPONSE);
    
    --Inchidem conexiunea pentru a nu irosi resurse in mod inutil...
    UTL_TCP.CLOSE_CONNECTION(CONN);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20101, SQLERRM);
        UTL_TCP.CLOSE_CONNECTION(CONN);
END;
/
