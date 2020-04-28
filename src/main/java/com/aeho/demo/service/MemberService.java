package com.aeho.demo.service;

import java.util.List;

import com.aeho.demo.vo.MemberVo;

public interface MemberService {

	List<MemberVo> listMember();
	
	MemberVo getMember(MemberVo mv);
	
	int insertMember(MemberVo mv);
	
	int updateMember(MemberVo mv);
	
	int deleteMember(MemberVo mv);
}