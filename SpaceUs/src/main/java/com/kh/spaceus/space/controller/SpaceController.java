package com.kh.spaceus.space.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.kh.spaceus.reservation.model.service.ReservationService;
import com.kh.spaceus.reservation.model.vo.ReservationAvail;
import com.kh.spaceus.space.model.service.SpaceService;
import com.kh.spaceus.space.model.vo.Review;
import com.kh.spaceus.space.model.vo.Space;
import com.kh.spaceus.space.model.vo.Tag;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/space")
public class SpaceController {
	
	@Autowired 
	private SpaceService spaceService;
	 
	@Autowired 
	private ReservationService reservationService;
	
	//공간등록하기 화면
	@RequestMapping(value="/insertSpace.do",method = RequestMethod.GET)
	public String insertSpace() {
		return "space/insertSpace";
	}
	//공간등록 제출
	@RequestMapping(value="/insertSpace.do",method = RequestMethod.POST)
	public String insertSpace(Space space) {
		System.out.println("post메핑");
		System.out.println(space);
		return "space/insertSpace";
	}
	
	@GetMapping("/insertQuestion.do")
	public String insertQuestion(@RequestParam String memberEmail) {
				
		
		return "space/insertQuestion";
	}
	
	
	@GetMapping("/insertHashTag.do")
	public ModelAndView insertHashTag(ModelAndView mav, @RequestParam("hashTag") String hashTag) {
		log.debug("해쉬태그 등록 요청");
		//1.업무로직 : 중복체크
    	Tag tag = spaceService.selectOneTag(hashTag);
    	if(tag!=null) {
	    	mav.addObject("hashTag", hashTag);
	    	mav.setViewName("jsonView");
    	}
    	else {
    		spaceService.insertHashTag(hashTag);
	    	mav.addObject("hashTag", hashTag);
	    	mav.setViewName("jsonView");
    	}
		return mav;
	}
	
	@RequestMapping("/spaceDetail.do")
	public String spaceDetail(Model model,
							  @RequestParam("spaceNo") String spaceNo,
							  @RequestParam(defaultValue = "1",
						  		value = "cPage") int cPage) {
		//log.debug("spaceNo= {}",spaceNo);
		Space space = spaceService.selectOneSpace(spaceNo);
		List<Tag> tag = spaceService.selectListSpaceTag(spaceNo);
		
		//1.사용자 입력값 
		final int limit = 5; //사용용도는 numPerPage와 똑같음
		int offset = (cPage - 1) * limit;
		List<Review> review = spaceService.selectListReview(spaceNo, limit, offset);
		
		//전체리뷰수 구하기
		int reviewTotal = spaceService.selectReviewTotalContents(spaceNo);
		
		
		model.addAttribute("space", space);
		model.addAttribute("tag", tag);
		model.addAttribute("review", review);
		model.addAttribute("reviewTotal", reviewTotal);
		return "space/spaceDetail";
	}
	
	//예약하기버튼
	@RequestMapping("/reserveSpace.do")
	public String reserveSpace(Model model,
							   ModelAndView mav,
							   @RequestParam("spaceNo") String spaceNo,
							   @RequestParam("spaceName") String spaceName) {
		//log.debug("spaceNo= {}",spaceNo);
		//log.debug("spaceName= {}",spaceName);
		
		//spaceNo로 옵션정보가져와서 전달하기
		
		//spaceNo로 예약가능한 날짜 가져오기
		List<ReservationAvail> availList = reservationService.selectListAvail(spaceNo);
		//log.debug("rev={}",rev);
		
		model.addAttribute("spaceName", spaceName);
		mav.addObject("availList",availList);
		
		return "space/reserveSpace";
	}
	
	@RequestMapping(value="/searchSpace.do",
					method=RequestMethod.GET)
	public ModelAndView searchSpace(ModelAndView mav, @RequestParam("search_keyword") String keyword) {
		mav.addObject("keyword", keyword);
		
		
		return mav;
	}
	//사업자등록증 조회
	@GetMapping("/checkIdDuplicate.do")
    public ModelAndView checkIdDuplicate1(ModelAndView mav,
    									  @RequestParam("businessNo") int businessNo) {
    	
    	//1.업무로직 : 중복체크
    	Space space = spaceService.selectOneSpace(businessNo);
    	boolean isUsable = space == null;
    	
    	//2. model에 속성 등록
    	mav.addObject("isUsable", isUsable);
    	
    	//3. viewName : jsonView빈 지정
    	mav.setViewName("jsonView"); // /WEB-INF/views/jsonView.jsp
    	
    	return mav;
    }
	
}

