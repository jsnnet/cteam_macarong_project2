
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
		System.out.println("(insert)������ ȸ����ȣ : " + memnum);
		vo.setMemnum(memnum);
		basketDao.intoCart(vo);
		ModelAndView mav = new ModelAndView("basketcomplete");
		return mav;
	}

	// ��ٱ��� �����ֱ� ���� (select)
	@RequestMapping(value = "/listBasket2")
	public ModelAndView listBasket2(HttpSession sesstion) { // String id,
		int memnum = (int) sesstion.getAttribute("unum"); // ���ǿ� �ִ� ȸ����ȣ(unum)�� �޾� mbnum�� ����
		System.out.println("(��Ʈ�ѷ�)���ǿ� �ִ� ȸ����ȣ 2 : " + memnum);
		ModelAndView mav = new ModelAndView("basketlist2");
		List<BasketListDTO> dtolist = basketDao.listBasket2(memnum);
		System.out.println("��ٱ��� ��� : " + dtolist);
		BasketListDTO tp = basketDao.totalPrice(memnum);// �Ѿ� ���
		// BasketListDTO up = basketDao.updatePrice(mbnum);
		mav.addObject("tp", tp);
		// mav.addObject("up", up);
		mav.addObject("dtolist", dtolist);
		return mav;
	}

	// ���� ����
	@GetMapping(value = "/deleteselected")
	public String delCart(int basketnum) {
		basketDao.delCart(basketnum);
		return "redirect:/listBasket2";
	}
	
	// ���� ����
	@RequestMapping(value = "/deleteSelected", method = RequestMethod.POST)
	public String delSelected(@RequestParam("selected") Integer[] selected, ModelMap modelMap)throws Exception{
		// ������ ��ǰ ��ȣ���� �ݺ��ؼ� ��� ����
		for (int basketnum : selected) {
			System.out.println("��ٱ��Ͽ��� ���� = "+basketnum);
			int delete_count = service.delSelected(basketnum);
		}
		// ��ٱ��� �������� �̵�
		return "redirect:/listBasket2";
	}
	
	

}
