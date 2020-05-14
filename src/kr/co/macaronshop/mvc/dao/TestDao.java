package kr.co.macaronshop.mvc.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.macaronshop.mvc.dto.StoreVO;

@Repository
public class TestDao {

	@Autowired
	private SqlSessionTemplate ss;
	
	public int idChk(String id) {
		return ss.selectOne("member.idChk", id);
	}
	
	public StoreVO idChk_adminid(String id) {
		return ss.selectOne("member.idChk_adminid", id);
	}
	
}
