package kr.co.macaronshop.mvc.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.macaronshop.mvc.dto.BasketListDTO;
import kr.co.macaronshop.mvc.dto.StoreVO;

@Repository
public class AjaxDao {
	@Autowired
	private SqlSessionTemplate ss;

	public List<StoreVO> store_menu(int stnum) {
		return ss.selectList("storeMenu.menuList", stnum); // resultMap
	}

	// 장바구니에 Ajax 써보기 위해 by 두선
	public List<BasketListDTO> listBasket3(int mbnum){
		return ss.selectList("cart.listBasket3", mbnum);
	}

}
