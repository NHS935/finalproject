package kr.or.ddit.config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import jakarta.servlet.DispatcherType;
import kr.or.ddit.security.CustomAccessDeniedHandler;
import kr.or.ddit.security.CustomLoginSuccessHandler;
import kr.or.ddit.security.CustomLogoutSuccessHandler;
import kr.or.ddit.service.impl.UserDetailServiceImpl;

// 스프링이 환경설정을 위한 자바빈 객체로 미리 등록해줌
@Configuration
@EnableWebSecurity(debug = false)
@EnableMethodSecurity // 골뱅이 PreAuthorize / 골뱅이 PostAuthorize를 사용함
public class SecurityConfig {

   //0. 스프링 시큐리티의 사용자정보를 담은 객체 D.I(의존성 주입)
   @Autowired
   UserDetailServiceImpl detailServiceImpl;
      
//    private final DemoApplication demoApplication;
//
//    SecurityConfig(DemoApplication demoApplication) {
//        this.demoApplication = demoApplication;
//    }
   // 1. 스프링 시큐리티 기능 비활성화
   /*
    * 스프링 시큐리티의 모든 기능을 사용하지 않게 설정하는 코드. 즉, 인증, 인가 서비스를 모든 곳에 적용하지는 않음 
    * 일반적으로 정적리소스(이미지, js, css, upload, HTML 파일)에 설정함. 
    * 정적 리소스만 스프링 시큐리티 사용을 비활성화 하는 데 static 하위 경로에 있는 리소스를 대상으로 ignoring() 메서드를 사용함
    */
   @Bean
   public WebSecurityCustomizer configure() {
      return (web) -> web.ignoring().requestMatchers(new AntPathRequestMatcher("/static/**"));
   }
   //***2. 특정 HTTP 요청에 대한 웹 기반 보안 구성
   /*
    이 메서드에서 인증/인가 및 로그인, 로그아웃 관련 설정을 할 수 있음
    
    클라이언트 ----> 필터1 ----> 필터2 ---> 필터3 ---> 서버
    클라이언트 <---- 필터1 <---- 필터2 <--- 필터3 <--- 서버
    
              req      req         req        req
              resp      resp      resp      resp
              
    * CSRF(Cross-Site Request Forgery) 보호 비활성화
     
              
    * HTTP Basic : 시큐리티에서 제공해주는 기본 인증 방식(구식 form), HTTP Basic 인증 비활성화 
    
    * sameOrigin : iframe 설정
       X-Frame-Options 헤더는 브라우저에서 렌더링을 허용, 금지 여부를 결정하는 응답헤더이다. 
       헤더 설정: X-Frame-Options를 SAMEORIGIN으로 설정하여 동일 출처의 프레임만 허용 (H2 콘솔 등 사용 시 필요)
         사용 가능한 옵션은 아래와 같다.
         DENY : iframe 비허용(불가)
         SAMEORIGIN : 동일 도메인 내에선 접근 가능
         ALLOW-FROM {도메인} : 특정 도메인 접근 가능
    * .authorizeHttpRequests(... : // HTTP 요청에 대한 인가 규칙 설정
          
    * authz.dispatcherTypeMatchers(DispatcherType.FORWARD..
                    : FORWARD, ASYNC 디스패처 유형의 요청은 모두 허용 (서블릿 포워딩 등)
                    
    * .requestMatchers(... : 특정 경로들에 대한 요청은 인증 없이 모두 허용
     
    * "/ceo/**" 경로는 "CEO" 역할을 가진 사용자만 접근 허용 
     
    * "/manager/**" 경로는 "CEO" 또는 "MANAGER" 역할을 가진 사용자만 접근 허용 
     
    * .anyRequest().authenticated() : 위에서 설정한 경로 외의 모든 요청은 인증된 사용자만 접근 허용 
     
     
     // 폼 기반 로그인 설정
    .formLogin(formLogin -> formLogin
            // 사용자 정의 로그인 페이지 경로 설정
            .loginPage("/login")
            // 로그인 성공 시 리다이렉트(새로운 URI로 재요청)될 기본 URL 설정
            .defaultSuccessUrl("/articles/list")
    )
    // 세션 관리 설정
    .sessionManagement(session -> session
            // 최대 동시 세션 수를 1로 제한 (중복 로그인 방지)
            .maximumSessions(1)
    )
    // 로그아웃 설정
    .logout(logout -> logout
            // 로그아웃 성공 시 리다이렉트될 URL 설정
            .logoutSuccessUrl("/login")
            // 로그아웃 시 HTTP 세션 무효화
            .invalidateHttpSession(true)
    )
    // SecurityFilterChain 빌드 및 반환
    .build(); 
     
     [접근제한자]
     public 프로젝트 내 모든 클래스
     private 해당 클래스 내부
     protected 패키지 내의 클래스, 상속받은 자식 클래스
     
     csrf = cross site request forgery ==> 네트워크 공격
     
     .logoutSuccessUrl("/login") //로그아웃 성공 시 이동할 URL
     
     .requestMatchers("member/list").permitAll()
   .requestMatchers("member/regist").hasAnyRole("ADMIN", "MEMBER")
   //hasAnyRole : 둘 중에 하나의 권한만 있어도 인가
   .requestMatchers("notice/list").permitAll()
   .requestMatchers("/notice/regist").hasRole("ADMIN")
   //securityConfig에서만 ROLE_접두어 생략하자 라고 약속 되어있음
   //security가 auth 속성값에 member 권한이 있는지 필터 (ROLE_MEMBER => ROLE_ 생략가능)
     
    */
   @Bean
   protected SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
      
      return http.csrf(csrf->csrf.disable()).httpBasic(hb->hb.disable())
            .headers(config->config.frameOptions(customizer->customizer.sameOrigin()))
            .requestCache(cache -> cache.requestCache(new HttpSessionRequestCache()))
            .exceptionHandling(exceptionHandling -> exceptionHandling //권한이 없을때
                   .authenticationEntryPoint((request, response, authException) -> {
                	   String requestURI = request.getRequestURI();
                       System.out.println("========================================");
                       System.out.println("인증 예외 발생!");
                       System.out.println("요청 URI: " + requestURI);
                       System.out.println("쿼리 스트링: " + request.getQueryString());
                       System.out.println("예외 메시지: " + authException.getMessage());
                       System.out.println("========================================");
                       System.out.println("인증 예외 요청 URI: " + requestURI);                       
                       if (requestURI.startsWith("/bdder/postBdder")) {
                           // 협력업체 로그인
                           response.sendRedirect("/ccpyManage/loginCcpyManage");
                           return;
                       } else if(requestURI.contains("/bidPblanc/getBidPblancListAsEmp") || 
                               requestURI.contains("/bidPblanc/getBidPblancAsEmp")) {
                    	   response.sendRedirect("/emp/login");  
                       } else if(requestURI.startsWith("/bidPblanc/getBidPblanc")) {
                          response.sendRedirect("/ccpyManage/loginCcpyManage");
                          return;
                       } else {
                           // 그 외 → 일반 로그인
                           response.sendRedirect("/login");
                           return;
                       }
                   })
                   .accessDeniedHandler(new CustomAccessDeniedHandler()))
            .authorizeHttpRequests( //권한이 있다면 페이지 이동을 
                     authz->authz.dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll()
                     .requestMatchers("/accessError/**", "/login/**", "/signup/**","/sign/**","/api/**"
								, "/js/**", "/adminlte/**", "/images/**", "/cvplRcept/**", "/sbadmin2/**"
								, "/css/**", "/.well-known/**", "/video/**"
								, "/favicon.ico", "/favicon/**", "/ws-ntcn/**", "/ws/**"
								, "/ntcn/**" , "/ccpyManage/**", "/animations/**"
								,"/upload/**", "/error/**" ,"/tester/**").permitAll()                    
                     // .anyRequest().authenticated()
                     .requestMatchers("/bidPblanc/getBidPblancListAsEmp").hasRole("EMP")
                     .requestMatchers("/bidPblanc/getBidPblancAsEmp*").hasRole("EMP")
                     .requestMatchers("/bidPblanc/getBidPblanc").hasRole("CCPY")
                     .requestMatchers("/bidPblanc/postBidPblanc*").hasRole("EMP")
                     .requestMatchers("/bidPblanc/**").permitAll()
                     .requestMatchers("/bdder/postBdder").hasRole("CCPY")
                     .requestMatchers("/elctrnsanctn/**").hasRole("EMP")
                     .requestMatchers("/bdder/getMyBdderList").hasRole("CCPY")
                     .requestMatchers("/bdder/**").permitAll()
                     .requestMatchers("/chat/**").authenticated()  //나혜선 추가
                     .requestMatchers("/notice/register/**").hasRole("ADMIN") //공지사항등록 admin만
					 .requestMatchers("/notice/list/**").hasRole("ADMIN") //공지사항등록 admin만
					 .requestMatchers("/notice/wnmpy_notice/**").hasAnyRole("EMP", "ADMIN")
					 .anyRequest().authenticated())
                           //.anyRequest().permitAll()) // 테스트 중에 일단 모두 허락
            .formLogin(formLogin->formLogin.loginPage("/login")
                                    .successHandler(new CustomLoginSuccessHandler())//.defaultSuccessUrl("/member/list"))
                                    .failureUrl("/login?error"))
            .sessionManagement(session->session.maximumSessions(1))
            .logout(logout->logout.logoutUrl("/logout") // 로그아웃을 처리할 URL <form action"/logout" method="post".../>
                           .logoutSuccessHandler(new CustomLogoutSuccessHandler())
                           .invalidateHttpSession(true)) // 세션 무효화(session.invalidate()시 세션의 속성이 모두 사라짐)            
            .build();
   }
   
   //3. 인증 관리자 관련 설정(UserDetailServiceImpl)
   /*
    사용자 정보를 가져올 서비스를 재정의하거나, 인증 방법, 예를들어 LDAP, JDBC 기반 인증 등을 설정할 때 사용함
    */
   /* 
    요청URI : /login
    요청파라미터 : request{username=test@test.com,password=java}
    요청방식 : post
    
    crypt : 암호화 관련
    DAO : Data Access Object (DB 접근 도우미)
    */
   @Bean
   public AuthenticationManager authenticationManager(HttpSecurity http, 
         BCryptPasswordEncoder bCryptPasswordEncoder
         ) throws Exception {
      
      //4. 사용자 정보 서비스 설정
      /*
      userDetailsService() : 사용자 정보를 가져올 서비스를 설정함.
                         이때 설정하는 서비스클래스는 반드시 UserDetailsService를 상속받은 클래스여야 함.
      passwordEncoder() : 비밀번호를 암호화하기 위한 인코더를 설정
      */
      DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
      authProvider.setUserDetailsService(detailServiceImpl);
      authProvider.setPasswordEncoder(bCryptPasswordEncoder);
      
      return new ProviderManager(authProvider);
   }// end authenticationManager
   
   //패스워드 인코더로 사용할 빈등록
   //서버 구동할때
   @Bean
   public BCryptPasswordEncoder bCryptPasswordEncoder() {
      return new BCryptPasswordEncoder();
   }
      
}// end Security

