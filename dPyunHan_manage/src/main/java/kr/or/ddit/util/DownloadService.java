package kr.or.ddit.util;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class DownloadService {

	@Autowired
	private UploadController uploadController;

	public ResponseEntity<Resource> downloadFile(long fileGroupSn, int fileNo) throws IOException {
		FileDetailVO fileDetailVO = uploadController.getFileDetail(fileGroupSn, fileNo);

		if (fileDetailVO == null) {
			throw new IllegalArgumentException("파일을 찾을 수 없습니다.");
		}

		return createFileResponse(fileDetailVO);
	}

	
	public ResponseEntity<Resource> downloadSelected(List<Long> fileGroupSnList, List<Integer> fileNoList)
			throws IOException {

		// 파일 1개 선택
		if (fileGroupSnList.size() == 1 && fileNoList.size() == 1) {
			long fileGroupSn = fileGroupSnList.get(0);
			int fileNo = fileNoList.get(0);
			return downloadFile(fileGroupSn, fileNo);
		}

		return downloadFilesAsZip(fileGroupSnList, fileNoList);
	}

	public ResponseEntity<Resource> downloadAll(long fileGroupSn) throws IOException {
		List<FileDetailVO> fileDetailVOList = uploadController.getFileDetailVOList(fileGroupSn);

		if (fileDetailVOList == null || fileDetailVOList.isEmpty()) {
			throw new IllegalArgumentException("파일을 찾을 수 없습니다.");
		}

		// 파일이 1개만 있으면 단일 파일로 다운로드
		if (fileDetailVOList.size() == 1) {
			return createFileResponse(fileDetailVOList.get(0));
		}

		// 다중 파일은 ZIP으로 압축
		List<Long> fileGroupSnList = new ArrayList<>();
		List<Integer> fileNoList = new ArrayList<>();

		for (FileDetailVO file : fileDetailVOList) {
			fileGroupSnList.add(fileGroupSn);
			fileNoList.add(file.getFileNo());
		}

		return downloadFilesAsZip(fileGroupSnList, fileNoList);
	}

	
	private ResponseEntity<Resource> downloadFilesAsZip(List<Long> fileGroupSnList, List<Integer> fileNoList)
			throws IOException {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ZipOutputStream zos = new ZipOutputStream(baos);

		try {
			for (int i = 0; i < fileGroupSnList.size(); i++) {
				FileDetailVO fileDetailVO = uploadController.getFileDetail(fileGroupSnList.get(i),
						fileNoList.get(i));

				if (fileDetailVO == null) {
					continue;
				}

				Path filePath = Paths.get(fileDetailVO.getFileAbsltStrelc());

				if (!Files.exists(filePath)) {
					log.warn("파일이 존재하지 않습니다: {}", filePath);
					continue;
				}

				ZipEntry zipEntry = new ZipEntry(fileDetailVO.getFileOrginlNm());
				zos.putNextEntry(zipEntry);
				Files.copy(filePath, zos);
				zos.closeEntry();
			}
		} finally {
			zos.close();
		}

		ByteArrayResource resource = new ByteArrayResource(baos.toByteArray());
		String zipFileName = URLEncoder.encode("files.zip", "UTF-8").replaceAll("\\+", "%20");

		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + zipFileName)
				.header(HttpHeaders.CONTENT_TYPE, "application/zip").contentLength(baos.size()).body(resource);
	}

	
	private ResponseEntity<Resource> createFileResponse(FileDetailVO fileDetailVO) throws IOException {
		Path filePath = Paths.get(fileDetailVO.getFileAbsltStrelc());
		log.info("check : filePath => {}", filePath);

		Resource resource = new FileSystemResource(filePath);

		if (!resource.exists()) {
			throw new IllegalArgumentException("파일이 존재하지 않습니다.");
		}

		String originalFileName = fileDetailVO.getFileOrginlNm();
		String encodedFileName = URLEncoder.encode(originalFileName, "UTF-8").replaceAll("\\+", "%20");

		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedFileName)
				.header(HttpHeaders.CONTENT_TYPE, fileDetailVO.getFileMime()).body(resource);
	}
	
	public ResponseEntity<?> previewFile(long fileGroupSn, int fileNo) {
		try {
			FileDetailVO fileDetailVO = uploadController.getFileDetail(fileGroupSn, fileNo);
			log.info("check : previewFile / fileDetailVO => {}", fileDetailVO);

			if (fileDetailVO == null) {
				return ResponseEntity.status(HttpStatus.NOT_FOUND)
						.body("파일을 찾을 수 없습니다.");
			}

			String filePath = fileDetailVO.getFileAbsltStrelc();
			File file = new File(filePath);

			log.info("File Path 값: {}", fileDetailVO.getFileStrelc());
			log.info("실제 파일 존재 여부: {}", file.exists());

			if (!file.exists()) {
				return ResponseEntity.status(HttpStatus.NOT_FOUND)
						.body("파일 경로가 존재하지 않습니다.");
			}

			// 파일 읽기
			FileInputStream fis = new FileInputStream(file);
			byte[] fileContent = fis.readAllBytes();
			fis.close();

			// inline으로 미리보기 (attachment와 다름)
			return ResponseEntity.ok()
					.contentType(MediaType.APPLICATION_PDF)
					.header(HttpHeaders.CONTENT_DISPOSITION,
							"inline; filename=\"" + fileDetailVO.getFileOrginlNm() + "\"")
					.body(new ByteArrayResource(fileContent));

		} catch (FileNotFoundException e) {
			log.error("파일을 찾을 수 없습니다.", e);
			return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		} catch (IOException e) {
			log.error("파일 읽기 오류", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		} catch (Exception e) {
			log.error("예상치 못한 오류", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
}
