<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
<style>
	.uploadResult {
		width:100%;
		background-color: gray;
	}
	.uploadResult ul{
		display:flex;
		flex-flow: row;
		justify-content: center;
		aling-items: center;
	}
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
	}
	.uploadResult ul li img{
		width:20px;
	}
</style>
<h2>게시물 등록</h2>
<hr>
<form id="insertForm" method="post" enctype="multipart/form-data">
<input type="hidden" name="c_no" value="${c_no}">
<table class="table table-bordered">
	<tr>
		<td>게시물 제목</td>
		<td><input type="text" name="b_title" required="required" style="width:40%;"></td>
	</tr>
	<tr>
		<td>작성자</td>
		<td><input type="text" name="m_id" style="width:40%;" readonly="readonly" value="tiger"></td>
	</tr>
	<tr>
		<td>내용</td>
		<td><textarea class="text_content" id="b_content" name="b_content" rows="30%" cols="100%"></textarea></td>
	</tr>
</table>
<button type="submit" id="insertBtn" class="btn btn-outline-dark">게시물 등록</button>
<button type="reset" id="resetBtn" class="btn btn-outline-dark">리셋</button>
</form>

<script type="text/javascript">

	$(function(){
		var fileList = [];
		var uploadFileList = [];

		//이미지 파일 유효성 검사
		var imgCheck = new RegExp("^(image)/(.*?)");
		var maxSize = 10485760;
		
		//섬머노트
		$("#b_content").summernote({
			height: 700,
			minHeight:null,
			maxHeight:null,
			focus:true,
			lang:"ko-KR",
			placeholder:"본문 내용을 입력해주세요.",
			callbacks:{
				onImageUpload : function(files){
					console.log(files);
					$.each(files, function(idx, file){
						uploadSummernoteImageFile(file, $("#b_content"));
						console.log(file);
					});
				}	
			}
		})
		
		//파일처리
		function uploadSummernoteImageFile(files, editor) {
			data = new FormData();

			data.append("file", files);
			//이미지 파일인지에 대한 유효성 검사.
			if(!imgCheck.test(files.type)){
				alert("이미지 파일만 업로드 해주세요! ^3^");
				return false;
			}
			//이미지 파일 최대 용량에 대한 유효성 검사 최대 10mb로 제한
			if(files.size>maxSize){
				alert("파일의 용량이 너무 큽니다... -ㅅ-!");
				return false;
			}
			
			$.ajax({
				data : data,
				type : "POST",
				url : "/board/testUpload",
				contentType : false,
				processData : false,
				success : function(data) {
	            	//항상 업로드된 파일의 url이 있어야 한다.
					$(editor).summernote('insertImage', data.url);
					//리스트에 담기.
					fileList.push(data);
					console.log(fileList);
				}
			});
		}

		//폼태그 기본속성 제거
		$("#insertBtn").on("click",function(e){
			e.preventDefault();
			var myInsert = $("#insertForm").serialize();
			var date = new Date();
			var year = date.getYear()+1900;
			var month = date.getMonth()+1;
			if( month < 10 ) {
				month = "0"+month;
			}
			$.ajax({
				data : myInsert,
				type : "POST",
				url : "/board/insert",
				success : function(boardNum){
					console.log(boardNum);
					if(boardNum>0){
						$.each(fileList,function(idx,f){
							var url = f.url;
							var src = url.substring(12);
							var myUpload = {
								uuid : src.split("_")[0],
								filename : src.split("_")[1],
								b_no : boardNum,
								uploadpath : "C:\\\aehoUpload\\board\\"+year+"\\"+month+"\\"
							}
							uploadFileList.push(myUpload)
						})
						console.log(uploadFileList);
						$.ajax({
							data : JSON.stringify(uploadFileList),
							dataType : "json",
							contentType:"application/json; charset=utf-8",
							type : "POST",
							url : "/board/fileDBupload",
							success : function(msg){
								location.href="/board/get?b_no="+boardNum;
							}
						})
					}
				}
			})
		})
	})
</script>
<%@include file="../includes/footer.jsp"%>
