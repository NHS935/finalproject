package kr.or.ddit.util;

import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

//페이징 관련 프로퍼티 + 게시글 프로퍼티
@Getter
@Setter
@ToString
public class ArticlePage<T> {

	//민원 관리 페이지네이션
	private Integer rceptSttus;
	private String startDate;
	private String endDate;
	
	// 전체글 수
	private int total;
	// 현재 페이지 번호
	private int currentPage;
	// 페이지당 데이터 수
	private int size;
	// 전체 페이지수
	private int totalPages;
	// 블록의 시작 페이지 번호
	private int startPage;
	// 블록의 종료 페이지 번호
	private int endPage;
	// 검색어
	private String keyword = "";
	// 요청URL
	private String url = "";

	// select 결과 데이터
	private List<T> content;

	// 페이징 처리
	private String pagingArea = "";
	
	private String pagingAreaBorderedTable ="";

	// 생성자(Constructor) : 페이징 정보를 생성
	// 전체글 수 현재 페이지 번호 한 화면 목록 데이터 검색어
	public ArticlePage(int total, int currentPage, int size, List<T> content, String keyword) {
		// size : 한 화면에 보여질 목록의 행 수(10)
		this.total = total;
		this.currentPage = currentPage;
		this.size = size;
		this.keyword = keyword;
		this.content = content;
		this.url = url;

		// 전체글 수가 0이면?
		if (total == 0) {
			// 전체 페이지 수
			totalPages = 0;
			// 블록 시작번호
			startPage = 0;
			// 블록 종료번호
			endPage = 0;
			pagingArea = "";
	        return;
		} else {// 글이 있다면
				// 전체 페이지 수 = 전체글 수 / 한 화면에 보여질 목록의 행 수
				// 3 = 31 / 10
			totalPages = total / size;

			// 나머지가 있다면, 페이지를 1증가
			// 31 %10
			if (total % size > 0) {
				totalPages++;
			}

			// 페이지 블록시작번호를 구하는 공식
			// 블록시작번호 = 현재페이지 / 블록크기 * 블록크기 + 1
			startPage = currentPage / 5 * 5 + 1;

			// 현재페이지 % 페이지크기 => 0일 때 보정
			if (currentPage % 5 == 0) {
				startPage -= 5;
			}

			// 블록종료번호 = 블록시작번호 + (블록크기 - 1)
			// [1][2][3][4][5][다음]
			endPage = startPage + (5 - 1);

			// 블록종료번호 > 전체페이지수
			if (endPage > totalPages) {
				endPage = totalPages;
			}
		} // end if

		   if (rceptSttus != null || startDate != null || endDate != null) {

		          String param = "&rceptSttus=" + rceptSttus
		                       + "&startDate=" + startDate
		                       + "&endDate=" + endDate
		                       + "&keyword=" + this.keyword;

		          pagingArea = "<ul class='pagination pagination-sm m-0 justify-content-center'>";

		          if (this.startPage > 5) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage - 1) + param + "'>«</a></li>";
		          }

		          for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
		              if (pNo == this.currentPage) {
		                  pagingArea += "<li class='page-item active'><a class='page-link' href='#'>" + pNo + "</a></li>";
		              } else {
		                  pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage=" + pNo + param + "'>"
		                          + pNo + "</a></li>";
		              }
		          }

		          if (this.endPage < this.totalPages) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage + 5) + param + "'>»</a></li>";
		          }

		          pagingArea += "</ul>";

		      } else {

		          String param = "&keyword=" + this.keyword;

		          pagingArea = "<ul class='pagination pagination-sm m-0 justify-content-center'>";

		          if (this.startPage > 5) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage - 1) + param + "'>«</a></li>";
		          }

		          for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
		              if (pNo == this.currentPage) {
		                  pagingArea += "<li class='page-item active'><a class='page-link' href='#'>" + pNo + "</a></li>";
		              } else {
		                  pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage=" + pNo + param + "'>"
		                          + pNo + "</a></li>";
		              }
		          }

		          if (this.endPage < this.totalPages) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage + 5) + param + "'>»</a></li>";
		          }

		          pagingArea += "</ul>";
		      }
		   
		   pagingAreaBorderedTable += "<div class='card-footer clearfix'>";
		   pagingAreaBorderedTable += "<ul class='pagination pagination-sm m-0 float-right'>";

		    if (this.startPage > 5) {
		        pagingAreaBorderedTable += "<li class='page-item'><a class='page-link' href='"+this.url+"?currentPage="
		        + (this.startPage - 5) +"&keyword="+this.keyword+ "'>«</a></li>";
		    } // end if

		    for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
		        String activeClass = (pNo == this.currentPage) ? " active" : "";
		        pagingAreaBorderedTable += "<li class='page-item" + activeClass + "'><a class='page-link' href='"+this.url+"?currentPage=" + pNo + "&keyword="+this.keyword+"'>" + pNo
		        + "</a></li>";
		    } // end for

		    if (this.endPage < this.totalPages) {
		        pagingAreaBorderedTable += "<li class='page-item'><a class='page-link' href='"+this.url+"?currentPage="
		        + (this.startPage + 5) +"&keyword="+this.keyword + "'>»</a></li>";
		    } // end if

		    pagingAreaBorderedTable += "</ul>";
		    pagingAreaBorderedTable += "</div>";
	}
	
	// CvplRceptController - ArticlePage
	public ArticlePage(int total, int currentPage, int size, List<T> content) {
		// size : 한 화면에 보여질 목록의 행 수(10)
		this.total = total;
		this.currentPage = currentPage;
		this.size = size;
		this.content = content;
		this.url = url;

		// 전체글 수가 0이면?
		if (total == 0) {
			// 전체 페이지 수
			totalPages = 0;
			// 블록 시작번호
			startPage = 0;
			// 블록 종료번호
			endPage = 0;
			pagingArea = "";
	        return;
		} else {// 글이 있다면
				// 전체 페이지 수 = 전체글 수 / 한 화면에 보여질 목록의 행 수
				// 3 = 31 / 10
			totalPages = total / size;

			// 나머지가 있다면, 페이지를 1증가
			// 31 %10
			if (total % size > 0) {
				totalPages++;
			}

			// 페이지 블록시작번호를 구하는 공식
			// 블록시작번호 = 현재페이지 / 블록크기 * 블록크기 + 1
			startPage = currentPage / 5 * 5 + 1;

			// 현재페이지 % 페이지크기 => 0일 때 보정
			if (currentPage % 5 == 0) {
				startPage -= 5;
			}

			// 블록종료번호 = 블록시작번호 + (블록크기 - 1)
			// [1][2][3][4][5][다음]
			endPage = startPage + (5 - 1);

			// 블록종료번호 > 전체페이지수
			if (endPage > totalPages) {
				endPage = totalPages;
			}
		} // end if

		   if (rceptSttus != null || startDate != null || endDate != null) {

		          String param = "&rceptSttus=" + rceptSttus
		                       + "&startDate=" + startDate
		                       + "&endDate=" + endDate
		                       + "&keyword=" + this.keyword;

		          pagingArea = "<ul class='pagination pagination-sm m-0 justify-content-center'>";

		          if (this.startPage > 5) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage - 1) + param + "'>«</a></li>";
		          }

		          for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
		              if (pNo == this.currentPage) {
		                  pagingArea += "<li class='page-item active'><a class='page-link' href='#'>" + pNo + "</a></li>";
		              } else {
		                  pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage=" + pNo + param + "'>"
		                          + pNo + "</a></li>";
		              }
		          }

		          if (this.endPage < this.totalPages) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage + 5) + param + "'>»</a></li>";
		          }

		          pagingArea += "</ul>";

		      } else {

		          String param = "&keyword=" + this.keyword;

		          pagingArea = "<ul class='pagination pagination-sm m-0 justify-content-center'>";

		          if (this.startPage > 5) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage - 1) + param + "'>«</a></li>";
		          }

		          for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
		              if (pNo == this.currentPage) {
		                  pagingArea += "<li class='page-item active'><a class='page-link' href='#'>" + pNo + "</a></li>";
		              } else {
		                  pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage=" + pNo + param + "'>"
		                          + pNo + "</a></li>";
		              }
		          }

		          if (this.endPage < this.totalPages) {
		              pagingArea += "<li class='page-item'><a class='page-link' href='" + this.url + "?currentPage="
		                      + (this.startPage + 5) + param + "'>»</a></li>";
		          }

		          pagingArea += "</ul>";
		      }
		   
		   pagingAreaBorderedTable += "<div class='card-footer clearfix'>";
		   pagingAreaBorderedTable += "<ul class='pagination pagination-sm m-0 float-right'>";

		    if (this.startPage > 5) {
		        pagingAreaBorderedTable += "<li class='page-item'><a class='page-link' href='"+this.url+"?currentPage="
		        + (this.startPage - 5) +"&keyword="+this.keyword+ "'>«</a></li>";
		    } // end if

		    for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
		        String activeClass = (pNo == this.currentPage) ? " active" : "";
		        pagingAreaBorderedTable += "<li class='page-item" + activeClass + "'><a class='page-link' href='"+this.url+"?currentPage=" + pNo + "&keyword="+this.keyword+"'>" + pNo
		        + "</a></li>";
		    } // end for

		    if (this.endPage < this.totalPages) {
		        pagingAreaBorderedTable += "<li class='page-item'><a class='page-link' href='"+this.url+"?currentPage="
		        + (this.startPage + 5) +"&keyword="+this.keyword + "'>»</a></li>";
		    } // end if

		    pagingAreaBorderedTable += "</ul>";
		    pagingAreaBorderedTable += "</div>";
	}
	
	//bidpblanc articlPage 생성자
	public ArticlePage(int total, int currentPage, int size, List<T> content, Map<String, Object> searchParams) {
        this.total = total;
        this.currentPage = currentPage;
        this.size = size;
        this.content = content;
        this.url = "/bidPblanc/getBidPblancList";
        
        // 기본 계산 로직
        if (total == 0) {
            totalPages = 0;
            startPage = 0;
            endPage = 0;
            pagingAreaBorderedTable = "";
            return;
        } else {
            totalPages = total / size;

            if (total % size > 0) {
                totalPages++;
            }

            startPage = currentPage / 5 * 5 + 1;

            if (currentPage % 5 == 0) {
                startPage -= 5;
            }

            endPage = startPage + (5 - 1);

            if (endPage > totalPages) {
                endPage = totalPages;
            }
        }

        // 검색 파라미터를 쿼리 스트링으로 변환
        String queryString = buildQueryString(searchParams);

        // pagingAreaBorderedTable 생성 (모든 검색 조건 포함)
        pagingAreaBorderedTable = "<div class='card-footer clearfix'>";
        pagingAreaBorderedTable += "<ul class='pagination pagination-sm m-0 float-right'>";

        if (this.startPage > 5) {
            String link = this.url + "?currentPage=" + (this.startPage - 5);
            if (!queryString.isEmpty()) {
                link += "&" + queryString;
            }
            pagingAreaBorderedTable += "<li class='page-item'><a class='page-link' href='" + link + "'>«</a></li>";
        }

        for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
            String activeClass = (pNo == this.currentPage) ? " active" : "";
            String link = this.url + "?currentPage=" + pNo;
            if (!queryString.isEmpty()) {
                link += "&" + queryString;
            }
            pagingAreaBorderedTable += "<li class='page-item" + activeClass + "'><a class='page-link' href='" + link + "'>" + pNo + "</a></li>";
        }

        if (this.endPage < this.totalPages) {
            String link = this.url + "?currentPage=" + (this.startPage + 5);
            if (!queryString.isEmpty()) {
                link += "&" + queryString;
            }
            pagingAreaBorderedTable += "<li class='page-item'><a class='page-link' href='" + link + "'>»</a></li>";
        }

        pagingAreaBorderedTable += "</ul>";
        pagingAreaBorderedTable += "</div>";
    }

    // ========== 검색 파라미터를 쿼리 스트링으로 변환하는 메서드 ==========
    private String buildQueryString(Map<String, Object> searchParams) {
        if (searchParams == null || searchParams.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Object> entry : searchParams.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            // currentPage는 제외 (페이징 링크에서 직접 지정)
            if ("currentPage".equals(key) || value == null || "".equals(value.toString())) {
                continue;
            }

            if (sb.length() > 0) {
                sb.append("&");
            }
            sb.append(key).append("=").append(value);
        }

        return sb.toString();
    }
	

	@Override
	public String toString() {
		return "ArticlePage [total=" + total + ", currentPage=" + currentPage + ", totalPages=" + totalPages
				+ ", startPage=" + startPage + ", endPage=" + endPage + ", keyword=" + keyword + ", url=" + url
				+ ", content=" + content + ", pagingarea=" + pagingArea + "]";
	}

}