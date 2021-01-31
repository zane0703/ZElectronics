package sg.com.zElectronics.model.valueBean;

public class Cart {
	private int id;
	private int quantity;
	private int fkBuyerId;
	private int fkProductId;
	private String productTitle;
	private String productImage;
	private int productQty;
	private double productRetailPrice;
	
	public Cart(int id, int quantity, int fkBuyerId, int fkProductId, String productTitle,
			String productImage, int productQty, double productRetailPrice) {
		super();
		this.id = id;
		this.quantity = quantity;
		this.fkBuyerId = fkBuyerId;
		this.fkProductId = fkProductId;
		this.productTitle = productTitle;
		this.productImage = productImage;
		this.productQty = productQty;
		this.productRetailPrice = productRetailPrice;
	}
	public Cart() {
		super();
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public int getFkBuyerId() {
		return fkBuyerId;
	}
	public void setFkBuyerId(int fkBuyerId) {
		this.fkBuyerId = fkBuyerId;
	}
	public int getFkProductId() {
		return fkProductId;
	}
	public void setFkProductId(int fkProductId) {
		this.fkProductId = fkProductId;
	}
	public String getProductTitle() {
		return productTitle;
	}
	public void setProductTitle(String productTitle) {
		this.productTitle = productTitle;
	}
	public String getProductImage() {
		return productImage;
	}
	public void setProductImage(String productImage) {
		this.productImage = productImage;
	}
	public int getProductQty() {
		return productQty;
	}
	public void setProductQty(int productQty) {
		this.productQty = productQty;
	}
	public double getProductRetailPrice() {
		return productRetailPrice;
	}
	public void setProductRetailPrice(double productRetailPrice) {
		this.productRetailPrice = productRetailPrice;
	}
	
}
