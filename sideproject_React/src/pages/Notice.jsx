import { AgGridReact } from "ag-grid-react";
import { useNavigate } from "react-router";
import { columnDefs, noticeData } from "../data/noticeData";
import { BookCopy } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { useLocation } from 'react-router';

console.log("체킁:",noticeData);

function Notice() {

 const navigate = useNavigate();
 const [hslist,setHslist] = useState(noticeData);  //화면에 보여주는 리스트
 const [preList,setPreList] = useState(noticeData);  //새 글 추가하기 전 원본 데이터
 const schTxt = useRef(null);

 const location = useLocation();
 const newPost = location.state?.newPost;  
 
 useEffect(()=>{  //새글 등록 시
  if(!newPost) return;
    
  //이미 같은 id가 있을 경우 추가하지않음
  setHslist(prev=>{
     if(prev.some(p=>p.id==newPost.id)) return prev; //prev는 이전상태값으로 관례적으로 prev로 사용한다., p.id=prev.id
     return [newPost,...prev];
  });

  setPreList(prev=>{
    if(prev.some(p=>p.id == newPost.id)) return prev;  //prev.some은 array.some(요소=>조건)의 의미
     return [newPost,...prev];
  })
},[newPost]);


 const click = (e)=>{
   const id = e.data.id;  //클릭한 행의 id값
   navigate(`/notice/${id}`,{state:{post:e.data}});  //post는 사용자 정의
 };

 const schBtn =()=>{  //검색버튼을 누르면
    console.log("클릭");

    const schVal = schTxt.current.value;
    console.log("검색글자",schVal);

    setHslist(preList.filter((notice)=>{
      console.log("notice확인",notice.title.includes(schVal));
      return  notice.title.includes(schVal);
   }));
 }
  
  return (
   <div className='wrap'>
    <div>
      <div className='noticelist-top'>
      공지사항
     </div>

    <div className='noticelistBtn'>
      <button onClick={()=>navigate('/notice/reg')}>글등록</button>
      <button style={{marginLeft: 5,}}>선택 삭제</button>
    </div>

   
   <div style={{ display: "flex",justifyContent: "space-between",alignItems: "center",width: "970px",marginLeft:"60px"}}>
    <div style={{display:"flex", gap:10}}>
       <BookCopy /> 총 {hslist.length}건
    </div> 

    <div className='search-container'>
       <label>
         <select>
           <option value="전체">전체</option>
           <option value="제목">제목</option>
           <option value="내용">내용</option>
         </select>
       </label>
       <input type="text" ref={schTxt} defaultValue={""}/>
       <button onClick={schBtn}>검색</button>
    </div>
    </div>
    
     <div className='grid-area'>
      <AgGridReact
         rowData={hslist}
         columnDefs={columnDefs}
         onRowClicked={click}
         pagination={true}
         paginationPageSize={12}
      />
    </div>  

      </div>
    </div>
  )
}

export default Notice