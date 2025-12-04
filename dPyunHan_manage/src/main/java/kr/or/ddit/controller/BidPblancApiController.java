package kr.or.ddit.controller;

import kr.or.ddit.dto.BidPblancResponseDto;
import kr.or.ddit.service.BidIntegrationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping("/api/bidPblanc")
@RequiredArgsConstructor
public class BidPblancApiController {

    private final BidIntegrationService bidIntegrationService;

    @GetMapping("/list")
    public ResponseEntity<?> getBidPblancList(
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(defaultValue = "pblancDate") String sortField,
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "desc") String sortDirection,
            @RequestParam Map<String, Object> allFilters) {

        log.info("통합 입찰 리스트 요청 - page: {}, keyword: {}", currentPage, keyword);

        // 1. 전체 데이터 가져오기 (서울+경기+경북)
        List<BidPblancResponseDto> allData = bidIntegrationService.getAllBids();

        // 2. 키워드 검색 (제목 or 공고번호)
        if (!keyword.isEmpty()) {
            allData = allData.stream()
                    .filter(dto -> dto.getBidTitle().contains(keyword) ||
                            dto.getBidNo().contains(keyword))
                    .collect(Collectors.toList());
        }

        // 3. 정렬 처리
        Comparator<BidPblancResponseDto> comparator = null;

        switch (sortField) {
            case "bidNo":     comparator = Comparator.comparing(BidPblancResponseDto::getBidNo); break;
            case "aptName":   comparator = Comparator.comparing(BidPblancResponseDto::getAptName); break;
            case "bidTitle":  comparator = Comparator.comparing(BidPblancResponseDto::getBidTitle); break;
            case "bidMethod": comparator = Comparator.comparing(BidPblancResponseDto::getBidMethod); break;
            case "bidStatus": comparator = Comparator.comparing(BidPblancResponseDto::getBidStatus); break;
            case "bidCloseDate": comparator = Comparator.comparing(BidPblancResponseDto::getBidCloseDate); break;
            default:          comparator = Comparator.comparing(BidPblancResponseDto::getPblancDate); break; // 기본값
        }

        // 오름차순/내림차순 적용
        if ("desc".equalsIgnoreCase(sortDirection)) {
            comparator = comparator.reversed();
        }
        allData.sort(comparator);

        // 4. 페이징 (Java List 자르기)
        int totalElements = allData.size();
        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalElements);

        List<BidPblancResponseDto> pagedContent;
        if (fromIndex >= totalElements) {
            pagedContent = List.of();
        } else {
            pagedContent = allData.subList(fromIndex, toIndex);
        }

        // 5. 결과 반환
        Map<String, Object> response = new HashMap<>();
        response.put("content", pagedContent);
        response.put("totalElements", totalElements);
        response.put("currentPage", currentPage);
        response.put("totalPages", (int) Math.ceil((double) totalElements / pageSize));

        return ResponseEntity.ok(response);
    }
    @GetMapping("/view/{id}")
    public ResponseEntity<?> getBidDetail(
            @PathVariable int id,
            @RequestParam String serverName) { // 서버이름 필수!

        log.info("상세 조회 요청 - ID: {}, Server: {}", id, serverName);

        BidPblancResponseDto detail = bidIntegrationService.getBidDetail(id, serverName);
        return ResponseEntity.ok(detail);
    }

}