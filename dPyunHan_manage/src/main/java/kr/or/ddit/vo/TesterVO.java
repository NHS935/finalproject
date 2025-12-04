package kr.or.ddit.vo;

import lombok.Data;

@Data
public class TesterVO {

	private String empId;
	private int testerId;
	private int numberMeal;
	
	public Double getTesterIdAsDouble() {
	    return (double) testerId;
	}
	
	public Double getNumberMealAsDouble() {
		return (double) numberMeal;
	}
}
