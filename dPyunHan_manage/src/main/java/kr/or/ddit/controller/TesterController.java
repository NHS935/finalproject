package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.service.impl.UserDetailServiceImpl;
import kr.or.ddit.util.simpleLinearRegression.RegressionDataPoint;
import kr.or.ddit.util.simpleLinearRegression.SimpleLinearRegression;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.TesterVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/tester")
public class TesterController {
	@Autowired
	UserDetailServiceImpl userDetailServiceImpl;

	@Autowired
	SimpleLinearRegression regressor;

	@GetMapping("/slr")
	public String slr(
			@AuthenticationPrincipal CustomUser customUser,
			Model model
			) {
		EmpVO empVO = customUser.getEmpVO();

		List<TesterVO> testerVOList = this.userDetailServiceImpl.getTesterList(empVO);
		
		model.addAttribute("testerVOList", testerVOList);
		return "tester/slr";
	}

	@ResponseBody
	@PostMapping("/predict")
	public Map<String, Object> predict(
			@RequestBody Map<String, Object> map,
			@AuthenticationPrincipal CustomUser customUser
			) {
		EmpVO empVO = customUser.getEmpVO();

		List<TesterVO> testerVOList = this.userDetailServiceImpl.getTesterList(empVO);
		
		List<RegressionDataPoint> trainingData = new ArrayList<>();

		for (TesterVO testerVO : testerVOList) {
			trainingData.add(new RegressionDataPoint(testerVO.getTesterIdAsDouble(), testerVO.getNumberMealAsDouble()));
		}

		regressor.train(trainingData);

		Object obj = map.get("varX");

		if (obj instanceof Number) {
			Number num = (Number) obj;

			double var = num.doubleValue();
			double amt = regressor.predict(var);
			map.put("amt", amt);
		}

		List<Integer> days = new ArrayList<>();
		List<Double> values = new ArrayList<>();
		
		for(TesterVO testerVO : testerVOList) {
			days.add(testerVO.getTesterId());
			values.add(testerVO.getNumberMealAsDouble());
		}

		map.put("days", days);
		map.put("values", values);
		
		return map;
	}	

}
