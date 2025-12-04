package kr.or.ddit.service.impl;

import kr.or.ddit.mapper.ManagectIemMapper;
import kr.or.ddit.service.ManagectIemService;
import kr.or.ddit.vo.ManagectIemVO;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ManagectIemServiceImpl implements ManagectIemService {
    private final ManagectIemMapper managectIemMapper;

    @Override
    @Transactional
     public int upload (MultipartFile file) throws Exception{
        List<ManagectIemVO> list = new ArrayList<>();

         int currentMaxId = managectIemMapper.getMaxId();
         int nextId = currentMaxId + 1; // 다음 시작 ID

        try (InputStream is = file.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {

            Sheet sheet = workbook.getSheetAt(0);
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                ManagectIemVO managectIemVO = new ManagectIemVO();
                managectIemVO.setManagectIemId(nextId++);
                managectIemVO.setIemNm(row.getCell(1).getStringCellValue());
                managectIemVO.setManagectAmount((int) row.getCell(2).getNumericCellValue());
                managectIemVO.setManagectIemStdrCode(row.getCell(3).getStringCellValue());
                managectIemVO.setManagectUseDe(row.getCell(4).getStringCellValue());
//                nextId++;
                list.add(managectIemVO);

            }
            System.out.println("리스트"+list);

            ;
        }
        return managectIemMapper.upload(list);
     }

     @Override
    public List<ManagectIemVO> findFeesByMonth(String managectUseDe) {
        return managectIemMapper.findFeesByMonth(managectUseDe);
    }



}
