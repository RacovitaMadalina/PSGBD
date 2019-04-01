-- Bibliografie: http://www.orafaq.com/node/3077 (in mare parte am urmat pasii de aici)
-- pentru server SMTP: am instalat sstunnel-5.45-win32-installer.exe de pe https://www.stunnel.org/downloads.html
-- https://www.base64encode.org/ (pentru a coda parola)

CREATE OR REPLACE PACKAGE sending_mail_gmail_plsql
IS
    host_smtp VARCHAR2 (256) := 'localhost';
    port_smtp PLS_INTEGER := 1925;
    domeniu_smtp VARCHAR2 (256) := 'gmail.com';
    mailer_id CONSTANT VARCHAR2 (256) := 'Mailer by Oracle UTL_SMT';
    PROCEDURE trimite_mail (p_emitator IN VARCHAR2, p_destinatar IN VARCHAR2, p_subiect IN VARCHAR2, p_mesaj IN VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY sending_mail_gmail_plsql IS
    
    PROCEDURE scrie_antet_email (p_conexiune IN OUT NOCOPY UTL_SMTP.CONNECTION, p_nume IN VARCHAR2, p_valoare IN VARCHAR2) IS
    BEGIN
        UTL_SMTP.WRITE_DATA ( p_conexiune , p_nume || ': ' || p_valoare || UTL_TCP.CRLF);
    END;
    PROCEDURE trimite_mail (p_emitator IN VARCHAR2, p_destinatar IN VARCHAR2, p_subiect IN VARCHAR2, p_mesaj IN VARCHAR2)
    IS
      smtp_connection UTL_SMTP.CONNECTION;
      NLS_CHARSET VARCHAR2(255);
    BEGIN
      SELECT VALUE INTO NLS_CHARSET FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER = 'NLS_CHARACTERSET';
    
      -- se stabileste conexiunea la serverul SMTP, in cazul curent la stunnel
      smtp_connection := UTL_SMTP.OPEN_CONNECTION (host_smtp, port_smtp);
      
      -- ca la telnet, se incepe cu comanda helo/ehlo + domeniul (gmail.com)
      UTL_SMTP.EHLO(smtp_connection, domeniu_smtp);
      
      --se realizeaza autentificarea (numele si parola sunt encriptate encoded64
      UTL_SMTP.COMMAND(smtp_connection, 'auth login');
      UTL_SMTP.COMMAND(smtp_connection, UTL_ENCODE.TEXT_ENCODE('madalina.racovita1997@gmail.com', NLS_CHARSET, 1));
      UTL_SMTP.COMMAND(smtp_connection, 'TWFkYWxpbmFQU0dCRA==');
    
      --se stabilesc emitatorul si destinatatul
      UTL_SMTP.COMMAND(smtp_connection, 'MAIL FROM: <'||p_emitator||'>');
      UTL_SMTP.COMMAND(smtp_connection, 'RCPT TO: <'||p_destinatar||'>');
    
      -- se stabilesc detaliile din headerul mail-ului
      UTL_SMTP.OPEN_DATA (smtp_connection);
      scrie_antet_email(smtp_connection, 'From', p_emitator);
      scrie_antet_email(smtp_connection, 'To', p_destinatar);
      scrie_antet_email(smtp_connection, 'Subject', p_subiect);
      scrie_antet_email(smtp_connection, 'Content-Type', 'text/plain’');
      scrie_antet_email(smtp_connection, 'X-Mailer', mailer_id);
      UTL_SMTP.WRITE_DATA (smtp_connection, UTL_TCP.CRLF);
      
      -- se scrie continutului mail-ului
      UTL_SMTP.WRITE_DATA (smtp_connection, p_mesaj);
      
      --inchidem conexiunea la serverul SMTP
      UTL_SMTP.CLOSE_DATA (smtp_connection);
      UTL_SMTP.QUIT (smtp_connection);
      
      --tratarea cazurilor de exceptie
      EXCEPTION
          WHEN OTHERS THEN
          BEGIN
              UTL_SMTP.QUIT(smtp_connection);
              EXCEPTION
                  WHEN OTHERS THEN NULL;
          END;
          RAISE_APPLICATION_ERROR(-20000,'Mail-ul nu a mai fost trimis datorita erorii: ' || SQLERRM);
    END;
END;
/
set serveroutput on;
begin
email_gmail.send('madalina.racovita1997@gmail.com', 'cosmin.varlan@gmail.com', '[PL/SQL Racovita MadalinaAlina]', 
                  'Buna ziua! Acesta este primul meu email trimis prin SMTP.');
end;