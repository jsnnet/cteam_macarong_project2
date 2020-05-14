package kr.co.macaronshop.mvc.dto;

public class BasketVO {
	
	private int basketnum, memnum, stnum, foodnum, basketpay, foodtotal;
	private String basket_time;
	
	public String getBasket_time() {
		return basket_time;
	}

	public void setBasket_time(String basket_time) {
		this.basket_time = basket_time;
	}

	public int getBasketnum() {
		return basketnum;
	}

	public void setBasketnum(int basketnum) {
		this.basketnum = basketnum;
	}

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

	public int getBasketpay() {
		return basketpay;
	}

	public void setBasketpay(int basketpay) {
		this.basketpay = basketpay;
	}

	public int getFoodtotal() {
		return foodtotal;
	}

	public void setFoodtotal(int foodtotal) {
		this.foodtotal = foodtotal;
	}
	
	
	
	/*
	 * --장바구니 번호
basketnum NUMBER CONSTRAINT shop_basket_basketnum_pk PRIMARY KEY,
--회원번호
memnum NUMBER,
--가게번호
stnum NUMBER,
--음식번호
foodnum NUMBER(30),
--주문 가격
basketpay NUMBER(30),
--주문 수량
foodtotal NUMBER(30),
	 */

}
