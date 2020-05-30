package com.aeho.demo.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.aeho.demo.domain.CategoryDTO;
import com.aeho.demo.security.MemberPrincipal;
import com.aeho.demo.service.MainServcie;
import com.aeho.demo.vo.BoardVo;
import com.aeho.demo.vo.CategoryVo;
import com.google.gson.Gson;

@Controller
public class MainController {
	
	@Autowired
	private MainServcie mainService;
	
	@GetMapping("/aeho")
	public String main(HttpServletRequest request) {
		return "redirect:/main/main";
	}
	
	@GetMapping("/main/main")
	public void getMain(HttpServletRequest request) {
		
	}
	
	//인기글
	@ResponseBody
	@GetMapping("/todayBest")
	public String todayBest(HttpServletRequest request) {
		List<BoardVo> list = mainService.todayBest();
		Gson gson = new Gson();
		String todayList = gson.toJson(list);
		return todayList;
	}
	
	@ResponseBody
	@GetMapping("/weekBest")
	public String weekBest(HttpServletRequest request) {
		List<BoardVo> list = mainService.weekBest();
		Gson gson = new Gson();
		String todayList = gson.toJson(list);
		return todayList;
	}
	
	@ResponseBody
	@GetMapping("/monthBest")
	public String monthBest(HttpServletRequest request) {
		List<BoardVo> list = mainService.monthBest();
		Gson gson = new Gson();
		String todayList = gson.toJson(list);
		return todayList;
	}
	
	@ResponseBody
	@GetMapping("/menuCategory")
	public String menuCategory(HttpServletRequest request,CategoryDTO categoryDTO) {
		List<CategoryVo> list = mainService.menuCategory(categoryDTO);
		Gson gson = new Gson();
		String menuCategoryList = gson.toJson(list);
		System.out.println(menuCategoryList);
		return menuCategoryList;
	}
	
	@GetMapping("/access-denied")
	public String loadExceptionPage(HttpServletRequest request, ModelMap model) throws Exception{
		System.out.println("checkAuth작동중....");
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		MemberPrincipal memberPrincipal = (MemberPrincipal)auth.getPrincipal();
		
		System.out.println("checkAuth...."+memberPrincipal.getUsername());
		System.out.println("checkAuth...."+memberPrincipal.getAuthorities());
		
		model.addAttribute("name",memberPrincipal.getUsername());
		model.addAttribute("auth",memberPrincipal.getAuthorities());
		model.addAttribute("msg","권한이 없는 접근입니다.");
		
		return "loginError";
	}
	
	@GetMapping("/")
	public String loadAccessdeniedPage(HttpServletRequest request) throws Exception{
		return "loginError";
	}

}
