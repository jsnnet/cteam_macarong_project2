package kr.co.macaronshop.mvc.dto;

import org.springframework.web.multipart.MultipartFile;

public class BasketListDTO { // 장바구니 리스트 보여주기 위해 취합
	private String foodname, foodimg;
	private int foodnum, foodtotal, foodpay, basketpay, basketnum, memnum, stnum, totalprice;
	private MultipartFile showimg;
	
	public int getFoodnum() {
		return foodnum;
	}
	public void setFoodnum(int foodnum) {
		this.foodnum = foodnum;
	}
	public int getTotalprice() {
		return totalprice;
	}
	public void setTotalprice(int totalprice) {
		this.totalprice = totalprice;
	}
	public int getStnum() {
		return stnum;
	}
	public void setStnum(int stnum) {
		this.stnum = stnum;
	}
	public int getBasketnum() {
		return basketnum;
	}
	public void setBasketnum(int basketnum) {
		this.basketnum = basketnum;
	}
	public String getFoodimg() {
		return foodimg;
	}
	public void setFoodimg(String foodimg) {
		this.foodimg = foodimg;
	}
	public int getFoodpay() {
		return foodpay;
	}
	public void setFoodpay(int foodpay) {
		this.foodpay = foodpay;
	}
	public int getMemnum() {
		return memnum;
	}
	public void setMemnum(int memnum) {
		this.memnum = memnum;
	}
	public MultipartFile getShowimg() {
		return showimg;
	}
	public void setShowimg(MultipartFile showimg) {
		this.showimg = showimg;
	}
	public String getFoodname() {
		return foodname;
	}
	public void setFoodname(String foodname) {
		this.foodname = foodname;
	}
	public int getFoodtotal() {
		return foodtotal;
	}
	public void setFoodtotal(int foodtotal) {
		this.foodtotal = foodtotal;
	}
	public int getBasketpay() {
		return basketpay;
	}
	public void setBasketpay(int basketpay) {
		this.basketpay = basketpay;
	}
	
	

}
