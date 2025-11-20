<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Đăng Nhập</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column; 
        height: 100vh;
        margin: 0;
    }
    .login-container {
        background-color: #fff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        width: 350px;
        text-align: left;
    }
    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 20px;
    }
    h4 {
        color: #dc3545;
        text-align: center;
        margin-bottom: 15px;
    }
    table {
        width: 100%;
    }
    td {
        padding: 8px 0;
    }
    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 10px;
        margin: 5px 0;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    input[type="submit"] {
        background-color: #007bff;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        width: 100%;
        margin-top: 10px;
        font-size: 16px;
        transition: background-color 0.3s;
    }
    input[type="submit"]:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>
    <div class="login-container">
        <%
            if(request.getParameter("err") != null && request.getParameter("err").equalsIgnoreCase("timeout")){
                %> <h4>Hết phiên làm việc. Làm ơn đăng nhập lại!</h4><% 
            } else if (request.getParameter("err") != null && request.getParameter("err").equalsIgnoreCase("fail")){
                %> <h4 style="color:red;">Sai tên đăng nhập/mật khẩu!</h4><%
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
    </div>
</body>
</html>