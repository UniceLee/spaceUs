package com.kh.spaceus.space.controller;

import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.spaceus.common.Utils;
import com.kh.spaceus.qna.model.vo.Qna;
import com.kh.spaceus.reservation.model.service.ReservationService;
import com.kh.spaceus.reservation.model.vo.ReservationAvail;
import com.kh.spaceus.space.model.service.SpaceService;
import com.kh.spaceus.space.model.vo.Attachment;
import com.kh.spaceus.space.model.vo.Option;
import com.kh.spaceus.space.model.vo.Review;
import com.kh.spaceus.space.model.vo.ReviewAttachment;
import com.kh.spaceus.space.model.vo.Space;
import com.kh.spaceus.space.model.vo.SpaceTag;
import com.kh.spaceus.space.model.vo.Star;
import com.kh.spaceus.space.model.vo.Tag;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONArray;

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
	public String insertSpace(Space space,
							  @RequestParam String optionNo,
							  @RequestParam String day,
							  @RequestParam String[] tag,
							  @RequestParam(value="upFile",required=true) MultipartFile[] upFiles,
							  HttpServletRequest request,
							  RedirectAttributes redirectAttr,
							  Principal principal
							 ) {
		space.setMemberEmail(principal.getName());
		
	   //1. 파일을 서버컴퓨터에 저장
		List<Attachment> attachList  = new ArrayList<>();
		String saveDirectory = request.getServletContext()
									  .getRealPath("/resources/upload/space");
		
		for(MultipartFile f : upFiles) {
			
			if(!f.isEmpty() && f.getSize() != 0) {
				//1. 파일명 생성
				String renamedFileName = Utils.getRenamedFileName(f.getOriginalFilename());
				
				//2. 메모리의 파일 -> 서버경로상의 파일 
				File newFile = new File(saveDirectory, renamedFileName); //임의의 자바파일객체를 만들고 이동시킴
				try {
					f.transferTo(newFile);
				} catch (IllegalStateException | IOException e) {
					e.printStackTrace();
				}
				//3. attachment객체 생성(db 저장을 위한 준비)
				Attachment attach = new Attachment();
				attach.setOName(f.getOriginalFilename());
				attach.setRName(renamedFileName);
				attachList.add(attach);
			}
		}
		space.setAttachList(attachList);
		
		//2. 게시글, 첨부파일정보를 DB에 저장
		try {
			int result1 = spaceService.insertSpace(space);
			Space spaceInfo = spaceService.selectOneSpace(space.getBusinessNo());
			String spaceNo = spaceInfo.getSpaceNo();
			
			
			List<Map<String,Object>> info = new ArrayList<Map<String,Object>>();
			ReservationAvail reservationAvail = new ReservationAvail();
			
		    info = JSONArray.fromObject(day);
		    for (Map<String, Object> memberInfo : info) {
		    	if((int)memberInfo.get("startHour")==-1||(int)memberInfo.get("endHour")==-1)
		    		continue;
		    	reservationAvail.setDay((String) memberInfo.get("day"));
		    	reservationAvail.setSpaceNo(spaceNo);
		    	reservationAvail.setStartHour((int)memberInfo.get("startHour"));
		    	reservationAvail.setEndHour((int)memberInfo.get("endHour"));
		    	int result2 = reservationService.insertReservationVail(reservationAvail);
		    } 
		    String[] array = optionNo.split(",");
		    List<Option> optionList = new ArrayList<>();
		    Option option = new Option();
		    for(String str : array) {
		    	System.out.println(str);
		    	option.setOptionNo(str);
		    	option.setSpaceNo(spaceNo);
		    	System.out.println(option);
		    	int result3 = spaceService.insertOption(option);
		    }
		    
		    int result4 = 0;
		    SpaceTag spaceTag = new SpaceTag();
		    for(String s : tag) {
		    	Tag tagOne = spaceService.selectOneTag(s);
		    	spaceTag.setSpaceNo(spaceNo);
		    	spaceTag.setTagNo(tagOne.getNo());
		    	result4 = spaceService.insertSpaceTag(spaceTag);
		    }
		    String msg = result4 > 0 ? "공간이 등록되었습니다! 심사 후 공개로 전환됩니다." : "등록실패";
		    redirectAttr.addFlashAttribute("msg", msg);
		} catch(Exception e) {
			log.error("게시물 등록 오류", e);
			
			//예외발생을 spring container에게 전달 : 지정한  예외페이지로 응답처리
			throw e;
		}
	
		return "/community/recruit/recruitList";
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
							  @RequestParam("spaceNo") String spaceNo, Principal principal,
							  @RequestParam(defaultValue = "1",
						  	  value = "cPage") int cPage,
							  HttpServletRequest request) {

		Space space = spaceService.selectOneSpace(spaceNo);
		List<Tag> tag = spaceService.selectListSpaceTag(spaceNo);
		
		
		
		//리뷰 한 페이지당 개수 제한
		final int limit = 10; //사용용도는 numPerPage와 똑같음
		int offset = (cPage - 1) * limit;
		List<Review> review = spaceService.selectListReview(spaceNo, limit, offset);
		
		//전체리뷰수 구하기
		int reviewTotal = spaceService.selectReviewTotalContents(spaceNo);
		//별점조회
		Star star = spaceService.selectStar();
		star.setSumStar(star.getStar1()+star.getStar2()+star.getStar3()+star.getStar4()+star.getStar5());
		String url = request.getRequestURI() + "?spaceNo=" + spaceNo;
		String pageBar = Utils.getPageBarHtml(cPage, limit, reviewTotal, url);
		
		int qnaTotal = spaceService.selectQuestionTotalContents(spaceNo);
		
		//qna 조회
		List<Qna> qlist = spaceService.selectQuestionList(spaceNo, limit, offset);
		String qPageBar = Utils.getPageBarHtml(cPage, limit, qnaTotal, url);
		
		
		model.addAttribute("qlist", qlist);
		model.addAttribute("qPageBar", qPageBar);
		model.addAttribute("qnaTotal", qnaTotal);
		
		
		model.addAttribute("space", space);
		model.addAttribute("tag", tag);
		model.addAttribute("loginMember", principal);

		model.addAttribute("review", review);
		model.addAttribute("reviewTotal", reviewTotal);
		model.addAttribute("star", star);
		model.addAttribute("pageBar", pageBar);
		
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
	
	//위시리스트 추가
	@RequestMapping(value="/heart.do",
					method=RequestMethod.POST)
	public void insertWishList(@RequestParam("spaceNo") String spaceNo, @RequestParam("email") String email) {
		System.out.println("좋아요클릭"+spaceNo+email);
		
		/* int result = spaceService.insertWishList(); */
		
	}
	
	
	//사업자등록증 조회
	@GetMapping("/checkIdDuplicate.do")
    public ModelAndView checkIdDuplicate1(ModelAndView mav,
    									  @RequestParam("businessNo") long businessNo) {
    	
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

