package sg.com.zElectronics.model.valueBean;

public class Role {
	private int id;
	private String name;
	private boolean viewAdmin;
	private boolean addProduct;
	private boolean editProduct;
	private boolean delProduct;
	private boolean editUser;
	private boolean delUser;
	private boolean setOrderStatus;
	private boolean setCategory;
	private boolean addUser;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public boolean isViewAdmin() {
		return viewAdmin;
	}

	public void setViewAdmin(boolean viewAdmin) {
		this.viewAdmin = viewAdmin;
	}

	public boolean isAddProduct() {
		return addProduct;
	}

	public void setAddProduct(boolean addProduct) {
		this.addProduct = addProduct;
	}

	public boolean isEditProduct() {
		return editProduct;
	}

	public void setEditProduct(boolean editProduct) {
		this.editProduct = editProduct;
	}

	public boolean isDelProduct() {
		return delProduct;
	}

	public void setDelProduct(boolean delProduct) {
		this.delProduct = delProduct;
	}

	public boolean isEditUser() {
		return editUser;
	}

	public void setEditUser(boolean editUser) {
		this.editUser = editUser;
	}

	public boolean isDelUser() {
		return delUser;
	}

	public void setDelUser(boolean delUser) {
		this.delUser = delUser;
	}

	public boolean isSetOrderStatus() {
		return setOrderStatus;
	}

	public void setSetOrderStatus(boolean setOrderStatus) {
		this.setOrderStatus = setOrderStatus;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isSetCategory() {
		return setCategory;
	}

	public void setSetCategory(boolean setCategory) {
		this.setCategory = setCategory;
	}

	public boolean isAddUser() {
		return addUser;
	}

	public void setAddUser(boolean addUser) {
		this.addUser = addUser;
	}

}
