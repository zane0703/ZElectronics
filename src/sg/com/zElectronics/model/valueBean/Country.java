package sg.com.zElectronics.model.valueBean;

public class Country {
	private String name;
	private String alpha3Code;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAlpha3Code() {
		return alpha3Code;
	}
	public void setAlpha3Code(String alpha3Code) {
		this.alpha3Code = alpha3Code;
	}
	@Override
	public boolean equals(Object o) {
		if(this == o) {
			return true;
		}
		if(Country.class == o.getClass()) {
			Country that = (Country)o;
			if(this.name == that.name&&this.alpha3Code == that.alpha3Code) {
			return true;
			}
		}
		return false;
		
	}
	
}
