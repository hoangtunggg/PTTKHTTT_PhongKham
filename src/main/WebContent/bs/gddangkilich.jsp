<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Đăng kí lịch làm việc</title>
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
    /* STYLE ĐỂ KHÓA CHỨC NĂNG */
    .disabled-link { color: gray; pointer-events: none; text-decoration: none; cursor: default; }
</style>
</head>
<body>
    
	<%
	// 1. KIỂM TRA ĐĂNG NHẬP (Bác sĩ)
	BacSi currentBS = (BacSi)session.getAttribute("bacsi");
	if(currentBS == null){
	    response.sendRedirect("dangnhap.jsp?err=timeout");
	    return;
	}

	ArrayList<ThongTinDangKiBacSi> listDKBS = null;
    int idTuanlamviec = 0;
    String maBacsi = currentBS.getMaBS();

	// Khai báo DAO
	ThongtindkibsiDAO ttDKBSDAO = new ThongtindkibsiDAO();
	TuanlamviecDAO tuanDao = new TuanlamviecDAO();
	CadangkiDAO caDAO = new CadangkiDAO();
	
	String action = request.getParameter("action");
    
    // Tải danh sách đăng ký từ Session hoặc khởi tạo mới
    listDKBS = (ArrayList<ThongTinDangKiBacSi>)session.getAttribute("listDangKyBacSi");
    if (listDKBS == null) {
        listDKBS = new ArrayList<ThongTinDangKiBacSi>();
    }
    
    // =========================================================================
	if ((action == null)||(action.trim().length() ==0)) { 
	    // LOGIC TẢI LẦN ĐẦU
        if (session.getAttribute("idTuanlamviec") != null) {
            idTuanlamviec = (int)session.getAttribute("idTuanlamviec");
        } else {
            idTuanlamviec = tuanDao.getTuanhtai(); 
        }

        session.setAttribute("idTuanlamviec", idTuanlamviec);
        
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
            session.setAttribute("idCaCuDangSua", Integer.parseInt(idCaEditParam)); 
        }
        response.sendRedirect("gdchoncadangki.jsp");
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
                    iterator.remove(); 
                    break;
                }
            }
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
                dkMoi.setBacSi(currentBS);
                dkMoi.setNgayTao(new java.sql.Date(System.currentTimeMillis()));
                dkMoi.setTrangThai("CHO_DUYET"); // Mặc định trạng thái mới là CHO_DUYET
                listDKBS.add(dkMoi);
            }
        }
        
	} else if (action.equalsIgnoreCase("xoa")) {
        // LOGIC XÓA
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
    
	// 3. LƯU LẠI DANH SÁCH CUỐI CÙNG VÀO SESSION
	session.setAttribute("listDangKyBacSi", listDKBS);
	
	// Khai báo biến hiển thị
	int totalCaTrongTuan = listDKBS.size();
    String tenBacSi = currentBS.getHoTen(); 
    String tenChuyenKhoa = (currentBS.getChuyenKhoa() != null) ? currentBS.getChuyenKhoa().getTenKhoa() : "Chưa xác định";
    
    // Tải chi tiết Tuần cho phần hiển thị
    TuanLamViec tuanHienTai = tuanDao.getTuanById((Integer) session.getAttribute("idTuanlamviec"));
    String ngayBatDau = (tuanHienTai != null && tuanHienTai.getNgayBatDau() != null) ? tuanHienTai.getNgayBatDau().toString() : "N/A";
    String ngayKetThuc = (tuanHienTai != null && tuanHienTai.getNgayKetThuc() != null) ? tuanHienTai.getNgayKetThuc().toString() : "N/A";
	
    // KIỂM TRA TOÀN BỘ LIST ĐÃ DUYỆT CHƯA (Dùng cho nút Lưu)
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
                        String ngayLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getNgayLamViec() : "N/A";
                        String caLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getCaLamViec() : "N/A";
                        int idCaHienTai = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getId() : 0;
                        
                        // LẤY TRẠNG THÁI VÀ XỬ LÝ KHÓA CHỨC NĂNG
                        String trangThai = (dk.getTrangThai() != null) ? dk.getTrangThai() : "CHUA_DUYỆT";
                        boolean isApproved = "DA_DUYET".equalsIgnoreCase(trangThai);
                        
                        // TÍNH TOÁN LINK VÀ CHUỖI BỊ KHÓA
                        String linkSuaHtml = isApproved 
                                ? "<span class='disabled-link'>Sửa</span>"
                                : "<a href=\"gddangkilich.jsp?action=set_edit_mode&idCa=" + idCaHienTai + "\">Sửa</a>";
                                
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