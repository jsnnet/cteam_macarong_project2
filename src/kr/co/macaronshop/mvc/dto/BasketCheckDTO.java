package kr.co.macaronshop.mvc.dto;

public class BasketCheckDTO {
	
	private int rnum, memnum, stnum, foodnum, foodtotal;

	public int getMemnum() {
		return memnum;
	}

	public void setMemnum(int memnum) {
		this.memnum = memnum;
	}

	public int getStnum() {
		return stnum;
	}

	public void setStnum(int stnum) {
		this.stnum = stnum;
	}

	public int getFoodnum() {
		return foodnum;
	}

	public void setFoodnum(int foodnum) {
		this.foodnum = foodnum;
	}

	public int getFoodtotal() {
		return foodtotal;
	}

	public void setFoodtotal(int foodtotal) {
		this.foodtotal = foodtotal;
	}
	
	

}
