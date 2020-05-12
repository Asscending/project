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
	<h2>상품등록</h2>
	
	<form id="insertForm" method="post" enctype="multipart/form-data">
	
	<table class="table table-bordered">
		<tr>
			<td>장터 카테고리</td>
			<td><input type="hidden" id="c_no" name="c_no" readonly="readonly" value="${cv.c_no }">${cv.c_dist}</td>
		</tr>
		<tr>
			<td>상품 제목</td>
			<td><input type="text" id="g_title" name="g_title" required="required"></td>
		</tr>
		<tr>
			<td>삽니다/팝니다</td>
			<td><select name="gc_code">
				<option value="0" disabled="disabled" selected="selected">=선택=</option>
				<option value="1">팝니다</option>
				<option value="2">삽니다</option>
			</select>
			</td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><input type="text" id="m_id" name="m_id" required="required"></td>
		</tr>
		<tr>
			<td>가격</td>
			<td><input type="number" id="g_price" name="g_price" required="required"></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><textarea class="text_content" id="g_content" name="g_content" row="30%" cols="100%"></textarea></td>
		</tr>
	</table>
	<button type="submit" id="insertBtn" class="btn btn-outline-dark">등록</button>
	<button type="reset" id="resetBtn" class="btn btn-outline-dark">취소</button>
	</form>
	<script type="text/javascript">
		$(function(){
			var fileList=[];
			var uploadFileList=[];
			var imgCheck = new RegExp("^(image)/(.*?)");
			var maxSize= 10485760;
			
			$("#g_content").summernote({
				disableDragAndDrop : true,
				height: 700,
				minHeight:null,
				maxHeight:null,
				focus:true,
				lang:"ko-KR",
				placeholder:"본문 내용을 입력해주세요.",
				toolbar: [
				    ['style', ['style']],
				    ['font', ['fontsize','bold', 'italic', 'underline', 'clear']],
				    ['color', ['color']],
				    ['insert', ['picture','video']],
				    ['para', ['ul', 'ol', 'paragraph']],
				    ['table', ['table']]
				    
				 ],
				callbacks:{
					onImageUpload : function(files){
						console.log(files);
						$.each(files, function(idx, file){
							uploadSummernoteImageFile(file, $("#g_content"));
							console.log(file);
						});
					}	
				}
			})
			//파일처리
			function uploadSummernoteImageFile(file,editor){
				data=new FormData();
				data.append("file",file);
				console.log(file);

				if(!imgCheck.test(file.type)){
					alert("이미지 파일만 업로드해주세요");
					return false;
				}
				if(file.size>maxSize){
					alert("파일 용량이 너무 큽니다.");
					return false;
				}

				$.ajax({
					data: data,
					type: "POST",
					url: "/goods/testUpload",
					contentType: false,
					processData: false,
					success: function(data){
						$(editor).summernote('insertImage', data.url);
						fileList.push(data);
						console.log(fileList);
					}
				});
			}

			$("#insertBtn").on("click",function(e){
				console.log("클릭동작")
				e.preventDefault();
				var myInsert = $("#insertForm").serialize();
				var myInsert = $("#insertForm").serialize();
				var date = new Date();
				var year = date.getYear()+1900;
				var month = date.getMonth()+1;
				if( month < 10 ) {
					month = "0"+month;
				}
				$.ajax({
					data:myInsert,
					type: "POST",
					url: "/goods/insert",
					success: function(goodsNum){
						//console.log(goodsNum);
						if(goodsNum > 0){
							$.each(fileList,function(idx,f){
								var url = f.url;
								var src = url.substring(12);
								var myUpload = {
										uuid : src.split("_")[0],
										filename: src.split("_")[1],
										g_no: goodsNum,
										uploadpath: "C\\\aehoUpload\\goods\\"+year+"\\"+month+"\\"
								}
								uploadFileList.push(myUpload)
							})
							console.log(uploadFileList);
							$.ajax({
								data: JSON.stringify(uploadFileList),
								dataType: "json",
								contentType: "application/json; charset=utf-8",
								type: "POST",
								url:"/goods/fileDBupload",
								success: function(msg){
									location.href="/goods/get?g_no="+goodsNum;
								}
							})
						}
					}
				})
			})
		})
	</script>
	<%@include file="../includes/footer.jsp"%>