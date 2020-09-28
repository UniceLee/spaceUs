package com.kh.spaceus.community.group.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.spaceus.community.group.model.dao.GroupDAO;
import com.kh.spaceus.community.group.model.vo.Board;
import com.kh.spaceus.community.group.model.vo.Report;
import com.kh.spaceus.community.group.model.vo.GroupBoard;

@Service
public class GroupServiceImpl implements GroupService {
	
	@Autowired
	private GroupDAO groupDAO;

	@Override
	public List<Board> selectListBoard() {
		return groupDAO.selectListBoard();
	}

	@Override
	public List<GroupBoard> selectListGroupBoard() {
		return groupDAO.selectListGroupBoard();
	}

	@Override
	public List<GroupBoard> selectSortedListGroupBoard(Map<String, String> listMap) {
		return groupDAO.selectSortedListGroupBoard(listMap);
	}

	@Override
	public int selectTotalCnt() {
		return groupDAO.selectTotalCnt();
	}

	@Override
	public List<GroupBoard> selectDetailBoard(String groupBoardNo) {
		return groupDAO.selectDetailBoard(groupBoardNo);
	}

	@Override
	public int insertBoard(GroupBoard gb) {
		return groupDAO.insertBoard(gb);
	}

	@Override
	public int updateBoard(GroupBoard gb) {
		return groupDAO.updateBoard(gb);
	}

	@Override
	public int deleteBoard(String groupBoardNo) {
		return groupDAO.deleteBoard(groupBoardNo);
	}

	@Override
	public int increaseBoardReadCnt(String groupBoardNo) {
		return groupDAO.increaseBoardReadCnt(groupBoardNo);
	}

	@Override
	public List<Report> selectOne(Map<Object, Object> map) {
		return groupDAO.selectOne(map);
	}
	
	

}
