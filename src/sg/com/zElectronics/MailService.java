package sg.com.zElectronics;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
public class MailService {
	private static Properties mailConfig;
	public static void setConfig(Properties config) {
		mailConfig =config;
	}
	public static void verifyEmail(String sendAddr,String token) throws AddressException, MessagingException {
		//make a new thread so that will not need to wait for the mail to be send before the server response  to the user
		new Thread(()->{
			try {
		String user = mailConfig.getProperty("user");
		Session session = Session.getInstance(mailConfig, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user, mailConfig.getProperty("password"));
				
			}
			});
				Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(user));
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(sendAddr));
			message.setSubject("Z Electronics | Forgot Password");
			message.setContent("<p>Use this token: <span style=\"color:blue\" >"+token+"</span> to Verify Your Email  </p>","text/html");
			Transport.send(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		}).start();
	}
	public static void forgetPW(String sendAddr,String token) throws AddressException, MessagingException {
		//make a new thread so that will not need to wait for the mail to be send before the server response  to the user
		new Thread(()->{
			try {
				String user = mailConfig.getProperty("user");
				Session session = Session.getInstance(mailConfig, new Authenticator() {
					@Override
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(user, mailConfig.getProperty("password"));
						
					}
					});
						Message message = new MimeMessage(session);
					message.setFrom(new InternetAddress(user));
					message.setRecipient(Message.RecipientType.TO, new InternetAddress(sendAddr));
					message.setSubject("Z Electronics | Verify Email");
					message.setContent("<p>Use this token: <span style=\"color:blue\" >"+token+"</span> to Reset Your Password </p>","text/html");
					Transport.send(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		}).start();
	}
}
