<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<!DOCTYPE html html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Đăng Nhập</title>
</head>
<body>
	<%
		if(request.getParameter("err") != null && request.getParameter("err").equalsIgnoreCase("timeout")){
			%> <h4>Hết phiên làm việc. Làm ơn đăng nhập lại!</h4><% 
		} else if (request.getParameter("err") != null && request.getParameter("err").equalsIgnoreCase("fail")){
			%> <h4 color="red">Sai tên đăng nhập/mật khẩu!</h4><%
		}
	%>
	<h2> Đăng nhập </h2>
    <form name="dangnhap" action="doDangNhap.jsp" method="post">
        <table border="0">
            <tr>
                <td>Tên đăng nhập:</td>
                <td><input type="text" name="username" id="username" required /></td>
            </tr>
            <tr>
                <td>Mật khẩu:</td>
                <td><input type="password" name="password" id="password" required /></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Đăng nhập" /></td>
            </tr>
        </table>
    </form>
</body>
</html>