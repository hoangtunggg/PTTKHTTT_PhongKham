<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Lịch Làm Việc Dự Kiến</title>
<style>
    /* CSS cơ bản */
    body { font-family: Arial, sans-serif; text-align: center; margin: 20px; }
    .container { width: 90%; margin: 0 auto; padding: 20px; }
    h2 { margin-bottom: 5px; }
    .tuan-info { margin-bottom: 20px; font-weight: bold; }
    table { width: 100%; border-collapse: collapse; margin: 0 auto; }
    th, td { border: 1px solid #000; padding: 10px; text-align: center; }
    th { background-color: #f0f0f0; }
    .button-group { margin-top: 30px; }
    .button-group a, .button-group button { 
        padding: 10px 15px; 
        border: none; 
        cursor: pointer; 
        margin: 5px; 
        text-decoration: none;
        color: white;
    }
    .button-group a { background-color: #dc3545; }
    .button-group button[type="submit"] { background-color: #007bff; }
    .button-group a:nth-child(2) { background-color: #28a745; }
</style>
</head>
<body>
<%
	ThanhVien currentQL = (ThanhVien)session.getAttribute("quanly");
	if(currentQL == null){
	    response.sendRedirect("dangnhap.jsp?err=timeout");
	    return;
	}
	
	BacSi bs = null;
	String maBacsi = null;
	ArrayList<ThongTinDangKiBacSi> listDKBS = null;
	
	ThongtindkibsiDAO ttDKBSDAO = new ThongtindkibsiDAO();
    TuanlamviecDAO tuanDAO = new TuanlamviecDAO();
    CadangkiDAO caDAO = new CadangkiDAO();
    BacsiDAO bsiDAO = new BacsiDAO();
	
    int idTuanlamviec = (int) session.getAttribute("idTuanlamviec"); 
    String maBacsiParam = request.getParameter("maBS");
    BacSi bsSession = (BacSi) session.getAttribute("bacsidangchon");
    
    if(bsSession == null || (maBacsiParam != null && !maBacsiParam.equals(bsSession.getMaBS()))) {
        
        String maBSCanTai = (maBacsiParam != null) ? maBacsiParam : "";
        if (maBSCanTai.isEmpty()) {
            response.sendRedirect("gdlichdukien.jsp?err=missing_params");
            return;
        }

        bs = bsiDAO.getBacSiByMaBS(maBSCanTai); 
        if(bs != null) {
            session.setAttribute("bacsidangchon", bs);
        } else {
            response.sendRedirect("gdlichdukien.jsp?err=bs_not_found");
            return;
        }
    } else {
        bs = bsSession;
    }
    maBacsi = bs.getMaBS(); 
    
    if (maBacsi == null || idTuanlamviec == 0) {
        response.sendRedirect("gdlichdukien.jsp?err=missing_params");
        return;
    }
    
    String action = request.getParameter("action");
    
    listDKBS = (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    if (listDKBS == null || (action == null && !listDKBS.isEmpty() && !listDKBS.get(0).getBacSi().getMaBS().equals(maBacsi))) {
        listDKBS = new ArrayList<ThongTinDangKiBacSi>();
    }

    TuanLamViec tuanHienTai = tuanDAO.getTuanById(idTuanlamviec);
    String ngayBatDau = tuanHienTai.getNgayBatDau().toString();
    String ngayKetThuc = tuanHienTai.getNgayKetThuc().toString();
    
    if ((action == null)||(action.trim().length() ==0)) {       
        if (idTuanlamviec > 0 && listDKBS.isEmpty()) { 
            listDKBS = ttDKBSDAO.getDKiCuaBS(maBacsi, idTuanlamviec); 
            if (listDKBS == null) { listDKBS = new ArrayList<ThongTinDangKiBacSi>(); }
        } 
        
	} else if (action.equalsIgnoreCase("sua")) { 
	    String idCaEditParam = request.getParameter("idCa");
        if (idCaEditParam != null) { session.setAttribute("idCaCuDangSua", Integer.parseInt(idCaEditParam)); }
        response.sendRedirect("gdlenlichcadangki.jsp?maBS=" + maBacsi);
        return; 
        
	} else if (action.equalsIgnoreCase("them")) {
        int idCaDangKi = 0;
        try { idCaDangKi = Integer.parseInt(request.getParameter("idCa")); } catch(NumberFormatException e) { }
        Integer idCaCuObj = (Integer) session.getAttribute("idCaCuDangSua");
        
        if (idCaCuObj != null) {
            int idCaCu = idCaCuObj.intValue();
            Iterator<ThongTinDangKiBacSi> iterator = listDKBS.iterator();
            while (iterator.hasNext()) {
                ThongTinDangKiBacSi dk = iterator.next();
                if (dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaCu) {
                    iterator.remove(); break;
                }
            }
            session.removeAttribute("idCaCuDangSua");
        } 

        if(idCaDangKi > 0){   
        	CaDangKi caMoi = caDAO.getCaDangKiByID(idCaDangKi);
            if (caMoi != null) {
                ThongTinDangKiBacSi dkMoi = new ThongTinDangKiBacSi();
                dkMoi.setCaDangKi(caMoi);
                dkMoi.setBacSi(bs);
                dkMoi.setNgayTao(new java.sql.Date(System.currentTimeMillis()));
                dkMoi.setTrangThai("CHO_DUYET");
                listDKBS.add(dkMoi);
            }
        }
        
	} else if (action.equalsIgnoreCase("xoa")) {
        int idCaDangKiCanXoa = 0;
        try { idCaDangKiCanXoa = Integer.parseInt(request.getParameter("idCa")); } catch(NumberFormatException e) { }
        
        if (idCaDangKiCanXoa > 0) {
            Iterator<ThongTinDangKiBacSi> iterator = listDKBS.iterator();
            while (iterator.hasNext()) {
                ThongTinDangKiBacSi dk = iterator.next();
                if (dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaDangKiCanXoa) {
                    iterator.remove(); break;
                }
            }
        }
	}
    
	session.setAttribute("listDangKyBacSi", listDKBS);
%>

<div class="container">
    <h2>Lịch làm việc của BS: <%= bs.getHoTen() %></h2>
    
    <p class="tuan-info">Tuần làm việc (từ <%= ngayBatDau %> – <%= ngayKetThuc %>)</p>

    <table>
        <thead>
            <tr>
                <th>STT</th>
                <th>Ngày làm việc</th>
                <th>Ca làm việc</th>
                <th>Sửa</th>
                <th>Xóa</th>
                <th>Ghi chú</th> 
                <th>Trạng thái</th>
                <th>Chọn</th>
            </tr>
        </thead>
        <tbody>
            <% 
                if (listDKBS.isEmpty()) { 
                %>
                    <tr>
                        <td colspan="8" style="text-align: center;">Chưa có lịch đăng ký nào của bác sĩ này trong tuần.</td>
                    </tr>
                <% 
                } else {
                    int stt = 1;
                    for (ThongTinDangKiBacSi dk : listDKBS) {
                        String ngayLamViec = dk.getCaDangKi().getNgayLamViec();
                        String caLamViec = dk.getCaDangKi().getCaLamViec();
                        int idCaHienTai = dk.getCaDangKi().getId();
                        
                        String ghiChu = "-";
                        String trangThai = dk.getTrangThai();
                %>
                    <tr>
                        <td><%= stt++ %></td>
                        <td><%= ngayLamViec %></td>
                        <td><%= caLamViec %></td>
                        <td><a href="gdlichdukien.jsp?action=sua&idCa=<%= idCaHienTai %>">Sửa</a></td> 
                        <td><a href="gdlichdukien.jsp?action=xoa&idCa=<%= idCaHienTai %>">Xóa</a></td>
                        <td><%= ghiChu %></td>
                        <td><%= trangThai %></td>
                        <td><a href="gdthongtinlich.jsp?maBS=<%= maBacsi %>&idCa=<%= idCaHienTai %>">Chọn</a></td>
                    </tr>
                <% 
                    }
                } 
                %>
        </tbody>
    </table>

    <div class="button-group">
    
    <a href="gdchinhql.jsp">Về trang chủ</a>
    
    <a href="gdlenlichcadangki.jsp?maBS=<%= maBacsi %>">Thêm lịch làm việc</a>
    
    <form action="doluulich.jsp" method="post" style="display: inline;">
        <button type="submit">
            Lưu lịch
        </button>
    </form>
</div>
</div>
</body>
</html>