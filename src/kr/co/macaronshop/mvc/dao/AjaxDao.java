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

	// ��ٱ��Ͽ� Ajax �Ẹ�� ���� by �μ�
	public List<BasketListDTO> listBasket3(int mbnum){
		return ss.selectList("cart.listBasket3", mbnum);
	}

}
