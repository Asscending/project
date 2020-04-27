<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.0.min.js"></script>
<script type="text/javascript">
</script>
    <h2>게시판</h2>
    <table>
        <thead>
            <tr>
                <td>게시물번호</td>
                <td>작성자</td>
                <td>제목</td>
                <td>날짜</td>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${list }" var="board" >
                <tr>
                    <td><c:out value="${board.b_no }"/></td>
                    <td><c:out value="${board.m_id }"/></td>
                    <td><c:out value="${board.b_title }"/></td>
                    <td><c:out value="${board.b_date }"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>