package sg.com.zElectronics.model.valueBean;

import java.util.Date;

import javax.json.bind.annotation.JsonbTypeAdapter;

import sg.com.zElectronics.DateAdapter;

public class Order {
	private int id;
	private int quantity;
	private int fkBuyerId;
	private String buyerName;
	private String billAddress;
	private int billPostal;
	private String shipAddress;
	private int shipPostal;
	private String buyerContact;
	private int fkProductId;
	private String productTitle;
	private String buyerEmail;
	private int productQty;
	private int status;
	private String billCountry;
	private String ShipCountry;

	@JsonbTypeAdapter(DateAdapter.class)
	private Date createdAt;

	public String getBillAddress() {
		return billAddress;
	}

	public void setBillAddress(String billAddress) {
		this.billAddress = billAddress;
	}

	public int getBillPostal() {
		return billPostal;
	}

	public void setBillPostal(int billPostal) {
		this.billPostal = billPostal;
	}

	public String getShipAddress() {
		return shipAddress;
	}

	public void setShipAddress(String shipAddress) {
		this.shipAddress = shipAddress;
	}

	public int getShipPostal() {
		return shipPostal;
	}

	public void setShipPostal(int shipPostal) {
		this.shipPostal = shipPostal;
	}

	public int getProductQty() {
		return productQty;
	}

	public void setProductQty(int productQty) {
		this.productQty = productQty;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setQuantity(int qty) {
		this.quantity = qty;
	}

	public void setFkProductId(int fkProductId) {
		this.fkProductId = fkProductId;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getId() {
		return id;
	}

	public int getQuantity() {
		return quantity;
	}

	public int getFkProductId() {
		return fkProductId;
	}

	public int getStatus() {
		return status;
	}

	public String getProductTitle() {
		return productTitle;
	}

	public void setProductTitle(String productTitle) {
		this.productTitle = productTitle;
	}

	public int getFkBuyerId() {
		return fkBuyerId;
	}

	public void setFkBuyerId(int fkBuyerId) {
		this.fkBuyerId = fkBuyerId;
	}

	public String getBuyerName() {
		return buyerName;
	}

	public void setBuyerName(String buyerName) {
		this.buyerName = buyerName;
	}

	public String getBuyerContact() {
		return buyerContact;
	}

	public void setBuyerContact(String buyerContact) {
		this.buyerContact = buyerContact;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public String getBuyerEmail() {
		return buyerEmail;
	}

	public void setBuyerEmail(String buyerEmail) {
		this.buyerEmail = buyerEmail;
	}

	public String getBillCountry() {
		return billCountry;
	}

	public void setBillCountry(String billCountry) {
		this.billCountry = billCountry;
	}

	public String getShipCountry() {
		return ShipCountry;
	}

	public void setShipCountry(String shipCountry) {
		ShipCountry = shipCountry;
	}
}
