package kr.or.ddit.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.extern.slf4j.Slf4j;

@Slf4j
//스프링에게 설정 파일임을 알려주자
@Configuration
public class FileConfig implements WebMvcConfigurer{ //보는 규칙, 저장된 파일을 보는 위치
	//
	/*   웹 주소와 파일의 위치 매핑
	    *  주소줄에 이렇게 쓰면 localhost/upload/2025/02/20/개똥이.jpg
	    *  D:/springboot/upload/2025/02/20/개똥이.jpg
	    * */
	//메소드 재정의
	@Override
		public void addResourceHandlers(ResourceHandlerRegistry registry) {
			log.debug("addResourceHanlers 실행~!");
			registry.addResourceHandler("/upload/**")
					.addResourceLocations("file:///D:/upload/");
		}
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     