package kr.or.ddit.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.config.BeanController;
import kr.or.ddit.mapper.FileMapper;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class UploadController {

	@Autowired
	private BeanController beanController;

	@Autowired
	private FileMapper fileMapper;

	public long multiImageUpload(MultipartFile[] multipartFiles) {
		long fileGroupSn = 0L;
		int seq = 1;
		int result = 0;

		if (multipartFiles == null || multipartFiles.length == 0) {
			log.warn("업로드 파일이 없습니다.");
			return 0L;
		}
		
		FileGroupVO fileGroupVO = new FileGroupVO();
		result += this.fileMapper.insertFileGroup(fileGroupVO);
		fileGroupSn = fileGroupVO.getFileGroupSn();
		for (MultipartFile multipartFile : multipartFiles) {
			if (multipartFile == null || multipartFile.isEmpty()) {
				log.warn("빈 파일이 감지되어 건너뜁니다.");
				continue;
			}

			String originalFilename = multipartFile.getOriginalFilename();
			if (originalFilename == null || originalFilename.trim().isEmpty()) {
				log.warn("파일명이 없는 파일이 감지되어 건너뜁니다.");
				continue;
			}

			try {
				File uploadPath = new File(
					this.beanController.getUploadFolder(), 
					this.beanController.getFolder()
				);

				if (!uploadPath.exists()) {
					uploadPath.mkdirs();
				}
				
				UUID uuid = UUID.randomUUID();
				String uploadFileName = uuid.toString() + "_" + originalFilename;
				File saveFile = new File(uploadPath, uploadFileName);

				try {
					multipartFile.transferTo(saveFile);
				} catch (IllegalStateException | IOException e) {
					log.error("파일 저장 실패: {}", originalFilename, e);
					continue;
				}
				
				String pictureUrl = "/" + this.beanController.getFolder()
					.replace("\\", "/") + "/" + uploadFileName;
				String diskPath = saveFile.getAbsolutePath();

				FileDetailVO fileDetailVO = new FileDetailVO();
				fileDetailVO.setFileNo(seq++);
				fileDetailVO.setFileGroupSn(fileGroupSn);
				fileDetailVO.setFileOrginlNm(originalFilename);
				fileDetailVO.setFileStreNm(uploadFileName);
				fileDetailVO.setFileStrelc(pictureUrl);
				fileDetailVO.setFileMg(multipartFile.getSize());

				String fileExtension = "";
				int lastDotIndex = originalFilename.lastIndexOf(".");
				if (lastDotIndex != -1 && lastDotIndex < originalFilename.length() - 1) {
					fileExtension = originalFilename.substring(lastDotIndex + 1).toLowerCase();
				}
				fileDetailVO.setFileExtsn(fileExtension);

				fileDetailVO.setFileMime(multipartFile.getContentType());
				fileDetailVO.setFileFancysize(null);
				fileDetailVO.setFileSaveDate(null);
				fileDetailVO.setFileDowncount(0);
				fileDetailVO.setFileAbsltStrelc(diskPath);
				result += this.fileMapper.insertFileDetail(fileDetailVO);
			} catch (Exception e) {
				log.error("파일 처리 중 오류 발생: {}", originalFilename, e);
				continue;
			}
		}

		log.info("파일 업로드 완료. 파일 그룹 SN: {}, 저장된 파일 수: {}", fileGroupSn, result);
		return fileGroupSn;
	}

	public String uploadFile(MultipartFile multipartFile) throws IOException {
		if (multipartFile == null || multipartFile.isEmpty()) {
			log.error("업로드할 파일이 없습니다.");
			throw new IllegalArgumentException("업로드할 파일이 없습니다.");
		}
		String originalFilename = multipartFile.getOriginalFilename();
		if (originalFilename == null || originalFilename.trim().isEmpty()) {
			log.error("파일명이 없습니다.");
			throw new IllegalArgumentException("파일명이 없습니다.");
		}
		File uploadPath = new File(
			this.beanController.getUploadFolder(), 
			this.beanController.getFolder()
		);
		if (!uploadPath.exists()) {
			uploadPath.mkdirs();
		}		
		String uploadFileName = UUID.randomUUID().toString() + "_" + originalFilename;
		File saveFile = new File(uploadPath, uploadFileName);
		try {
			multipartFile.transferTo(saveFile);
			log.info("파일 저장 성공: {}", uploadFileName);
		} catch (IOException e) {
			log.error("파일 저장 실패: {}", originalFilename, e);
			throw e;
		}
		return saveFile.getAbsolutePath();
	}

	public List<FileDetailVO> getFileDetailVOList(Long fileGroupSn) {
		if (fileGroupSn == null || fileGroupSn <= 0) {
			log.warn("유효하지 않은 파일 그룹 SN: {}", fileGroupSn);
			return List.of();
		}
		return this.fileMapper.getFileDetailVOList(fileGroupSn);
	}

	public FileDetailVO getFileDetail(long fileGroupSn, int fileNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("fileGroupSn", fileGroupSn);
		map.put("fileNo", fileNo);

		return this.fileMapper.getFileDetail(map);
	}

	public FileDetailVO commitTempFile(long fileGroupSn, File tempFile, String originalFilename) throws IOException { // 🚨 반환 타입 변경
		FileGroupVO fileGroupVO = new FileGroupVO();
		this.fileMapper.insertFileGroup(fileGroupVO);
		fileGroupSn = fileGroupVO.getFileGroupSn();

		// --- 1. [새 파일] 영구 저장 경로 생성 ---
		String uploadRootPath = beanController.getUploadFolder();
		String yearMonthDayPath = beanController.getFolder();
		File newUploadPath = new File(uploadRootPath, yearMonthDayPath);
		if (!newUploadPath.exists()) {
			newUploadPath.mkdirs();
		}

		// --- 2. [새 파일] 저장용 파일명(UUID) 및 확장자 생성 ---
		String newStorageFileName = UUID.randomUUID().toString() + "_" + originalFilename;
		File permanentFile = new File(newUploadPath, newStorageFileName);

		String fileExtsn = "";
		if (originalFilename.contains(".")) {
			fileExtsn = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
		}

		// --- 3. (★핵심★) 임시 파일을 영구 저장소로 "이동" ---
		try {
			Files.move(tempFile.toPath(), permanentFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
			log.info("임시 파일 커밋 성공: {} -> {}", tempFile.getAbsolutePath(), permanentFile.getAbsolutePath());
		} catch (IOException e) {
			log.error("임시 파일 이동 실패", e);
			throw e;
		}

		// --- 4. FileDetailVO 객체 생성 및 필드 설정 ---
		FileDetailVO committedFileVO = new FileDetailVO();

		committedFileVO.setFileGroupSn(fileGroupSn);

		committedFileVO.setFileOrginlNm(originalFilename);
		committedFileVO.setFileStreNm(newStorageFileName);

		// fileStrelc (웹 접근 경로) 생성
		String fileStrelc = "/" + yearMonthDayPath.replace(File.separator, "/") + "/" + newStorageFileName;
		committedFileVO.setFileStrelc(fileStrelc);

		// [추가] 서버 절대 경로 설정 (다운로드 시 사용)
		committedFileVO.setFileAbsltStrelc(permanentFile.getAbsolutePath());

		committedFileVO.setFileMg(permanentFile.length());
		committedFileVO.setFileExtsn(fileExtsn);

		// MIME 타입 설정
		try {
			String fileMime = Files.probeContentType(permanentFile.toPath());
			committedFileVO.setFileMime(fileMime);
		} catch (IOException e) {
			log.warn("MIME 타입 조회 실패: {}", permanentFile.getName());
			committedFileVO.setFileMime("application/octet-stream");
		}

		// --- 5. [새 파일] DB INSERT ---
		this.fileMapper.insertFileDetail(committedFileVO);

		log.info("임시 PDF 파일 정보 DB 저장 완료. (FileGroupSn: {})", committedFileVO.getFileGroupSn());

		// 🚨 [수정됨] 최종적으로 FileDetailVO 객체를 반환합니다.
		return committedFileVO;
	}

	/**
	 * 기존 파일 그룹에 새로운 MultipartFile 배열을 추가하고 DB에 등록합니다.
	 * (commitTempFile 메서드가 FileDetailVO를 반환한다고 가정)
	 * @param existingFileGroupSn 파일이 추가될 기존 그룹의 SN (0보다 커야 함)
	 * @param inputFiles 새로 업로드된 파일 배열 (MultipartFile[])
	 */
	public void appendFilesToGroup(long existingFileGroupSn, MultipartFile[] inputFiles) throws IOException {

		if (inputFiles == null || inputFiles.length == 0 || existingFileGroupSn <= 0) {
			log.warn("첨부할 파일이 없거나 유효하지 않은 그룹 SN입니다.");
			return;
		}

		for (MultipartFile multipartFile : inputFiles) {
			if (multipartFile.isEmpty()) continue;

			File tempFile = null;
			try {
				// 1. MultipartFile을 임시 디스크 위치로 전송/저장
				tempFile = File.createTempFile("append_", ".tmp");
				multipartFile.transferTo(tempFile);

				// 2. commitTempFile 메서드를 호출하여 파일 영구 이동 및 DB 등록 처리
				//    existingFileGroupSn을 전달하여 기존 그룹에 파일을 추가합니다.
				this.commitTempFile(existingFileGroupSn, tempFile, multipartFile.getOriginalFilename());

			} catch (Exception e) {
				log.error("파일 그룹[{}]에 추가 중 오류 발생: {}", existingFileGroupSn, multipartFile.getOriginalFilename(), e);
				// 오류 발생 시 다음 파일로 넘어가거나, 예외를 던져 트랜잭션을 롤백할 수 있습니다.
				// 여기서는 사용자 경험을 위해 다음 파일로 넘어갑니다.
				continue;
			} finally {
				// 임시 파일이 디스크에 남아있다면 삭제 (commitTempFile이 move를 성공하면 이미 삭제됨)
				if (tempFile != null && tempFile.exists() && tempFile.length() == 0) {
					tempFile.delete();
				}
			}
		}
	}

}
