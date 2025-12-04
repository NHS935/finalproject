package kr.or.ddit.service.impl;

import java.time.Duration;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.VisitVhcleMapper;
import kr.or.ddit.service.VisitVhicleService;
import kr.or.ddit.vo.VisitVhcleVO;

@Service
public class VisitVhicleServiceImpl implements VisitVhicleService {

    @Autowired
    private VisitVhcleMapper visitVhicleMapper;
	
	@Override
	public int getRemainingTime(String hshldId) {
	    Integer remainingTime = visitVhicleMapper.getRemainingTime(hshldId);
	    
	    // 결과가 null이면 기본 반환
	    if (remainingTime == null) {
	        return 120;
	    }
	    
	    return remainingTime;
	    }

	@Override
	public int reserveVhicle(VisitVhcleVO visitVhcleVO) {
	    long hours = Duration.between(
	            visitVhcleVO.getParkngBeginDt().toInstant(),
	            visitVhcleVO.getParkngEndDt().toInstant()
	        ).toHours();

	        int remainingTime = visitVhicleMapper.getRemainingTime(visitVhcleVO.getHshldId());
	        if (hours > remainingTime) return -1;

	        visitVhicleMapper.insertVisit(visitVhcleVO);
	        visitVhicleMapper.updateRemainingTime(visitVhcleVO.getHshldId(), (int) hours);

	        return 1;
	}

	@Override
	public List<VisitVhcleVO> getVisitHistory(String hshldId) {
	     return visitVhicleMapper.selectVisitHistory(hshldId);
	}

	@Override
	public VisitVhcleVO getLatestVisit(String hshldId) {
	    return visitVhicleMapper.selectLatestVisit(hshldId);
	}

	@Override
	public void initNewResident(String hshldId) {
        Integer existing = visitVhicleMapper.getRemainingTime(hshldId);
        if (existing == null) {
            visitVhicleMapper.insertInitialTime(hshldId);
        }
		
	}

	@Override
	public void resetMonthlyTime() {
        visitVhicleMapper.resetMonthlyTime();
		
	}

	@Override
	public int getAccmltTime(String hshldId) {
	    Integer accmltTime = visitVhicleMapper.getAccmltTime(hshldId);
	    return accmltTime != null ? accmltTime : 0;
	}

	@Override
	public String getHshldIdByMberId(String mberId) {
        return visitVhicleMapper.selectHshldIdByMberId(mberId);
	}

	@Override
	public List<VisitVhcleVO> getVisitHistoryByMonth(String hshldId, String month) {
		  return visitVhicleMapper.selectVisitHistoryByMonth(hshldId, month);
	}

}
