package kr.co.macaronshop.mvc.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.macaronshop.mvc.dto.SearchVO;
import kr.co.macaronshop.mvc.dto.StoreVO;



@Repository
public class StoreViewDao {
	@Autowired
	private SqlSessionTemplate ss;
	
	public List<StoreVO> getList(SearchVO svo){
		return ss.selectList("showstore.list", svo);
	}
	public int getTotalCount(SearchVO svo) {
		return ss.selectOne("showstore.totalCount", svo);
	}
	public List<StoreVO> getListSearch(SearchVO svo){
		return ss.selectList("showstore.listsearch", svo);
	}

	public StoreVO storeDetail(int stnum) {
		return ss.selectOne("showstore.storeDetail", stnum);
	}
}
