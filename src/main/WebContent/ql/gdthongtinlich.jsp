<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thông tin lịch làm việc</title>
<style>
    body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
    .container { width: 700px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2 { margin-bottom: 5px; color: #333; }
    .info-box { text-align: left; margin-bottom: 25px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
    .info-box p { margin: 5px 0; font-style: italic; }
    h3 { margin-top: 20px; margin-bottom: 10px; text-align: left; }
    table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    th, td { border: 1px solid #000; padding: 10px; text-align: center; }
    th { background-color: #f0f0f0; font-weight: bold; }
    .button-quaylai { 
        background-color: #00bcd4; color: white; padding: 10px 30px; 
        border: none; cursor: pointer; margin-top: 30px; text-decoration: none; 
        display: inline-block; font-size: 16px;
    }
</style>
</head>
<body>
<%
    if(session.getAttribute("quanly") == null){
        response.sendRedirect("dangnhap.jsp?err=timeout");
        return;
    }

    String idCaParam = request.getParameter("idCa");
    if (idCaParam == null || idCaParam.isEmpty()) {
        response.sendRedirect("gdlichdukien.jsp?err=ca_missing"); 
        return;
    }
    int idCa = Integer.parseInt(idCaParam);
    
    ThongtinlichchinhthucDAO lcDAO = new ThongtinlichchinhthucDAO(); 
    CadangkiDAO caDAO = new CadangkiDAO();

    CaDangKi caChiTiet = caDAO.getCaDangKiByID(idCa);
    
    // 2. TẢI DANH SÁCH BÁC SĨ ĐÃ ĐĂNG KÝ CA NÀY (Từ TDKI, không phân biệt trạng thái)
    // Giả định: lcDAO.getDSBacSiDaDuyet(idCa) đã được điều chỉnh để lấy tất cả
    // bác sĩ đăng ký cho ca đó (hoặc bạn sẽ tạo một hàm mới: getDSBacSiDangKy)
    ArrayList<BacSi> listBacSiDangKy = lcDAO.getDSBacSiDaDuyet(idCa);

    // Chuẩn bị thông tin hiển thị
    String ngayLamViec = (caChiTiet != null) ? caChiTiet.getNgayLamViec() : "N/A";
    String caLamViecGio = (caChiTiet != null) ? caChiTiet.getCaLamViec() : "N/A";
    
    // Trích xuất Giờ từ chuỗi ca làm việc (Ví dụ: 7:00-9:00 -> 7:00-9:00)
    String gioLamViec = (caChiTiet != null) ? caChiTiet.getCaLamViec().replaceAll("[^0-9:-]", "") : "N/A";

%>

<div class="container">
    <h2>Thông tin lịch làm việc</h2>
    
    <div class="info-box">
        <p>Ngày làm việc: <strong><%= ngayLamViec %></strong></p>
        <p>Ca làm việc: <strong><%= gioLamViec %></strong></p>
    </div>

    <h3>Danh sách nhân sự đã đăng kí</h3>

    <table>
        <thead>
            <tr>
                <th>Họ tên</th>
                <th>Chuyên khoa</th>
                <th>SĐT</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (listBacSiDangKy == null || listBacSiDangKy.isEmpty()) { 
            %>
                <tr>
                    <td colspan="3" style="text-align: center;">Không có bác sĩ nào đăng ký ca này.</td>
                </tr>
            <% 
            } else {
                for (BacSi bs : listBacSiDangKy) {
                    // Lấy dữ liệu an toàn
                    String hoTen = (bs.getHoTen() != null) ? bs.getHoTen() : "Không rõ";
                    String sdt = (bs.getSdt() != null) ? bs.getSdt() : "N/A";
                    String chuyenKhoa = (bs.getChuyenKhoa() != null && bs.getChuyenKhoa().getTenKhoa() != null) 
                        ? bs.getChuyenKhoa().getTenKhoa() : "N/A";
            %>
                <tr>
                    <td><%= hoTen %></td>
                    <td><%= chuyenKhoa %></td>
                    <td><%= sdt %></td>
                </tr>
            <% 
                }
            } 
            %>
        </tbody>
    </table>

    <button onclick="history.back()" class="button-quaylai">Quay lại</button>
</div>
</body>
</html>