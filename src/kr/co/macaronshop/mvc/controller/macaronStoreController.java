package kr.co.macaronshop.mvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import kr.co.macaronshop.mvc.dao.StoreViewDao;
import kr.co.macaronshop.mvc.dto.PageVO;
import kr.co.macaronshop.mvc.dto.SearchVO;
import kr.co.macaronshop.mvc.dto.StoreVO;

@Controller
public class macaronStoreController {
	
	@Autowired
	private StoreViewDao storeViewDao;
	
	
	@RequestMapping(value = "/storelistController")
	public ModelAndView list(int page, String searchType, String searchValue) {
		PageVO pageInfo = new PageVO();
		int rowsPerPage = 5;			
		int pagesPerBlock = 5;		
		int currentPage = page;		
		int currentBlock = 0;			
		if(currentPage % pagesPerBlock == 0) { 
			currentBlock = currentPage / pagesPerBlock;
		}else {
			currentBlock = currentPage / pagesPerBlock+1;
		}
		int startRow = (currentPage - 1) * rowsPerPage + 1;
		int endRow = currentPage * rowsPerPage;
		SearchVO svo = new SearchVO();
		svo.setBegin(String.valueOf(startRow));
		svo.setEnd(String.valueOf(endRow));
		svo.setSearchType(searchType);
		svo.setSearchValue(searchValue);
		
		int totalRows = storeViewDao.getTotalCount(svo);
		System.out.println("totalRows: " + totalRows);
		int totalPages = 0;
		
		if(totalRows % rowsPerPage == 0) {
			totalPages = totalRows / rowsPerPage;
		}else {
			totalPages = totalRows / rowsPerPage + 1;
		}
		
		int totalBlocks = 0;
		if(totalPages % pagesPerBlock == 0) {
			totalBlocks = totalPages / pagesPerBlock;
		}else {
			totalBlocks = totalPages / pagesPerBlock + 1;
		}
		
		pageInfo.setCurrentPage(currentPage);
		pageInfo.setCurrentBlock(currentBlock);
		pageInfo.setRowsPerPage(rowsPerPage);
		pageInfo.setPagesPerBlock(pagesPerBlock);
		pageInfo.setStartRow(startRow);
		pageInfo.setEndRow(endRow);
		pageInfo.setTotalRows(totalRows);
		pageInfo.setTotalPages(totalPages);
		pageInfo.setTotalBlocks(totalBlocks);
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("storelist");
		
		List<StoreVO> list = storeViewDao.getListSearch(svo);
		
		mav.addObject("pageInfo", pageInfo);
		mav.addObject("searchType", searchType);
		mav.addObject("searchValue", searchValue);
		mav.addObject("list", list);
		return mav;
	}
	@GetMapping(value = "storeDetail")
	public ModelAndView storeDetail(int stnum) {
		ModelAndView mav = new ModelAndView("storeDetail");
		StoreVO vo = storeViewDao.storeDetail(stnum);
		mav.addObject("storevo", vo);
		return mav;
	}
}
