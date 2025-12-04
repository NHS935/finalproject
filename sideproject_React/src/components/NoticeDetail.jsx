import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { noticeData } from '../data/noticeData';
import { useEffect, useState } from 'react';
import blueloading from '../animation/blue loading.json';
import Lottie from 'lottie-react';
import './NoticeDetail.css';

function NoticeDetail() {

  const { id } = useParams();
  const [loading,setLoding] = useState(true);  //로딩상태
  const [notice,setNotice] = useState(null);   //상세 데이터 상태
  const navigate = useNavigate(); 

  const location = useLocation();
  console.log(location.state);

  useEffect(()=>{   
     const time = setTimeout(()=>{

    const abcd = location.state?.post;

     const nhs = abcd || noticeData.filter(item => item.id == id)[0];
     console.log("id값 확인 :",id);
     console.log("첨부파일 확인",nhs);
     
     setNotice(nhs);
     setLoding(false);
     },1300);

     return ()=> clearTimeout(time);
  },[id]);

 if(loading){
   return (
     <div style={{ display:"flex",
        justifyContent:"center",
        alignItems:"center",
        height:"50vh"}}>
       <Lottie animationData={blueloading} loop={true} style={{width:400}} />
     </div>
   );
 }

  return (

   <div className='top'>
    <div className='notice-top-title'>
      공지사항
    </div>
    <div>
      <h2 className='notice-title'>{notice.title}</h2>
      <h2 className='notice-info'>{notice.writer} | {notice.createAt}</h2> 
    </div>
 
    <div className='notice-file-box'>
     <div className='notice-file-header'>첨부파일</div>
       <div className='notice-file-list'>
        <div className='notice-file-name'>
        <input type="checkbox" />{notice.files[0].name}
        </div>
       </div>

        <div className='notice-file-buttons'>
           <button>선택 다운로드</button>
           <button>전체 다운로드</button>
        </div>
    </div>

    <div className='notice-content' dangerouslySetInnerHTML={{__html:notice.content}}></div>
    
    <div className='notice-image'>
    <img 
     src={notice.files[0].url}
     alt={notice.files[0].name}
    />
    </div>

   <div className='notice-btn-box'>
    <button type='button' className='list' onClick={()=>navigate('/notice')}>목록</button> 
    <button type='button' className='print' onClick={()=>window.print()}>프린트</button>
   </div>

   </div>  
 );
}

export default NoticeDetail



