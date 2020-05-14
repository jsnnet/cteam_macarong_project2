
// !!!! <이 코드에 필요한 사항을 추가하지 않고 아래의 LoginTestController를 새로 만들어 필요한 코드를 추가 (안전을 위해)

//package kr.co.macaronshop.mvc.controller;
//
//import java.nio.channels.SeekableByteChannel;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpSession;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.servlet.ModelAndView;
//import kr.co.macaronshop.mvc.dao.TestDao;
//import kr.co.macaronshop.mvc.dto.StoreVO;
//
//@Controller
//public class LoginController {
//	@Autowired
//	private TestDao testDao;
//
//	@GetMapping(value = "loginForm_user")
//	public String loginForm_user() {
//		return "loginForm_user";
//	}
//	
//	@GetMapping(value = "loginForm_admin")
//	public String sfdsdf() {
//		return "loginForm_admin";
//	}
//
//	@RequestMapping(value = "loginProcess_user")
//	public ModelAndView loginForm_user(HttpSession sesstion, String id) {
//		ModelAndView mav = new ModelAndView();
//		int a = testDao.idChk(id);
//		if (a == 1) {
//			sesstion.setAttribute("uid", id);
//			mav.setViewName("index");
//			return mav;
//		} else {
//			mav.setViewName("error");
//			return mav;
//		}
//
//	}
//
//	@RequestMapping(value = "loginProcess_admin")
//	public ModelAndView loginProcess(HttpSession sesstion, String id) {
//		ModelAndView mav = new ModelAndView();
//		StoreVO svo = testDao.idChk_adminid(id);	
//		if (svo == null) {
//			System.out.println("error");
//			mav.setViewName("error");
//			return mav;
//			
//		} else {
//			System.out.println(svo.getStid()+" "+svo.getStnum());
//			sesstion.setAttribute("adminid", svo.getStid());
//			sesstion.setAttribute("stnum", svo.getStnum());// 세션에 넣어놨다
//			mav.setViewName("index");
//			return mav;
//		}
//
//	}
//	//logout_admin
//
//	@GetMapping("/logout")
//	public ModelAndView loginfoutProcess(HttpSession session, HttpServletRequest request) {
//		//String uname =(String) session.getAttribute("uname"); 세션에 저장된 것 이용할 때
//		//String uid =(String) session.getAttribute("uid");
//		session.removeAttribute("uname");
//		session.removeAttribute("uid"); // 로그인한 사용자의 세션 삭제
//		ModelAndView mav = new ModelAndView();
//		mav.setViewName("redirect:/");
//		return mav;
//	}
//	
//	@GetMapping("/logout_admin")
//	public ModelAndView loginfoutProcess_admin(HttpSession session, HttpServletRequest request) {
//		session.removeAttribute("adminname");
//		session.removeAttribute("adminid"); // 로그인한 사용자의 세션 삭제
//		ModelAndView mav = new ModelAndView();
//		mav.setViewName("redirect:/");
//		return mav;
//	}
//
//}
