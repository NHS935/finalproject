package kr.or.ddit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling 
public class RestFulCrudApplication {

	public static void main(String[] args) {
		SpringApplication.run(RestFulCrudApplication.class, args);
	}

}
