
package kr.co.macaronshop.mvc.controller;

import java.lang.management.ManagementFactory;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.macaronshop.mvc.dao.BasketDao;
import kr.co.macaronshop.mvc.dto.BasketCheckDTO;
import kr.co.macaronshop.mvc.dto.BasketListDTO;
import kr.co.macaronshop.mvc.dto.BasketVO;
import kr.co.macaronshop.mvc.service.BasketServiceInter;

@Controller
public class BasketController {

	@Autowired
	private BasketDao basketDao;
	
	@Autowired
	public BasketServiceInter service;

	// insert
	@RequestMapping(value = "/intoBasket", method = RequestMethod.POST)
	public ModelAndView intoBasket(@ModelAttribute("vo") BasketVO vo,  BasketListDTO dto, HttpSession sesstion) {
		int memnum = (int) sesstion.getAttribute("unum");
		System.out.println("(insert)세션의 회원번호 : " + memnum);
		vo.setMemnum(memnum);
		basketDao.intoCart(vo);
		ModelAndView mav = new ModelAndView("basketcomplete");
		return mav;
	}

	// 장바구니 보여주기 수정 (select)
	@RequestMapping(value = "/listBasket2")
	public ModelAndView listBasket2(HttpSession sesstion) { // String id,
		int memnum = (int) sesstion.getAttribute("unum"); // 세션에 있던 회원번호(unum)을 받아 mbnum에 저장
		System.out.println("(컨트롤러)세션에 있던 회원번호 2 : " + memnum);
		ModelAndView mav = new ModelAndView("basketlist2");
		List<BasketListDTO> dtolist = basketDao.listBasket2(memnum);
		System.out.println("장바구니 목록 : " + dtolist);
		BasketListDTO tp = basketDao.totalPrice(memnum);// 총액 출력
		// BasketListDTO up = basketDao.updatePrice(mbnum);
		mav.addObject("tp", tp);
		// mav.addObject("up", up);
		mav.addObject("dtolist", dtolist);
		return mav;
	}

	// 개별 삭제
	@GetMapping(value = "/deleteselected")
	public String delCart(int basketnum) {
		basketDao.delCart(basketnum);
		return "redirect:/listBasket2";
	}
	
	// 선택 삭제
	@RequestMapping(value = "/deleteSelected", method = RequestMethod.POST)
	public String delSelected(@RequestParam("selected") Integer[] selected, ModelMap modelMap)throws Exception{
		// 삭제할 상품 번호마다 반복해서 목록 삭제
		for (int basketnum : selected) {
			System.out.println("장바구니에서 삭제 = "+basketnum);
			int delete_count = service.delSelected(basketnum);
		}
		// 장바구니 페이지로 이동
		return "redirect:/listBasket2";
	}
	
	

}
