package kr.co.macaronshop.mvc.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.macaronshop.mvc.dto.MenuVO;
import kr.co.macaronshop.mvc.dto.StoreVO;

@Repository
public class MenuDao {

	@Autowired
	private SqlSessionTemplate ss;
	
	public MenuVO menuInsert(MenuVO vo) {
		return ss.selectOne("menu.ins", vo);
	}
	
	public List<StoreVO> getlist(int stnum){
		return ss.selectList("mypage.menulist",stnum);
	}
	public void getdelet(int foodnum) {
		ss.delete("menu.menudelet",foodnum);
	}
	public MenuVO getMenu(int foodnum) {
		return ss.selectOne("menu.menu1",foodnum);
	}
	
	public void getmenuupdate(MenuVO mvo) {
		ss.update("menu.update",mvo);
	}
}
