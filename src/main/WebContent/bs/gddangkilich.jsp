<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Đăng kí lịch làm việc</title>
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
	} else if (action.equalsIgnoreCase("them")) {
        int idCaDangKi = 0;
        try {
            idCaDangKi = Integer.parseInt(request.getParameter("idCa"));
        } catch(NumberFormatException e) {
        }

        boolean daTontaiCa = false;
        for(ThongTinDangKiBacSi dk : listDKBS){
            if(dk.getCaDangKi() != null && dk.getCaDangKi().getId() == idCaDangKi){
                daTontaiCa = true;
                break;
            }
        }
        
        if(!daTontaiCa && idCaDangKi > 0){   
        	CaDangKi caMoi = caDAO.getCaDangKiByID(idCaDangKi);
            if (caMoi != null) {
                ThongTinDangKiBacSi dkMoi = new ThongTinDangKiBacSi();
                dkMoi.setCaDangKi(caMoi);
                dkMoi.setBacSi(currentBS);
                dkMoi.setNgayTao(new java.sql.Date(System.currentTimeMillis()));
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
    
    String tenChuyenKhoa = "Chưa xác định";
    if (currentBS.getChuyenKhoa() != null) { 
        tenChuyenKhoa = currentBS.getChuyenKhoa().getTenKhoa();
    }
    
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
                    <th>Sửa</th>
                    <th>Xóa</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if (listDKBS.isEmpty()) { 
                %>
                    <tr>
                        <td colspan="5" style="text-align: center;">Chưa có lịch làm việc nào được đăng kí trong tuần này.</td>
                    </tr>
                <% 
                } else {
                    int stt = 1;
                    for (ThongTinDangKiBacSi dk : listDKBS) {
                        String ngayLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getNgayLamViec() : "N/A";
                        String caLamViec = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getCaLamViec() : "N/A";
                        int idCaHienTai = (dk.getCaDangKi() != null) ? dk.getCaDangKi().getId() : 0;
                %>
                    <tr>
                        <td><%= stt++ %></td>
                        <td><%= ngayLamViec %></td>
                        <td><%= caLamViec %></td>
                        <td><a href="#">(click để sửa)</a></td> 
                        <td><a href="gddangkilich.jsp?action=xoa&idCa=<%= idCaHienTai %>">Xóa</a></td>
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
		        <button type="submit">
		            Lưu đăng kí
		        </button>
            </form>
        </div>
    </div>
</body>
</html>