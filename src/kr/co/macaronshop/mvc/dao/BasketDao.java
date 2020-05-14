package kr.co.macaronshop.mvc.dao;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.macaronshop.mvc.dto.BasketCheckDTO;
import kr.co.macaronshop.mvc.dto.BasketListDTO;
import kr.co.macaronshop.mvc.dto.BasketVO;
import kr.co.macaronshop.mvc.dto.StoreVO;

@Repository
public class BasketDao {
	
	@Autowired
	private SqlSessionTemplate ss;
	
	// 장바구니 보여주기 수정버젼
	public List<BasketListDTO> listBasket2(int memnum){
		System.out.println("(dao)세션으로부터의 회원번호2 : "+memnum);
		return ss.selectList("cart.listBasket2", memnum);
	} 
	
	public void intoCart(BasketVO vo) {
		ss.insert("cart.addBasket", vo);
	}
	
	public void delCart(int basketnum) {
		ss.delete("cart.delCart", basketnum);
	}

	public BasketListDTO totalPrice(int memnum) {
		System.out.println("(dao_tp)세션으로부터의 회원 번호 : "+memnum);
		return ss.selectOne("cart.totalPrice", memnum);
	}
	
	public void  updatePrice(BasketListDTO dto) {
		System.out.println("(dao_upd)Foodpay: "+dto.getFoodpay());
		System.out.println("(dao_upd)Foodtotal : "+dto.getFoodtotal());
		System.out.println("(dao_upd)Foodnum : "+dto.getFoodnum());
		ss.update("cart.updatePrice", dto);
	}
	
	// 수량 5개 넘는지 확인용
	public BasketCheckDTO chkFtotal(BasketCheckDTO chk) {
		return ss.selectOne("cart.chkFtotal", chk);
	}
	
	public void delSelected(int basketnum) {
		ss.delete("cart.delSelected",basketnum);
	}
}
