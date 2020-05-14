package kr.co.macaronshop.mvc.dto;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class StoreVO {
	/*
	 * STNUM     NOT NULL NUMBER       
STSBNAME           VARCHAR2(20) 
STNAME             VARCHAR2(20) 
STID               VARCHAR2(20) 
STPWD              VARCHAR2(30) 
STADDRESS          VARCHAR2(50) 
STPHONE            VARCHAR2(50) 
STIMG              VARCHAR2(40) 
	 * */
	private List<MenuVO> menu;
	
	private int stnum;
	private String stsbname, stname, stid, stpwd, staddress, stphone, stimg;
	private MultipartFile multipartFile;
	private String path;
	
	public List<MenuVO> getMenu() {
		return menu;
	}
	public void setMenu(List<MenuVO> menu) {
		this.menu = menu;
	}
	public int getStnum() {
		return stnum;
	}
	public void setStnum(int stnum) {
		this.stnum = stnum;
	}
	public String getStsbname() {
		return stsbname;
	}
	public void setStsbname(String stsbname) {
		this.stsbname = stsbname;
	}
	public String getStname() {
		return stname;
	}
	public void setStname(String stname) {
		this.stname = stname;
	}
	public String getStid() {
		return stid;
	}
	public void setStid(String stid) {
		this.stid = stid;
	}
	public String getStpwd() {
		return stpwd;
	}
	public void setStpwd(String stpwd) {
		this.stpwd = stpwd;
	}
	public String getStaddress() {
		return staddress;
	}
	public void setStaddress(String staddress) {
		this.staddress = staddress;
	}
	public String getStphone() {
		return stphone;
	}
	public void setStphone(String stphone) {
		this.stphone = stphone;
	}
	public String getStimg() {
		return stimg;
	}
	public void setStimg(String stimg) {
		this.stimg = stimg;
	}
	public MultipartFile getMultipartFile() {
		return multipartFile;
	}
	public void setMultipartFile(MultipartFile multipartFile) {
		this.multipartFile = multipartFile;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	
	
}
