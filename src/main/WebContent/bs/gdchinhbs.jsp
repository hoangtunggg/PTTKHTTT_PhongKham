<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Trang chủ bác sĩ</title>
</head>
<body>
<%
ThanhVien bs = (ThanhVien) session.getAttribute("bacsi");
if(bs == null){
	response.sendRedirect("dangnhap.jsp?err=timeout");
}
%>
<h2>Trang chủ bác sĩ</h2>
<a href="gddangkilich.jsp">
	<button>Đăng kí lịch làm việc</button>
</a>
</body>
</html>