package kr.co.macaronshop.mvc.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.macaronshop.mvc.dao.BasketDao;
import kr.co.macaronshop.mvc.dto.BasketListDTO;

@RestController
@RequestMapping(value = "/cart")
public class TestCartController {
	
	@Autowired
	private BasketDao basketDao;

	@RequestMapping("/cartJson")
	public String test(BasketListDTO dto, HttpSession session) { // , int mbnum
		System.out.println("basketnum:"+dto.getBasketnum());
		Object mnumv = session.getAttribute("unum");
		System.out.println("mnum:"+session.getAttribute("unum"));
		dto.setMemnum(Integer.parseInt(String.valueOf(mnumv)));
		int total = dto.getFoodtotal() * dto.getFoodpay();
		dto.setBasketpay(total);
		basketDao.updatePrice(dto);
		StringBuffer sb = new StringBuffer();
		sb.append(dto.getFoodtotal()).append(":");
		sb.append(total).append(":");
		sb.append(dto.getTotalprice());
		return sb.toString();
	}
}
