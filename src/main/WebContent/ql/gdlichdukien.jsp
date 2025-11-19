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
	
	BacSi bs = null;
	String maBacsi = null;
	ArrayList<ThongTinDangKiBacSi> listDKBS = null;
	
	ThongtindkibsiDAO ttDKBSDAO = new ThongtindkibsiDAO();
    TuanlamviecDAO tuanDAO = new TuanlamviecDAO();
    CadangkiDAO caDAO = new CadangkiDAO();
    BacsiDAO bsiDAO = new BacsiDAO();
	
    // --- LOGIC XÁC ĐỊNH BÁC SĨ ĐANG ĐƯỢC CHỌN ---
    if(session.getAttribute("bacsidangchon") == null){
		maBacsi = request.getParameter("maBS");
		if (maBacsi != null && !maBacsi.trim().isEmpty()) {
	    	bs = bsiDAO.getBacSiByMaBS(maBacsi); // TẢI ĐỐI TƯỢNG BS TỪ DB
	    	if(bs != null) {
	    		session.setAttribute("bacsidangchon", bs); // LƯU VÀO SESSION
	    	} else {
	    		response.sendRedirect("gdlichdukien.jsp?err=bs_not_found");
	    		return;
	    	}
		} else {
			response.sendRedirect("gdlichdukien.jsp?err=missing_params");
			return;
		}
	} else {
		// Tải từ Session (các lần truy cập sau)
		bs = (BacSi) session.getAttribute("bacsidangchon");
		maBacsi = bs.getMaBS(); 
	}
   	
    int idTuanlamviec = (int) session.getAttribute("idTuanlamviec");
    TuanLamViec tuanHienTai = tuanDAO.getTuanById(idTuanlamviec);
    
    if (maBacsi == null || idTuanlamviec == 0) {
        response.sendRedirect("gdlichdukien.jsp?err=missing_params");
        return;
    }
    
    String action = request.getParameter("action");
    
    listDKBS = (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    if (listDKBS == null) {
        listDKBS = new ArrayList<ThongTinDangKiBacSi>();
    }
    
    // Lấy thông tin hiển thị tuần
    String ngayBatDau = (tuanHienTai != null && tuanHienTai.getNgayBatDau() != null) ? tuanHienTai.getNgayBatDau().toString() : "N/A";
    String ngayKetThuc = (tuanHienTai != null && tuanHienTai.getNgayKetThuc() != null) ? tuanHienTai.getNgayKetThuc().toString() : "N/A";
    
    if ((action == null)||(action.trim().length() ==0)) {       
        // Tải từ DB chỉ khi Session chưa có dữ liệu tạm
        if (idTuanlamviec > 0 && listDKBS.isEmpty()) { 
            listDKBS = ttDKBSDAO.getDKiCuaBS(maBacsi, idTuanlamviec); 
            if (listDKBS == null) {
                listDKBS = new ArrayList<ThongTinDangKiBacSi>();
            }
        } 
        
	} else if (action.equalsIgnoreCase("set_edit_mode")) { 
	    // LOGIC CHUYỂN SANG CHẾ ĐỘ SỬA
	    
	    String idCaEditParam = request.getParameter("idCa");
        if (idCaEditParam != null) {
            // Lưu ID ca cũ vào Session
            session.setAttribute("idCaCuDangSua", Integer.parseInt(idCaEditParam)); 
        }
        // Chuyển hướng đến trang chọn ca mới
        response.sendRedirect("gdlenlichcadangki.jsp");
        return; 
        
	} else if (action.equalsIgnoreCase("them")) {
        // LOGIC THÊM VÀ SỬA (THAY THẾ)
        
        int idCaDangKi = 0;
        try { idCaDangKi = Integer.parseInt(request.getParameter("idCa")); } catch(NumberFormatException e) { }

        boolean daTontaiCa = false;
        Integer idCaCuObj = (Integer) session.getAttribute("idCaCuDangSua");
        
        if (idCaCuObj != null) {
            // Đang ở chế độ SỬA: XÓA ca cũ khỏi danh sách
            int idCaCu = idCaCuObj.intValue();
            Iterator<ThongTinDangKiBacSi> iterator = listDKBS.iterator();
            while (iterator.hasNext()) {
                ThongTinDangKiBacSi dk = iterator.next();
                if (dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaCu) {
                    iterator.remove(); // Xóa ca cũ
                    break;
                }
            }
            // Tắt chế độ SỬA
            session.removeAttribute("idCaCuDangSua");
            
        } else {
            // Đang ở chế độ THÊM BÌNH THƯỜNG: Kiểm tra trùng lặp
            for(ThongTinDangKiBacSi dk : listDKBS){
                if(dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaDangKi){
                    daTontaiCa = true;
                    break;
                }
            }
        }
        
        // 2. THÊM CA MỚI (Chỉ thêm nếu không trùng hoặc đã xóa ca cũ)
        if(!daTontaiCa && idCaDangKi > 0){   
        	CaDangKi caMoi = caDAO.getCaDangKiByID(idCaDangKi);
            if (caMoi != null) {
                ThongTinDangKiBacSi dkMoi = new ThongTinDangKiBacSi();
                dkMoi.setCaDangKi(caMoi);
                dkMoi.setBacSi(bs);
                dkMoi.setNgayTao(new java.sql.Date(System.currentTimeMillis()));
                listDKBS.add(dkMoi);
            }
        }
        
	} else if (action.equalsIgnoreCase("xoa")) {
        // LOGIC XÓA (Giữ nguyên)
        int idCaDangKiCanXoa = 0;
        try { idCaDangKiCanXoa = Integer.parseInt(request.getParameter("idCa")); } catch(NumberFormatException e) { }
        
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
    
	// 3. LƯU LẠI DANH SÁCH CUỐI CÙNG VÀO SESSION
	session.setAttribute("listDangKyBacSi", listDKBS);
%>

<div class="container">
    <h2>Lịch làm việc</h2>
    
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
                <th>Chọn</th> </tr>
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
                        String ngayLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getNgayLamViec() : "N/A";
                        String caLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getCaLamViec() : "N/A";
                        int idCaHienTai = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getId() : 0;
                        
                        // Giá trị giả định cho Ghi chú và Trạng thái
                        String ghiChu = "-";
                        String trangThai = "Chưa duyệt";
                %>
                    <tr>
                        <td><%= stt++ %></td>
                        <td><%= ngayLamViec %></td>
                        <td><%= caLamViec %></td>
                        <td><a href="gdlichdukien.jsp?action=set_edit_mode&idCa=<%= idCaHienTai %>">Sửa</a></td> 
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
        <button onclick="history.back()">Quay lại</button>
        <a href="gdlenlichcadangki.jsp?maBS=<%= maBacsi %>">Thêm lịch làm việc</a>
        <button>Lưu lịch</button>
    </div>
</div>
</body>
</html>