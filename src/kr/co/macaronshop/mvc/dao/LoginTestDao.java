package kr.co.macaronshop.mvc.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.macaronshop.mvc.dto.MemberVO;
@Repository
public class LoginTestDao {
	@Autowired
	private SqlSessionTemplate ss;
	
	public MemberVO getId(String memid) {
		return ss.selectOne("cart.getMem", memid);
	}

}
