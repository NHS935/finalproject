package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class FileGroupVO {
	private long fileGroupSn;
	private Date registDt;
	
	//FILE_GROUP : FILE_DETAIL = 1 : N
	private List<FileDetailVO> fileDetailVOList;
}
