package kr.co.macaronshop.mvc.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
@Controller
public class PayController {
	@RequestMapping("pay")
	public ModelAndView pay() {
		System.out.println(11111);
		ModelAndView mav = new ModelAndView("pay");
		return mav;
	}
}
