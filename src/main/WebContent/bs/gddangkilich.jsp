<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Đăng kí lịch làm việc</title>
<style>
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
    .disabled-link { color: gray; pointer-events: none; text-decoration: none; cursor: default; }
</style>
</head>
<body>
    
	<%
	BacSi currentBS = (BacSi)session.getAttribute("bacsi");
	if(currentBS == null){
	    response.sendRedirect("dangnhap.jsp?err=timeout");
	    return;
	}

	ArrayList<ThongTinDangKiBacSi> listDKBS = null;
    int idTuanlamviec = 0;
    String maBacsi = currentBS.getMaBS();

	ThongtindkibsiDAO ttDKBSDAO = new ThongtindkibsiDAO();
	TuanlamviecDAO tuanDao = new TuanlamviecDAO();
	CadangkiDAO caDAO = new CadangkiDAO();
	
	String action = request.getParameter("action");
    
    listDKBS = (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    if (listDKBS == null) {
        listDKBS = new ArrayList<ThongTinDangKiBacSi>();
    }
    
	if ((action == null)||(action.trim().length() ==0)) { 
        if (session.getAttribute("idTuanlamviec") != null) {
            idTuanlamviec = (int)session.getAttribute("idTuanlamviec");
        } else {
            idTuanlamviec = tuanDao.getTuanhtai(); 
        }

        session.setAttribute("idTuanlamviec", idTuanlamviec);
        
        if (idTuanlamviec > 0 && listDKBS.isEmpty()) { 
            listDKBS = ttDKBSDAO.getDKiCuaBS(maBacsi, idTuanlamviec); 
            if (listDKBS == null) {
                listDKBS = new ArrayList<ThongTinDangKiBacSi>();
            }
        } 
        
	} else if (action.equalsIgnoreCase("sua")) { 
	    String idCaEdit = request.getParameter("idCa");
        if (idCaEdit != null) {
            session.setAttribute("idCaCuDangSua", Integer.parseInt(idCaEdit)); 
        }
        response.sendRedirect("gdchoncadangki.jsp");
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
                    iterator.remove(); 
                    break;
                }
            }
            session.removeAttribute("idCaCuDangSua");
        } 
        
        if(idCaDangKi > 0){   
        	CaDangKi caMoi = caDAO.getCaDangKiByID(idCaDangKi);
            if (caMoi != null) {
                ThongTinDangKiBacSi dkMoi = new ThongTinDangKiBacSi();
                dkMoi.setCaDangKi(caMoi);
                dkMoi.setBacSi(currentBS);
                dkMoi.setNgayTao(new java.sql.Date(System.currentTimeMillis()));
                dkMoi.setTrangThai("CHO_DUYET");
                listDKBS.add(dkMoi);
            }
        }
        
	} else if (action.equalsIgnoreCase("xoa")) {
        int idCaDangKiCanXoa = 0;
        try {
            idCaDangKiCanXoa = Integer.parseInt(request.getParameter("idCa"));
        } catch(NumberFormatException e) {
        }
        
        if (idCaDangKiCanXoa > 0) {
            Iterator<ThongTinDangKiBacSi> iterator = listDKBS.iterator();
            while (iterator.hasNext()) {
                ThongTinDangKiBacSi dk = iterator.next();
                if (dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaDangKiCanXoa) {
                    iterator.remove();
                    break;
                }
            }
        }
	}
    
	session.setAttribute("listDangKyBacSi", listDKBS);
	
	int totalCaTrongTuan = listDKBS.size();
    String tenBacSi = currentBS.getHoTen(); 
    String tenChuyenKhoa = currentBS.getChuyenKhoa().getTenKhoa();
    
    TuanLamViec tuanHienTai = tuanDao.getTuanById((Integer) session.getAttribute("idTuanlamviec"));
    String ngayBatDau = tuanHienTai.getNgayBatDau().toString();
    String ngayKetThuc = tuanHienTai.getNgayKetThuc().toString();
	
    boolean allApproved = listDKBS.stream().allMatch(dk -> "DA_DUYET".equalsIgnoreCase(dk.getTrangThai()));
    
	%>

    <div class="container">
        <h2>Đăng kí lịch</h2>

        <div class="info">
            <p><strong>Họ tên:</strong> <%= tenBacSi %></p>
            <p><strong>Chuyên khoa:</strong> <%= tenChuyenKhoa %></p>
            <p><strong>Tổng số ca trong tuần:</strong> <%= totalCaTrongTuan %></p>
        </div>

        <h3>Các lịch đã đăng kí:</h3>
        <table border="1">
            <thead>
                <tr>
                    <th>STT</th>
                    <th>Ngày làm việc</th>
                    <th>Ca làm việc</th>
                    <th>Trạng thái</th> 
                    <th>Sửa</th>
                    <th>Xóa</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if (listDKBS.isEmpty()) { 
                %>
                    <tr>
                        <td colspan="6" style="text-align: center;">Chưa có lịch làm việc nào được đăng kí trong tuần này.</td>
                    </tr>
                <% 
                } else {
                    int stt = 1;
                    for (ThongTinDangKiBacSi dk : listDKBS) {
                        String ngayLamViec = dk.getCaDangKi().getNgayLamViec();
                        String caLamViec = dk.getCaDangKi().getCaLamViec();
                        int idCaHienTai = dk.getCaDangKi().getId();
                        
                        String trangThai = (dk.getTrangThai() != null) ? dk.getTrangThai() : "CHUA_DUYET";
                        boolean isApproved = "DA_DUYET".equalsIgnoreCase(trangThai);
                        
                        String linkSuaHtml = isApproved 
                                ? "<span class='disabled-link'>Sửa</span>"
                                : "<a href=\"gddangkilich.jsp?action=sua&idCa=" + idCaHienTai + "\">Sửa</a>";
                                
                        String linkXoaHtml = isApproved 
                                ? "<span class='disabled-link'>Xóa</span>"
                                : "<a href=\"gddangkilich.jsp?action=xoa&idCa=" + idCaHienTai + "\">Xóa</a>";
                %>
                    <tr>
                        <td><%= stt++ %></td>
                        <td><%= ngayLamViec %></td>
                        <td><%= caLamViec %></td>
                        <td><%= trangThai %></td>
                        <td><%= linkSuaHtml %></td> 
                        <td><%= linkXoaHtml %></td>
                    </tr>
                <% 
                    }
                } 
                %>
            </tbody>
        </table>

        <div class="button-group">
    
		    <a href="gdchinhbs.jsp">Về trang chủ</a> 
		    <a href="gdchoncadangki.jsp">Thêm lịch</a> 
		
		    <form action="doluudki.jsp" method="post" style="display: inline;">
		        <button type="submit" <%= listDKBS.isEmpty() || allApproved ? "disabled" : "" %>>
		            Lưu đăng kí
		        </button>
            </form>
        </div>
    </div>
</body>
</html>