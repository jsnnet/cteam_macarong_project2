package kr.co.macaronshop.mvc.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.co.macaronshop.mvc.dao.AjaxDao;
import kr.co.macaronshop.mvc.dto.BasketListDTO;
import kr.co.macaronshop.mvc.dto.StoreVO;


@RestController
@RequestMapping(value = "/store")
public class AjaxJsonController {
	
	@Autowired
	private AjaxDao ajaxdao;
	
	@RequestMapping(value = "/menu")
	@ResponseBody
	public ResponseEntity<List<StoreVO>> respList2(int stnum) {
	      List<StoreVO> list = new ArrayList<>();
	      list.addAll(ajaxdao.store_menu(stnum));
	         return new ResponseEntity<>(list , HttpStatus.OK);
	   }
	
//	@RequestMapping(value = "/basket")
//	@ResponseBody
//	public ResponseEntity<List<BasketListDTO>> listBasket3(int mbnum){
//		List<BasketListDTO> dtolist2 = new ArrayList<>();
//		dtolist2.addAll(ajaxdao.listBasket3(mbnum));
//		return new ResponseEntity<>(dtolist2, HttpStatus.OK);
//	}
}
