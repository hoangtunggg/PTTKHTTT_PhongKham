<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Lên lịch làm việc</title>
<style>
    /* CSS cơ bản cho giao diện */
    body { font-family: Arial, sans-serif; text-align: center; margin: 50px; }
    .container { width: 600px; margin: 0 auto; border: 1px solid #ccc; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { color: #333; }
    .tuan-info { margin-bottom: 20px; font-weight: bold; }
    table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    th, td { border: 1px solid #000; padding: 10px; text-align: center; }
    th { background-color: #f0f0f0; }
    .button-quaylai { background-color: #00bcd4; color: white; padding: 10px 20px; border: none; cursor: pointer; margin-top: 20px; text-decoration: none; display: inline-block; }
</style>
</head>
<body>
<%
    ThanhVien currentQL = (ThanhVien)session.getAttribute("quanly");
    if(currentQL == null){
        response.sendRedirect("dangnhap.jsp?err=timeout");
        return;
    }

    BacsiDAO bacsiDAO = new BacsiDAO();
    TuanlamviecDAO tuanDAO = new TuanlamviecDAO();

    // 1. LẤY ID VÀ CHI TIẾT TUẦN HIỆN TẠI
    int idTuanHienTai = tuanDAO.getTuanhtai(); 
    session.setAttribute("idTuanlamviec", idTuanHienTai);
    TuanLamViec tuanHienTai = tuanDAO.getTuanById(idTuanHienTai);
    
    ArrayList<BacSi> listBacSi = bacsiDAO.getDSBacSi();
    
    // Chuẩn bị thông tin tuần để hiển thị
    String ngayBatDau = (tuanHienTai != null && tuanHienTai.getNgayBatDau() != null) ? tuanHienTai.getNgayBatDau().toString() : "N/A";
    String ngayKetThuc = (tuanHienTai != null && tuanHienTai.getNgayKetThuc() != null) ? tuanHienTai.getNgayKetThuc().toString() : "N/A";
%>

<div class="container">
    <h2>Lên lịch làm việc</h2>
    
    <p class="tuan-info">Tuần làm việc (từ <%= ngayBatDau %> – <%= ngayKetThuc %>)</p>

    <table>
        <thead>
            <tr>
                <th>STT</th>
                <th>Tên bác sĩ</th>
                <th>Chuyên khoa</th>
                <th>Chọn</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (listBacSi == null || listBacSi.isEmpty()) { 
            %>
                <tr>
                    <td colspan="4">Không có bác sĩ nào để lên lịch.</td>
                </tr>
            <% 
            } else {
                int stt = 1;
                for (BacSi bs : listBacSi) {
                    String tenChuyenKhoa = (String) bs.getChuyenKhoa().getTenKhoa();
            %>
                <tr>
                    <td><%= stt++ %></td>
                    <td><%= bs.getHoTen() %></td>
                    <td><%= tenChuyenKhoa %></td> <%-- Cần ánh xạ tên chuyên khoa --%>
                    <td>
                        <a href="gdlichdukien.jsp?maBS=<%= bs.getMaBS() %>">click để chọn</a>
                    </td>
                </tr>
            <% 
                }
            } 
            %>
        </tbody>
    </table>

    <a href="gdchinhql.jsp" class="button-quaylai">Về trang chủ</a>
</div>
</body>
</html>