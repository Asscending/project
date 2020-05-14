package com.aeho.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.aeho.demo.service.GoodsReplyService;
import com.aeho.demo.service.GoodsService;
import com.aeho.demo.vo.GoodsReplyVo;
import com.aeho.demo.vo.HateVo;
import com.google.gson.Gson;

import lombok.AllArgsConstructor;

@RestController
@RequestMapping("/goodsReply/*")
@AllArgsConstructor
public class GoodsReplyController {
	@Autowired
	private GoodsReplyService goodsReplyService;
	
	public void setGoodsReplyService(GoodsReplyService goodsReplyService) {
		this.goodsReplyService = goodsReplyService;
	}
	
	@GetMapping(value = "/list", produces = "application/json; charset=utf-8")
	public String list(int g_no) {
		List<GoodsReplyVo> list = goodsReplyService.listGoodsReply(g_no);
		Gson gson = new Gson();
		return gson.toJson(list);
	}
	
	@GetMapping("/insert")
	public void insert() {}
	
	@PostMapping("/insert")
	public String insert(GoodsReplyVo gv) {
		int re = goodsReplyService.insertGoodsReply(gv);
		String str = "댓글등록 실패";
		if(re>0) {
			str = "댓글등록에 성공했습니다.";
		}
		return str;
	}
	
	@GetMapping("/delete")
	public String delete(GoodsReplyVo gv) {
		String str = "댓글삭제 실패";
		int re = goodsReplyService.deleteGoodsReply(gv);
		if(re>0) {
			str = "댓글삭제에 성공했습니다.";
		}
		return str;
	}
	
	@GetMapping("/insertReply")
	@ResponseBody
	public String insertReply(GoodsReplyVo gv) {
		int gr_level = goodsReplyService.getGoodsReply(gv.getGr_ref()).getGr_level();
//		if(gv.getGr_ref() != 0) {
//			gv.setGr_level(gr_level+1);
//			System.out.println("레벨 ! ! !  :"+gv.getGr_level());
//			GoodsReplyVo grv = goodsReplyService.getGoodsReply(gv.getGr_ref());
//			goodsReplyService.updateGstep(grv);
//		}
		String result = "0";
		int re = goodsReplyService.insertGoodsReply(gv);
		if( re > 0 ) {
			result = "1";
		}
		return result;
	}
	
	@GetMapping("/deleteReply")
	@ResponseBody
	public String deleteReply(GoodsReplyVo gv) {
		String result = "0";
		int re = goodsReplyService.deleteGoodsReply(gv);
		if(re > 0) {
			result = "1";
		}
		return result;
	}
	
	@GetMapping("/getGoodsReply")
	@ResponseBody
	public String getGoodsReply(int gr_no) {
		GoodsReplyVo grv = goodsReplyService.getGoodsReply(gr_no);
		String goodsReply = new Gson().toJson(grv);
		return goodsReply;
	}
	
	

}
