<%@ page language="java" contentType="text/html; charset=UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<title></title>
<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
 <!-- 카카오톡 -->
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.8/kakao.min.js"  
integrity="sha384-WUSirVbD0ASvo37f3qQZuDap8wy76aJjmGyXKOYgPL/NdAs8HhgmPlk9dz2XQsNv" crossorigin="anonymous">
</script>  
<script>
//sdk 초기화
 Kakao.init('JAVASCRIPT_KEY');

//sdk 초기화 여부 확인
console.log(Kakao.isInitialized());
</script>


<!-- 내용 iem항목 생성하기 -->
<script>
            let i = 0;
            function addIem() {
              const idx = i++;
              console.log("idx:",idx);
              const str = document.createElement('div');
              str.className = 'iem-str';
              str.innerHTML = `
                <!-- 리스트는 voteIemVOList[0].필드 -->
                <input type="hidden" name="voteIemVOList[\${idx}].voteIemNo" value="\${idx + 1}"> 
                <input class="form-control iemNm" type="text"   name="voteIemVOList[\${idx}].iemNm"  placeholder="항목명"><br/>
                <!--<textarea class="form-control" name="voteIemVOList[\${idx}].iemCn" placeholder="내용을 입력하세요" rows="3" style="resize: none;"></textarea> -->
  `;
              document.querySelector('#Iem').appendChild(str);
            }
            
            
            // 항목 없이 등록시도하면 onsubmit이벤트로 반환
            function validateVoteForm() {
        		// 항목명 input들 모두 조회
        		const iemInputs = document.querySelectorAll('.iemNm');
        		let hasItem = false;

        		iemInputs.forEach(input => {
        			if (input.value.trim() !== "") {
        				hasItem = true;
        			}
        		});

        		// 항목이 하나도 없으면 SweetAlert 띄우고 전송 막기
        		if (!hasItem) {
        			Swal.fire({
        				icon: 'warning',
        				title: '투표 항목이 없습니다',
        				text: '투표 항목을 최소 1개 이상 입력해주세요.'
        			});
        			return false; // submit 취소
        		}

        		return true; // 통과 → submit 진행
        	}
</script>
	

<!-- /// header 시작  -->
<%@ include file="../include/header.jsp"%>
<!-- /// header 끝 /// -->
<!-- body시작은 header 에서부터  -->

<!-- 	<input type="text" name="mtrSj" placeholder="제목">  -->
<!-- 	<input	type="text" name="mtrCn" placeholder="내용">  -->
<!-- 	<input	type="datetime-local" name="voteBeginDt" placeholder="시작일"> -->
<!-- 	 <input	type="datetime-local" name="voteEndDt" placeholder="마감일"> -->
<!-- 	<button type="button" onclick="addIem()">항목추가</button> -->

<!-- 	<button type="submit">등록</button> -->


<div class="col-md-9">
	<div class="card card-primary card-outline">
		<div class="card-header">
			<h3 class="card-title">새로운 투표 등록</h3>
		</div>
		<!-- /.card-header -->

		<form id="frm" method="post" action="/vote/addVote" onsubmit="return validateVoteForm();">
			<div class="card-body">
				<div class="form-group">
					<input type="text" name="mtrSj" placeholder="제목" required
						class="form-control">
				</div>
				<div class="form-group">
					<table style="border-collapse: collapse; border: none; width: 100%;">
						<tr>
							<th class="col-3" style="border: none; text-align: center;">투표 시작</th>
							<td class="col-3" style="border: none;"><input class="form-control" required
								type="datetime-local" name="voteBeginDt"></td>
							<th class="col-3" style="border: none; text-align: center;;">투표 마감</th>
							<td class="col-3" style="border: none;"><input class="form-control" required
								type="datetime-local" name="voteEndDt"></td>							 
						</tr>
					</table>
				</div>
				<div class="form-group">
					<textarea id="compose-textarea" class="form-control"
						style="height: 300px; display: none;">                      
						                           </textarea>
					<div class="note-editor note-frame card">
						<div class="note-dropzone">
							<div class="note-dropzone-message"></div>
						</div>

						<div class="note-editing-area">
							<table class="table" style="width: 100%; border: none;">
								<tr>
									<td>
										<!-- textarea도 form 전송 가능 --> <textarea class="form-control"
											name="mtrCn" placeholder="내용을 입력하세요" rows="6" required
											style="resize: none;"></textarea>
									</td>
								</tr>

								<tr>
									<td>
										<!-- 항목추가를 누르면 생기는 자리 id="Iem" -->
										<div id="Iem"></div>
										<button type="button" class="btn btn-primary mt-2 w-20"
											onclick="addIem()">항목 추가</button>
									</td>
								</tr>
							</table>


						</div>
					</div>
				</div>
			</div>
			<!-- /.card-body -->
			<div class="card-footer">
				<div class="float-right">
					<button type="submit" class="btn btn-primary">
						<i class="far fa-envelope"></i> 등록하기
					</button>
		</form>

	</div>
	<button type="reset" class="btn btn-default">
		<i class="fas fa-times"></i><a href="/vote/voteMtr">등록취소</a>
	</button>
</div>
<!-- /.card-footer -->
</div>
<!-- /.card -->
</div>

<!-- /// footer 시작  -->
<%@ include file="../include/footer.jsp"%>
<!-- /// footer 끝 /// -->

</body>
</html>