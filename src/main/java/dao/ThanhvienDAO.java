package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;

import model.ThanhVien;

public class ThanhvienDAO extends DAO{
	public ThanhvienDAO() {
		super();
	}
	
	public boolean KtraDN(ThanhVien tv) {
		boolean ketQua = false;
		if(tv.getUsername().contains("true") || tv.getUsername().contains("=") 
				|| tv.getPassword().contains("true") || tv.getPassword().contains("=")) {
			return false;
		}
		String sql = "{call KtraDN (?, ?)}";
		try {
			CallableStatement cs = con.prepareCall(sql);
			cs.setString(1, tv.getUsername());
			cs.setString(2, tv.getPassword());
			ResultSet rs = cs.executeQuery();
			
			if(rs.next()) {
				tv.setId(rs.getInt("id"));
				tv.setVaiTro(rs.getString("vaitro"));
				tv.setHoTen(rs.getString("hoten"));
				ketQua = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
			ketQua = false;
		}
		return ketQua;
	}
	
}
