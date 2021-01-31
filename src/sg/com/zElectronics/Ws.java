package sg.com.zElectronics;

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;
import javax.websocket.server.ServerEndpoint;
import javax.validation.ValidationProviderResolver;
import javax.websocket.CloseReason;
import javax.websocket.EndpointConfig;
import javax.websocket.Session;

@javax.websocket.server.ServerEndpoint("/")
public class Ws extends javax.websocket.Endpoint {
	private final String time = "hello";
	@Override
	public void onOpen(Session session, EndpointConfig config) {
		Timer timer = new Timer();
				timer.scheduleAtFixedRate(new TimerTask() {
			@Override
			public void run() {
				try {
					session.getBasicRemote().sendText(time);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		}, 0L, 1000L);
		session.getUserProperties().put(time, timer);
		
	}
	 public void onClose(Session session, CloseReason closeReason) {
		 System.out.println("close");
		 ((Timer) session.getUserProperties().get(time)).cancel();;
	    }

	    public void onError(Session session, Throwable throwable) {
	        throwable.printStackTrace();
	    }
	
}
