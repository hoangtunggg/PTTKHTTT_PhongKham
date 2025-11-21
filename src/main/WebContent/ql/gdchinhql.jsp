<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Trang chủ quản lý</title>
<style>
    body {
        font-family: Arial, sans-serif;
        padding: 40px;
        text-align: center;
        display: flex; 
        flex-direction: column;
        align-items: center;
    }
    .container {
        width: 350px;
        padding: 20px;
        box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
        background-color: #fff;
    }
    button {
        background-color: #007bff; 
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        margin: 8px 0;
        width: 100%;
        transition: background-color 0.3s;
    }
    .logout-button {
        background-color: #dc3545 !important; 
    }
    a {
        text-decoration: none;
        display: block;
    }
</style>
</head>
<body>
<div class="container">
<%
ThanhVien ql = (ThanhVien) session.getAttribute("quanly");
if(ql == null){
	response.sendRedirect("../gddangnhap.jsp?err=timeout"); 
	return; 
}
%>
<h2>Trang chủ quản lý</h2>

<a href="gdlenlichlamviec.jsp">
	<button>Lên lịch làm việc</button>
</a>

<a href="../dodangxuat.jsp">
    <button class="logout-button">Đăng xuất</button>
</a>
</div>
</body>
</html>