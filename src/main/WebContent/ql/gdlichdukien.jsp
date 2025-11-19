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
	// 1. KIỂM TRA ĐĂNG NHẬP VÀ KHAI BÁO CẦN THIẾT
	ThanhVien currentQL = (ThanhVien)session.getAttribute("quanly");
	if(currentQL == null){
	    response.sendRedirect("dangnhap.jsp?err=timeout");
	    return;
	}
	
	BacSi bs = null;
	String maBacsi = null;
	ArrayList<ThongTinDangKiBacSi> listDKBS = null;
	
	// Khai báo DAO
	ThongtindkibsiDAO ttDKBSDAO = new ThongtindkibsiDAO();
    TuanlamviecDAO tuanDAO = new TuanlamviecDAO();
    CadangkiDAO caDAO = new CadangkiDAO();
    BacsiDAO bsiDAO = new BacsiDAO();
	
    // Lấy ID Tuần từ Session (Giả định đã được lưu trước đó)
    int idTuanlamviec = (int) session.getAttribute("idTuanlamviec"); 
    
    // Lấy Tham số maBS mới từ URL
    String maBacsiParam = request.getParameter("maBS"); 
    
    // --- LOGIC XÁC ĐỊNH BÁC SĨ ĐANG ĐƯỢC CHỌN VÀ TẢI LẠI TỪ DB NẾU THAY ĐỔI ---
    BacSi bsSession = (BacSi) session.getAttribute("bacsidangchon");
    
    // ĐIỀU KIỆN TẢI LẠI BS: 
    // 1. Session chưa có BS HOẶC 
    // 2. Có tham số maBS mới và nó KHÔNG khớp với maBS đang có trong Session.
    if(bsSession == null || (maBacsiParam != null && !maBacsiParam.equals(bsSession.getMaBS()))) {
        
        String maBSCanTai = (maBacsiParam != null) ? maBacsiParam : "";
        if (maBSCanTai.isEmpty()) {
            response.sendRedirect("gdlichdukien.jsp?err=missing_params");
            return;
        }

        bs = bsiDAO.getBacSiByMaBS(maBSCanTai); // TẢI ĐỐI TƯỢNG BS MỚI
        if(bs != null) {
            session.setAttribute("bacsidangchon", bs); // LƯU BS MỚI VÀO SESSION
        } else {
            response.sendRedirect("gdlichdukien.jsp?err=bs_not_found");
            return;
        }
    } else {
        // Sử dụng đối tượng BS đã có sẵn trong Session
        bs = bsSession;
    }
    maBacsi = bs.getMaBS(); 
   	// ---------------------------------------------
    
    // Kiểm tra tính hợp lệ của tham số
    if (maBacsi == null || idTuanlamviec == 0) {
        response.sendRedirect("gdlichdukien.jsp?err=missing_params");
        return;
    }
    
    String action = request.getParameter("action");
    
    // Tải danh sách đăng ký từ Session hoặc khởi tạo mới
    listDKBS = (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    if (listDKBS == null || (action == null && !listDKBS.isEmpty() && !listDKBS.get(0).getBacSi().getMaBS().equals(maBacsi))) {
        // Nếu listDKBS rỗng HOẶC list đó thuộc về BS khác, khởi tạo rỗng để tải lại
        listDKBS = new ArrayList<ThongTinDangKiBacSi>();
    }

    // Lấy thông tin hiển thị tuần và xử lý Action
    TuanLamViec tuanHienTai = tuanDAO.getTuanById(idTuanlamviec);
    
    // Lấy thông tin hiển thị tuần
    String ngayBatDau = (tuanHienTai != null && tuanHienTai.getNgayBatDau() != null) ? tuanHienTai.getNgayBatDau().toString() : "N/A";
    String ngayKetThuc = (tuanHienTai != null && tuanHienTai.getNgayKetThuc() != null) ? tuanHienTai.getNgayKetThuc().toString() : "N/A";
    
    if ((action == null)||(action.trim().length() ==0)) {       
        // Tải từ DB chỉ khi Session chưa có dữ liệu tạm
        if (idTuanlamviec > 0 && listDKBS.isEmpty()) { 
            listDKBS = ttDKBSDAO.getDKiCuaBS(maBacsi, idTuanlamviec); 
            if (listDKBS == null) { listDKBS = new ArrayList<ThongTinDangKiBacSi>(); }
        } 
        
	} else if (action.equalsIgnoreCase("set_edit_mode")) { 
	    // LOGIC CHUYỂN SANG CHẾ ĐỘ SỬA
	    String idCaEditParam = request.getParameter("idCa");
        if (idCaEditParam != null) { session.setAttribute("idCaCuDangSua", Integer.parseInt(idCaEditParam)); }
        response.sendRedirect("gdlenlichcadangki.jsp?maBS=" + maBacsi); // Gửi maBS qua URL
        return; 
        
	} else if (action.equalsIgnoreCase("them")) {
        // LOGIC THÊM VÀ SỬA (THAY THẾ)
        int idCaDangKi = 0;
        try { idCaDangKi = Integer.parseInt(request.getParameter("idCa")); } catch(NumberFormatException e) { }
        boolean daTontaiCa = false;
        Integer idCaCuObj = (Integer) session.getAttribute("idCaCuDangSua");
        
        if (idCaCuObj != null) {
            // Đang ở chế độ SỬA: XÓA ca cũ
            int idCaCu = idCaCuObj.intValue();
            Iterator<ThongTinDangKiBacSi> iterator = listDKBS.iterator();
            while (iterator.hasNext()) {
                ThongTinDangKiBacSi dk = iterator.next();
                if (dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaCu) {
                    iterator.remove(); break;
                }
            }
            session.removeAttribute("idCaCuDangSua");
        } else {
            // Đang ở chế độ THÊM BÌNH THƯỜNG: Kiểm tra trùng lặp
            for(ThongTinDangKiBacSi dk : listDKBS){
                if(dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaDangKi){
                    daTontaiCa = true; break;
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
                dkMoi.setTrangThai("CHO_DUYET");
                listDKBS.add(dkMoi);
            }
        }
        
	} else if (action.equalsIgnoreCase("xoa")) {
        // LOGIC XÓA
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
    
	// 3. LƯU LẠI DANH SÁCH CUỐI CÙNG VÀO SESSION
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
                        String ngayLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getNgayLamViec() : "N/A";
                        String caLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getCaLamViec() : "N/A";
                        int idCaHienTai = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getId() : 0;
                        
                        String ghiChu = "-";
                        String trangThai = (dk.getTrangThai() != null) ? dk.getTrangThai() : "Chưa xác định";
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
    
    <%-- Nút Quay lại --%>
    <button onclick="history.back()">Quay lại</button>
    
    <%-- Nút Thêm lịch (Liên kết) --%>
    <a href="gdlenlichcadangki.jsp?maBS=<%= maBacsi %>">Thêm lịch làm việc</a>
    
    <%-- FORM XỬ LÝ LƯU LỊCH CHÍNH THỨC --%>
    <form action="doluulich.jsp" method="post" style="display: inline;">
        
        <%-- LƯU Ý QUAN TRỌNG: 
             Để logic xử lý chính xác, bạn có thể cần truyền thêm maBacsi 
             hoặc các ID cần thiết nếu logic doluulich.jsp cần chúng. 
             Hiện tại, chúng ta dựa vào Session, nên chỉ cần nút submit. 
        --%>
        <button type="submit">
            Lưu lịch
        </button>
    </form>
</div>
</div>
</body>
</html>