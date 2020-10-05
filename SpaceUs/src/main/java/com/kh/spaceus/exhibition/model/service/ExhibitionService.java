package com.kh.spaceus.exhibition.model.service;

import java.util.List;

import com.kh.spaceus.exhibition.model.vo.Exhibition;

public interface ExhibitionService {

	List<Exhibition> selectExList();

	int deleteExhibition(String exNo);

	int insertExhibition(Exhibition exhibition);

	Exhibition selectOne(String exNo);

	List<Exhibition> selectByTag(String tag);

	Exhibition selectOneByTag(String tag);
}
