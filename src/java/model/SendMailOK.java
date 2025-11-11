package model;

import java.util.Date;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class SendMailOK {

    public static void send(String smtpServer, String to, String from, String psw,
            String subject, String body) throws Exception {
// java.security.Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        Properties props = System.getProperties();
// –
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        final String login = from;//”nth001@gmail.com”;//usermail
        final String pwd = psw;//”password cua ban o day”;
        Authenticator pa = null; //default: no authentication
        if (login != null && pwd != null) { //authentication required?
            props.put("mail.smtp.auth", "true");
            pa = new Authenticator() {
                public PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(login, pwd);
                }
            };
        }//else: no authentication
        Session session = Session.getInstance(props, pa);
// — Create a new message –
        Message msg = new MimeMessage(session);
// — Set the FROM and TO fields –
        msg.setFrom(new InternetAddress(from));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(
                to, false));

// — Set the subject and body text –
        msg.setSubject(subject);
        msg.setText(body);
// — Set some other header information –
        msg.setHeader("X - Mailer", "LOTONtechEmail");
        msg.setSentDate(new Date());
        msg.setContent(body, "text/html;charset=UTF-8");
        msg.saveChanges();
// — Send the message –
        Transport.send(msg);
        System.out.println(
                "Message sent OK.");

    }

    /**
     * Main method to send a message given on the command line.
     */
    public static void main(String[] args) {
        {
            try {
                String smtpServer = "smtp.gmail.com";
                String to = "thinhnguyen2904.work@gmail.com";
                String from = "thinhndhe170101@fpt.edu.vn";
                String subject = "Kiểm tra thử phương thức gửi mail bằng smtp";
                String body = "Kiểm tra gửi mail đã thành công hay chưa";
                String password = "vbzn nros scoe bykb";
                send(smtpServer, to, from, password, subject, body);

            } catch (Exception ex) {
                System.out.println("Usage: " + ex.getMessage());
                ex.printStackTrace();
            }

        }

        /**
         * “send” method to send the message.
         */
    }

}
