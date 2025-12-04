package kr.or.ddit.util;

public class Test {

	public static void main(String[] args) {
		// 파일 확장자 가져오기 
						//  0123456
		String fileName = "개똥이.jpg";
		
		//1) .위치를 구하자
		System.out.println(fileName.lastIndexOf("."));
		// indexOf(A) --> 문자열에 A값이 있으면 그 인덱스 값 없으면 -1
		// charAt(인덱스) --> 문자열에 인덱스값에 위치한 "문자열"char값이 나옴
		System.out.println(fileName.charAt(3));
		
		//2) substring(?) = jpg
		System.out.println(fileName.substring(fileName.lastIndexOf(".")+1));
		System.out.println(fileName.substring(fileName.lastIndexOf(".")+1, fileName.length()));
		
	}

}
