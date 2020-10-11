package com.kh.spaceus.admin.model.dao;

import java.util.List;

import com.kh.spaceus.admin.model.vo.ConfirmSpace;
import com.kh.spaceus.admin.model.vo.ConfirmSpaceOption;
import com.kh.spaceus.admin.model.vo.ConfirmSpaceTag;
import com.kh.spaceus.admin.model.vo.ManageBlackList;
import com.kh.spaceus.admin.model.vo.ManageMember;
import com.kh.spaceus.admin.model.vo.ManageRecruit;
import com.kh.spaceus.admin.model.vo.ManageSpace;
import com.kh.spaceus.community.group.model.vo.GroupBoard;
import com.kh.spaceus.community.group.model.vo.Report;
import com.kh.spaceus.space.model.vo.Category;
import com.kh.spaceus.space.model.vo.Space;

public interface AdminDAO {

	List<ManageMember> selectList();

	List<ManageMember> findUserIdList(String searchKeyword);

	List<ManageMember> findUserNameList(String searchKeyword);

	List<ManageMember> findUserRoleList(String searchKeyword);

	List<ManageBlackList> selectGroupList();

	List<ManageBlackList> selectRecruitList();

	List<Report> selectReasonList(String reportBoardNo);

	List<GroupBoard> selectGBList();

	List<ManageRecruit> selectrList();

	List<ManageSpace> selectSpaceList();

	List<Space> selectSpaceOneList(String spaceNo);

	List<ConfirmSpace> selectSpaceOneImageList(String spaceNo);

	List<Category> selectSpaceOneCategory(String spaceNo);

	List<ConfirmSpaceTag> selectSpaceOneTagList(String spaceNo);

	List<ConfirmSpaceOption> selectSpaceOptionList(String spaceNo);
	
}
