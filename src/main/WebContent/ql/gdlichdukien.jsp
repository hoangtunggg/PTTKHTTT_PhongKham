<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Lịch Làm Việc Dự Kiến</title>
<style>
    body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
    .container { width: 90%; margin: 0 auto; padding: 20px; }
    h2 { margin-bottom: 5px; }
    .tuan-info { margin-bottom: 20px; font-weight: bold; }
    table { width: 100%; border-collapse: collapse; margin: 0 auto; }
    th, td { border: 1px solid #000; padding: 10px; text-align: center; }
    th { background-color: #f0f0f0; }
    .button-group { margin-top: 30px; }
    .button-group button { background-color: #00bcd4; color: white; padding: 10px 20px; border: none; cursor: pointer; margin: 5px; }
</style>
</head>
<body>
<%
	ThanhVien currentQL = (ThanhVien)session.getAttribute("quanly");
	if(currentQL == null){
	    response.sendRedirect("dangnhap.jsp?err=timeout");
	    return;
	}
    
    String maBacsi = request.getParameter("maBS"); 
    int idTuanlamviec = (int) session.getAttribute("idTuanlamviec");
    
    if (maBacsi == null || idTuanlamviec == 0) {
        response.sendRedirect("gdlichdukien.jsp?err=missing_params");
        return;
    }
    
    ThongtindkibsiDAO lichDangKiDAO = new ThongtindkibsiDAO();
    TuanlamviecDAO tuanDAO = new TuanlamviecDAO();
    
    TuanLamViec tuanHienTai = tuanDAO.getTuanById(idTuanlamviec);
    ArrayList<ThongTinDangKiBacSi> listLich = lichDangKiDAO.getDKiCuaBS(maBacsi, idTuanlamviec);
    
    // Lấy thông tin hiển thị tuần
    String ngayBatDau = (tuanHienTai != null && tuanHienTai.getNgayBatDau() != null) ? tuanHienTai.getNgayBatDau().toString() : "N/A";
    String ngayKetThuc = (tuanHienTai != null && tuanHienTai.getNgayKetThuc() != null) ? tuanHienTai.getNgayKetThuc().toString() : "N/A";
%>

<div class="container">
    <h2>Lịch làm việc</h2>
    
    <p class="tuan-info">Tuần làm việc (từ <%= ngayBatDau %> – <%= ngayKetThuc %>)</p>

    <table>
        <thead>
            <tr>
                <th>Ngày làm việc</th>
                <th>Ca làm việc</th>
                <th>Sửa</th>
                <th>Xóa</th>
                <th>Chọn</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (listLich == null || listLich.isEmpty()) { 
            %>
                <tr>
                    <td colspan="7">Không có lịch đăng ký nào của bác sĩ này trong tuần.</td>
                </tr>
            <% 
            } else {
                for (ThongTinDangKiBacSi ldki : listLich) {
                    // Dữ liệu từ TTDangKi
                    String ngayLamViec = ldki.getCaDangKi().getNgayLamViec();
                    String caLamViec = ldki.getCaDangKi().getCaLamViec();
                   
            %>
                <tr>
                    <td><%= ngayLamViec %></td>
                    <td><%= caLamViec %></td>
                    <td><a href="#">(click để sửa)</a></td>
                    <td><a href="#">(click để xóa)</a></td>
                    <td><a href="#">(click để chọn)</a></td>
                </tr>
            <% 
                }
            } 
            %>
        </tbody>
    </table>

    <div class="button-group">
        <button onclick="history.back()">Quay lại</button>
        <a href="gdchoncadangki.jsp">Thêm lịch làm việc</a> 
        <button>Lưu lịch</button>
    </div>
</div>
</body>
</html>