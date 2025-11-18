<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Trang chủ quản lý</title>
</head>
<body>
<%
ThanhVien ql = (ThanhVien) session.getAttribute("quanly");
if(ql == null){
	response.sendRedirect("dangnhap.jsp?err=timeout");
}
%>
<h2>Trang chủ quản lý</h2>
<a href="gdlenlichlamviec.jsp">
	<button>Lên lịch làm việc</button>
</a>
</body>
</html>