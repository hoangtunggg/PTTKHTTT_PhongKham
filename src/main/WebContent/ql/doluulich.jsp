<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Xử lý Lưu Lịch Chính Thức</title>
<style>
    body { font-family: Arial, sans-serif; text-align: center; padding-top: 50px; }
    .message { padding: 20px; border-radius: 5px; margin: 20px auto; width: 400px; }
    .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    .button-quaylai { margin-top: 20px; padding: 10px 20px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; text-decoration: none; }
</style>
</head>
<body>
<%
    ThanhVien currentQL = (ThanhVien)session.getAttribute("quanly");
    BacSi bsDangChon = (BacSi)session.getAttribute("bacsidangchon");
    
    ArrayList<ThongTinDangKiBacSi> listDKBS = 
        (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    
    boolean success = false;
    String statusMessage = "";

    if (currentQL == null) {
        response.sendRedirect("../gddangnhap.jsp?err=timeout");
        return;
    }

    if (listDKBS == null || listDKBS.isEmpty()) {
        statusMessage = "Chưa có lịch làm việc nào để lưu. Vui lòng thêm lịch trước.";
    } else {
        
        ThongtinlichchinhthucDAO ttlichchinhthucDAO = new ThongtinlichchinhthucDAO(); 
        int idQuanLy = currentQL.getId();
        
        success = ttlichchinhthucDAO.luuLichChinhThuc(listDKBS, idQuanLy); 
        
        if (success) {
            session.removeAttribute("listDangKyBacSi");
            
            statusMessage = "Lưu Lịch Chính Thức thành công! Tất cả ca đã được DA_DUYET.";
        } else {
            statusMessage = "LỖI: Không thể lưu Lịch Chính Thức vào cơ sở dữ liệu. Vui lòng kiểm tra log.";
        }
    }
%>

    <div class="message <%= success ? "success" : "error" %>">
        <h3><%= statusMessage %></h3>
    </div>
    
    <a href="gdlichdukien.jsp" class="button-quaylai">Quay lại Lịch Dự Kiến</a>

</body>
</html>