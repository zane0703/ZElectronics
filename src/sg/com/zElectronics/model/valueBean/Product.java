package sg.com.zElectronics.model.valueBean;

import java.util.Date;

import javax.json.bind.annotation.JsonbTypeAdapter;

import sg.com.zElectronics.DateAdapter;

public class Product {
	private int id;
	private String title;
	private String briefDescription;
	private String detailDescription;
	private double costPrice;
	private double retailPrice;
	private int quantity;
	private int fKCategoryId;
	private String image;
	private String categoryName;
	private int orderAmount;
	@JsonbTypeAdapter(DateAdapter.class)
	private Date createdAt;
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getBriefDescription() {
		return briefDescription;
	}

	public void setBriefDescription(String briefDescription) {
		this.briefDescription = briefDescription;
	}

	public String getDetailDescription() {
		return detailDescription;
	}

	public void setDetailDescription(String detailDescription) {
		this.detailDescription = detailDescription;
	}

	public double getCostPrice() {
		return costPrice;
	}

	public void setCostPrice(double costPrice) {
		this.costPrice = costPrice;
	}

	public double getRetailPrice() {
		return retailPrice;
	}

	public void setRetailPrice(double retailPrice) {
		this.retailPrice = retailPrice;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public void setFKCategoryId(int fKCategoryId) {
		this.fKCategoryId = fKCategoryId;
	}

	public int getfKCategoryId() {
		return fKCategoryId;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public int getOrderAmount() {
		return orderAmount;
	}

	public void setOrderAmount(int orderAmount) {
		this.orderAmount = orderAmount;
	}

}
