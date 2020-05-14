package kr.co.macaronshop.mvc.dto;

import org.springframework.web.multipart.MultipartFile;

public class MenuVO {
/*
 * STNUM       NUMBER       
FOODNUM     NUMBER(5)    
FOODNAME    VARCHAR2(30) 
FOODPAY     NUMBER(10)   
FOODIMG     VARCHAR2(40) 
 */
	
	
	private int stnum, foodpay;
	private String foodnum, foodname, foodimg;
	private MultipartFile upimg;
	
	public MultipartFile getUpimg() {
		return upimg;
	}
	public void setUpimg(MultipartFile upimg) {
		this.upimg = upimg;
	}
	public int getStnum() {
		return stnum;
	}
	public void setStnum(int stnum) {
		this.stnum = stnum;
	}
	public int getFoodpay() {
		return foodpay;
	}
	public void setFoodpay(int foodpay) {
		this.foodpay = foodpay;
	}
	public String getFoodnum() {
		return foodnum;
	}
	public void setFoodnum(String foodnum) {
		this.foodnum = foodnum;
	}
	public String getFoodname() {
		return foodname;
	}
	public void setFoodname(String foodname) {
		this.foodname = foodname;
	}
	public String getFoodimg() {
		return foodimg;
	}
	public void setFoodimg(String foodimg) {
		this.foodimg = foodimg;
	}
	
}
