<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<meta charset="UTF-8">
	<title>Chating</title>
	<style>
		*{
			margin:0;
			padding:0;
		}
		.container{
			width: 500px;
			margin: 0 auto;
			padding: 25px
		}
		.container h1{
			text-align: left;
			padding: 5px 5px 5px 15px;
			color: #FFBB00;
			border-left: 3px solid #FFBB00;
			margin-bottom: 20px;
		}
		.chating{
			background-color: pink;
			width: 500px;
			height: 500px;
			overflow: auto;
		}
		
		.chating .me{
			color: black;
			text-align: right;
		}
		
		.chating .others{
			color: blue;
			text-align: left;
		}
		input{
			width: 330px;
			height: 25px;
		}
		#yourMsg{
			display: none;
		}
	</style>
</head>

<script type="text/javascript">
	var ws;
	function wsOpen(){
		ws = new WebSocket("ws://"+location.host+"/chat/"+$("#cr_num").val());
		wsEvt();
	}
		
	function wsEvt() {
		ws.onopen = function(data){
			//소켓이 열리면 동작
		}
		
		ws.onmessage = function(data) {
			//메세지를 받으면 동작
			var msg = data.data;
			if(msg != null && msg.trim() != ''){
				var d = JSON.parse(msg);
				if(d.type=="getId"){
					var si = d.sessionId != null ? d.sessionId : "";
					if(si != ''){
						$("#sessionId").val(si);
					}
				}else if(d.type == "message"){
					if(d.sessionId == $("#sessionId").val()){
						$("#chating").append("<p class='me'>나 :"+d.msg+"</p>");
					}else{
						$("#chating").append("<p class='others'> :"+d.userName+":"+d.msg+"</p>");
					}
				}else{
						console.warn("허용하지 않는 타입입니다.");
					}
			}
		}

		document.addEventListener("keypress", function(e){
			if(e.keyCode == 13){ //enter press
				send();
			}
		});
	}

	function chatName(){
		var userName = $("#userName").val();
		if(userName == null || userName.trim() == ""){
			alert("사용자 이름을 입력해주세요.");
			$("#userName").focus();
		}else{
			wsOpen();
			$("#yourName").hide();
			$("#yourMsg").show();
		}
	}

	function send() {
//		console.log($("#cr_num").val());
	var option ={
		type:"message",
		cr_num : $("#cr_num").val(),
		sessionId : $("#sessionId").val(),
		userName : $("#userName").val(),
		msg : $("#chatting").val()
	}
		ws.send(JSON.stringify(option));
		$('#chatting').val("");
	}
</script>
<body>
	<div id="container" class="container">
		<h1>${cr_name}의 채팅방</h1>
		<input type="hidden" id="sessionId" value=""></input><!-- 
		<input type="hidden" id="cr_num" value="${cr_num }"></input> -->		
		
		<div id="chating" class="chating">
		</div>
		
		<div id="yourName">
			<table class="inputTable">
				<tr>
					<th>사용자명</th>
					<th><input type="text" name="userName" id="userName"></th>
					<th><button onclick="chatName()" id="startBtn">이름 등록</button></th>
				</tr>
			</table>
		</div>
		<div id="yourMsg">
			<table class="inputTable">
				<tr>
					<th>메시지</th>
					<input type="hidden" id="cr_num" value="${cr_num }"></input>
					<th><input id="chatting" placeholder="보내실 메시지를 입력하세요."></th>
					<th><button onclick="send()" id="sendBtn">보내기</button></th>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>