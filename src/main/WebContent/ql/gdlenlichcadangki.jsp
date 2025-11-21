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
        text-align: center;
        padding: 20px;
    }
    div {
        max-width: 800px;
        margin: 0 auto;
        padding: 10px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 15px 0;
    }
    th, td {
        border: 1px solid #000;
        padding: 8px;
        text-align: center;
    }
    th {
        background-color: #e0e0e0;
    }
    a {
        text-decoration: none;
        color: #007bff;
        padding: 5px 10px;
        border: 1px solid #007bff;
        border-radius: 3px;
        display: inline-block;
    }
    a:hover {
        background-color: #007bff;
        color: white;
    }
</style>
</head>
<body>
<%
    ThanhVien currentQL = (ThanhVien)session.getAttribute("quanly");
    if(currentQL == null){
        response.sendRedirect("dangnhap.jsp?err=timeout"); 
        return;
    }
    
    BacSi bsDangChon = (BacSi) session.getAttribute("bacsidangchon");
    String maBacsi = bsDangChon.getMaBS();
    
    Integer idTuanlamviecObj = (Integer) session.getAttribute("idTuanlamviec"); 
    int idTuanlamviec = idTuanlamviecObj.intValue();

    CadangkiDAO caDAO = new CadangkiDAO();
    TuanlamviecDAO tuanDAO = new TuanlamviecDAO();
    
    TuanLamViec tuanHienTai = tuanDAO.getTuanById(idTuanlamviec);
    ArrayList<CaDangKi> listTatCaCa = caDAO.getDSCaTheoTuan(idTuanlamviec);
    
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
                if (!registeredCaIds.contains(caTuan.getId())) {
                    listCaKhongTrung.add(caTuan);
                }
            }
        }
    
    String tenTuanHienThi = (tuanHienTai != null && tuanHienTai.getNgayBatDau() != null && tuanHienTai.getNgayKetThuc() != null) 
        ? "(từ " + tuanHienTai.getNgayBatDau() + " – " + tuanHienTai.getNgayKetThuc() + ")"
        : "(Tuần không xác định)";
    
%>
<div>
    <h2>Chọn ca đăng kí cho BS: <%= bsDangChon.getHoTen() %></h2>
    
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
                    int soNguoiToiDa = 5; 
                    int soNguoiDaDangKi = 1; 
            %>
                <tr>
                    <td><%= ca.getNgayLamViec() %> - <%= ca.getCaLamViec() %></td>
                    <td><%= soNguoiToiDa %></td>
                    <td><%= soNguoiDaDangKi %></td>
                    <td>
                        <a href="gdlichdukien.jsp?action=them&idCa=<%= ca.getId() %>&maBS=<%= maBacsi %>">Chọn</a>
                    </td>
                </tr>
            <% 
                }
            } 
            %>
        </tbody>
    </table>

    <a href="gdlichdukien.jsp">Quay lại</a>
</div>
</body>
</html>