package kr.co.macaronshop.mvc.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import kr.co.macaronshop.mvc.dao.MenuDao;
import kr.co.macaronshop.mvc.dto.MenuVO;
import kr.co.macaronshop.mvc.dto.StoreVO;

@Controller
public class UpFormController {

	@Autowired
	private MenuDao menuDao;
	

	@RequestMapping(value = "upform")
	public ModelAndView upform() {
		ModelAndView mav = new ModelAndView("upform");
		return mav;
	}

	@RequestMapping(value = "/upsave", method = RequestMethod.POST)
	public ModelAndView save(@ModelAttribute("vo") MenuVO vo, HttpSession session) {

		String path = session.getServletContext().getRealPath("/resources/imgfile/");
		StringBuffer paths = new StringBuffer();
		paths.append(path);
		paths.append(vo.getUpimg().getOriginalFilename());
		File f = new File(paths.toString());

		try {
			vo.getUpimg().transferTo(f);
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
		// Db로 들어갈 파일명으로 변경
		vo.setFoodimg(vo.getUpimg().getOriginalFilename());
		System.out.println("path :" + path);
		menuDao.menuInsert(vo);
		ModelAndView mav = new ModelAndView("uplist");
		int stnum = (int) session.getAttribute("stnum");
		List<StoreVO> list = menuDao.getlist(stnum);
		mav.addObject("list", list);
		return mav;
	}
	
	
	@RequestMapping("mypage")
	public ModelAndView mypage(HttpSession session) {
		int stnum = (int) session.getAttribute("stnum");		
		ModelAndView mav = new ModelAndView("uplist");
		List<StoreVO> list = menuDao.getlist(stnum);
		// System.out.println(list.get(1).getMenu().get(0).getFoodname());;
		mav.addObject("list", list);
		return mav;
	}
	
	//delete
	@RequestMapping("delete")
	public ModelAndView delete(int foodnum,HttpSession session) {
		int stnum = (int) session.getAttribute("stnum");	
		System.out.println(foodnum+"  "+stnum);
		menuDao.getdelet(foodnum);
		ModelAndView mav = new ModelAndView("uplist");
		List<StoreVO> list = menuDao.getlist(stnum);
		mav.addObject("list", list);
		return mav;
		
	}
	//alter
	@RequestMapping("alter")
	public ModelAndView alter(int foodnum,HttpSession session) {
		
		//menuDao.getdelet(foodnum);
		ModelAndView mav = new ModelAndView("uplalter");
		MenuVO menu = menuDao.getMenu(foodnum);
		System.out.println(menu.getFoodpay());
		mav.addObject("menu", menu);
		return mav;
	}
	
	//update
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public ModelAndView update(@ModelAttribute("vo") MenuVO vo, HttpSession session) {

		String path = session.getServletContext().getRealPath("/resources/imgfile/");
		StringBuffer paths = new StringBuffer();
		paths.append(path);
		paths.append(vo.getUpimg().getOriginalFilename());
		File f = new File(paths.toString());

		try {
			vo.getUpimg().transferTo(f);
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
		// Db로 들어갈 파일명으로 변경
		vo.setFoodimg(vo.getUpimg().getOriginalFilename());
		
		menuDao.getmenuupdate(vo);
		
		ModelAndView mav = new ModelAndView("uplist");
		int stnum = (int) session.getAttribute("stnum");
		List<StoreVO> list = menuDao.getlist(stnum);
		mav.addObject("list", list);
		return mav;
	}
}
