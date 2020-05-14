package kr.co.macaronshop.mvc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BasketServiceImple implements BasketServiceInter{

	@Autowired
	public BasketServiceInter basketServiceInter;
	
	@Override
	public Integer delSelected(int basketnum) {
		return basketServiceInter.delSelected(basketnum);
	}

	

}
