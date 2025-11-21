<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Chọn ca đăng kí</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        text-align: center;
        padding: 20px;
    }
    div {
        max-width: 700px;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    h2 {
        color: #333;
        margin-bottom: 15px;
    }
    table {
        width: 100%;
        border-collapse: collapse; /* Xóa khoảng trống giữa các ô */
        margin: 20px 0;
    }
    th, td {
        border: 1px solid #aaa; /* Viền bảng rõ ràng */
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #e0e0e0;
        font-weight: bold;
    }
    
    .disabled-link {
        color: #999;
        border: 1px solid #999;
        background-color: #f0f0f0;
        cursor: not-allowed;
        pointer-events: none; /* Ngăn không cho click */
    }
    
    a {
        text-decoration: none;
        color: #007bff; /* Màu xanh dương cho liên kết */
        padding: 5px 10px;
        border: 1px solid #007bff;
        border-radius: 3px;
        display: inline-block;
        transition: background-color 0.3s;
    }
    a:hover {
        background-color: #007bff;
        color: white;
    }
    a[href="gddangkilich.jsp"] { /* Style cho nút Quay lại */
        display: inline-block;
        margin-top: 15px;
        background-color: #ccc;
        color: #333;
        border: 1px solid #999;
    }
    a[href="gddangkilich.jsp"]:hover {
        background-color: #bbb;
        color: #000;
    }
</style>
</head>
<body>
<%
    // 1. LẤY ĐỐI TƯỢNG BÁC SĨ VÀ LOGGING
    BacSi bs = (BacSi)session.getAttribute("bacsi");
    
    if(bs == null){
        response.sendRedirect("dangnhap.jsp?err=timeout");
        return;
    }
    // ... (Phần logic còn lại giữ nguyên)
    
    Integer idTuanlamviecObj = (Integer) session.getAttribute("idTuanlamviec");
    if (idTuanlamviecObj == null) {
        response.sendRedirect("gdDangKiLich.jsp");
        return;
    }
    
    int idTuanlamviec = idTuanlamviecObj.intValue();
    CadangkiDAO caDAO = new CadangkiDAO();
    TuanlamviecDAO tuanDAO = new TuanlamviecDAO();
    
    TuanLamViec tuanHienTai = tuanDAO.getTuanById(idTuanlamviec);
    ArrayList<CaDangKi> listTatCaCa = caDAO.getDSCaTheoTuan2(idTuanlamviec);
    ArrayList<ThongTinDangKiBacSi> listDKBS = 
        (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    if (listDKBS == null) {
        listDKBS = new ArrayList<ThongTinDangKiBacSi>();
    }
    Set<Integer> registeredCaIds = new HashSet<>();
    for (ThongTinDangKiBacSi dk : listDKBS) {
        if (dk.getCaDangKi() != null) {
            registeredCaIds.add(dk.getCaDangKi().getId());
        }
    }
    
    ArrayList<CaDangKi> listCaKhongTrung = new ArrayList<>();
    
    if (listTatCaCa != null) {
        for (CaDangKi caTuan : listTatCaCa) {
            boolean isAlreadyRegistered = registeredCaIds.contains(caTuan.getId());
            
            // LOGIC KIỂM TRA SĨ SỐ: Ca có thể đăng ký nếu chưa được đăng ký và CÒN CHỖ
            // SoNguoiDaDuyet < SoNguoiToiDa
            boolean isFull = (caTuan.getSoNguoiDaDuyet() >= caTuan.getSoNguoiToiDa());
            
            // Chỉ thêm vào danh sách hiển thị nếu thỏa mãn cả hai điều kiện
            if (!isAlreadyRegistered) {
            	listCaKhongTrung.add(caTuan);
            }
        }
    }
    
    String tenTuanHienThi = (tuanHienTai != null && tuanHienTai.getNgayBatDau() != null && tuanHienTai.getNgayKetThuc() != null) 
        ? "(từ " + tuanHienTai.getNgayBatDau() + " – " + tuanHienTai.getNgayKetThuc() + ")"
        : "(Tuần không xác định)";
    
%>
<div>
    <h2>Chọn ca đăng kí</h2>
    
    <p>Tuần làm việc <%= tenTuanHienThi %></p>

    <table border="1">
        <thead>
            <tr>
                <th>Các ca làm việc trong tuần</th>
                <th>Số người tối đa</th>
                <th>Số người đã đăng kí</th>
                <th>Chọn</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (listCaKhongTrung.isEmpty()) { 
            %>
                <tr>
                    <td colspan="4">Không có ca làm việc nào có thể đăng kí trong tuần này.</td>
                </tr>
            <% 
            } else {
                for (CaDangKi ca : listCaKhongTrung) {
                	int soNguoiToiDa = ca.getSoNguoiToiDa(); 
                    int soNguoiDaDuyet = ca.getSoNguoiDaDuyet(); 
                    boolean caDaDay = (soNguoiDaDuyet >= soNguoiToiDa);
            %>
                <tr>
                    <td><%= ca.getNgayLamViec() %> - <%= ca.getCaLamViec() %></td>
                    <td><%= ca.getSoNguoiToiDa() %></td>
                    <td><%= ca.getSoNguoiDaDuyet() %></td>
                    <td>
                        <% if (caDaDay) { %>
                            <span class="disabled-link">Đã đầy</span>
                        <% } else { %>
                            <a href="gddangkilich.jsp?action=them&idCa=<%= ca.getId() %>">Chọn</a>
                        <% } %>
                    </td>
                </tr>
            <% 
                }
            } 
            %>
        </tbody>
    </table>

    <a href="gddangkilich.jsp">Quay lại</a>
</div>
</body>
</html>