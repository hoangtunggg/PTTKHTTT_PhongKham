<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Xử lý Lưu Đăng Ký</title>
</head>
<body>
<%
    BacSi currentBS = (BacSi)session.getAttribute("bacsi");
    ArrayList<ThongTinDangKiBacSi> listDKBS = 
        (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    boolean success = false;
    String statusMessage = "";

    if (currentBS == null) {
        response.sendRedirect("dangnhap.jsp?err=timeout");
        return;
    }

    if (listDKBS == null || listDKBS.isEmpty()) {
        statusMessage = "Chưa có ca làm việc nào để lưu. Vui lòng thêm lịch trước.";
    } else {
        ThongtindkibsiDAO ttDKBSDAO = new ThongtindkibsiDAO();
        success = ttDKBSDAO.luuDangKyBacSi(listDKBS); 
        
        if (success) {
            // GHI LOG TRƯỚC KHI XÓA
            System.out.println("LOG: Saving successful. Attempting to remove listDangKyBacSi from session.");
            
            // Dòng xóa
            session.removeAttribute("listDangKyBacSi"); 
            
            // GHI LOG SAU KHI XÓA (Kiểm tra xem nó còn null không)
            if (session.getAttribute("listDangKyBacSi") == null) {
                System.out.println("LOG: listDangKyBacSi REMOVED successfully.");
            } else {
                System.out.println("LOG: ERROR! listDangKyBacSi STILL EXISTS after removeAttribute.");
            }
            
            statusMessage = "Lưu đăng kí thành công! Dữ liệu đã được cập nhật.";
        } else {
            statusMessage = "LỖI: Không thể lưu đăng kí vào cơ sở dữ liệu. Vui lòng thử lại.";
        }
    }
%>

    <div>
        <h3><%= statusMessage %></h3>
    </div>
    
    <a href="gddangkilich.jsp">Quay lại Lịch Đăng Ký</a>

</body>
</html>