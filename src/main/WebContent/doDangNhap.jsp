<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.ArrayList,dao.*,model.*"%>
<%
	String username = (String) request.getParameter("username");
	String password = (String) request.getParameter("password");
	
	ThanhVien tv = new ThanhVien();
	tv.setUsername(username);
	tv.setPassword(password);
	
	ThanhvienDAO tvDao = new ThanhvienDAO();
	boolean kq = tvDao.KtraDN(tv); 

    if (kq) {
        // --- BỔ SUNG: HỦY SESSION CŨ TRƯỚC KHI TIẾP TỤC ---
        if (session != null) {
            session.invalidate(); 
            // Tạo đối tượng session mới cho người dùng hiện tại
            session = request.getSession(true); 
        }
        // ----------------------------------------------------
        
        String vaiTro = tv.getVaiTro().toLowerCase();
        
        if (vaiTro.equals("bacsi")) {
            BacsiDAO bsDao = new BacsiDAO(); 
            BacSi bs = bsDao.getBacSiByThanhVienId(tv.getId());
            
            if (bs != null) {
            	// Ánh xạ các thuộc tính chung từ ThanhVien
            	bs.setId(tv.getId());
                bs.setUsername(tv.getUsername());
                bs.setHoTen(tv.getHoTen());
                
                // Lưu đối tượng BacSi vào Session mới
                session.setAttribute("bacsi", bs); 
                response.sendRedirect("bs\\gdchinhbs.jsp");
            } else {
                 response.sendRedirect("gddangnhap.jsp?err=fail"); // Không tìm thấy chi tiết BS
            }
            
        } else if (vaiTro.equals("quanly")) {
            session.setAttribute("quanly", tv);
            response.sendRedirect("ql\\gdchinhql.jsp");
            
        } else if (vaiTro.equals("ketoan")) {
            session.setAttribute("ketoan", tv);
            response.sendRedirect("kt\\gdchinhkt.jsp");
            
        } else {
            response.sendRedirect("gddangnhap.jsp?err=fail"); // Vai trò không xác định
        }
    } else {
        response.sendRedirect("gddangnhap.jsp?err=fail"); // Đăng nhập thất bại
    }
%>