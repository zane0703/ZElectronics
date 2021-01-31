package sg.com.zElectronics.model.valueBean;

public class Logined {
	private int userId;
	private String username;
	private boolean viewAdmin;
	private int roleId;
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public boolean getViewAdmin() {
		return viewAdmin;
	}
	public void setViewAdmin(Boolean viewAdmin) {
		this.viewAdmin = viewAdmin;
	}
	public int getRoleId() {
		return roleId;
	}
	public void setRoleId(int roleId) {
		this.roleId = roleId;
	} 
}
