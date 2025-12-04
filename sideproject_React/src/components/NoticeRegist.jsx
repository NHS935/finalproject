import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
import { CKEditor } from '@ckeditor/ckeditor5-react';
import { useState } from 'react';
import { useNavigate } from 'react-router';
import { noticeData } from '../data/noticeData';
import './NoticeDetail.css';

function NoticeRegist() {

  const [title,setTitle] = useState("");
  const [content,setContent] = useState("");
  const navigate = useNavigate();   //navigate(경로,옵션)

  const regist = ()=>{
    const newId= Math.max(...noticeData.map(i=>i.id))+1;  //가장 큰값을 찾아서 +1 하기

    const newPost={
      id:newId,
      title:title,
      content:content,
      writer:"총무팀",
      createAt:new Date().toISOString().split("T")[0],
      check:true,
      files: [
       { name: "서버점검.jpg", url: "/uploads/서버점검.jpg" }
      ]
    };
    noticeData.push(newPost);
    console.log("추가됨 체킁: ",noticeData);

    navigate('/notice',{state:{newPost}});  //state: 페이지를 이동하면서 데이터까지 같이 보내주는 역할을 하는 옵션
  }

  // async function getData(){
  //   try{
  //       const resp = await axios.get(noticeData);
  //       console.log("글등록 값 확인",resp.data);
  //   }catch(err){
  //      console.error("에러확인",err);
  //   }
  // }

  return (
    <div className='notice-reg-top'>
  
    <h2 className='notice-reg-title'>공지사항 글 작성</h2>
 
    <div style={{width:"800px", marginLeft:30}}>

      <div className='notie-reg-input'>
        <input type='text' placeholder="제목을 입력해주세요." value={title} onChange={(e)=>setTitle(e.target.value)}/>
      </div>

    <CKEditor 
       editor={ClassicEditor} 
       data={content}
       config={{placeholder:"내용을 입력해주세요."}}
       onChange={(event,nhs)=>{
        const val = nhs.getData();
        console.log("값 확인",val);
        setContent(val);
       }}       
       />

      <div className='notice-reg-btn-box'>
       <button type='button'>임시저장</button>
       <button type='button' className='noticeregBtn' onClick={regist}>등록</button>
      </div>

      </div>

    </div>
  )
}

export default NoticeRegist