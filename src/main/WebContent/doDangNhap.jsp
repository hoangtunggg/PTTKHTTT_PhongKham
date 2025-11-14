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
        String vaiTro = tv.getVaiTro().toLowerCase();
        if (vaiTro.equals("bacsi")) {
            BacsiDAO bsDao = new BacsiDAO(); 
            BacSi bs = bsDao.getBacSiByThanhVienId(tv.getId());
            if (bs != null) {
            	bs.setId(tv.getId());
                bs.setUsername(tv.getUsername());
                bs.setHoTen(tv.getHoTen());
                session.setAttribute("bacsi", bs); 
                response.sendRedirect("bs\\gdchinhbs.jsp");
            } else {
                 response.sendRedirect("gddangnhap.jsp?err=fail");
            }
            
        } else if (vaiTro.equals("quanly")) {
            session.setAttribute("quanly", tv);
            response.sendRedirect("ql\\gdchinhql.jsp");
            
        } else if (vaiTro.equals("ketoan")) {
            session.setAttribute("ketoan", tv);
            response.sendRedirect("kt\\gdchinhkt.jsp");
            
        } else {
            response.sendRedirect("gddangnhap.jsp?err=fail");
        }
    } else {
        response.sendRedirect("gddangnhap.jsp?err=fail");
    }
%>