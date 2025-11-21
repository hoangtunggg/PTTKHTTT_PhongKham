package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Iterator;

import model.BacSi;
import model.ChuyenKhoa;
import model.ThongTinDangKiBacSi;

public class ThongtinlichchinhthucDAO extends DAO {

    public ThongtinlichchinhthucDAO() {
        super();
    }

	public ArrayList<BacSi> getDSBacSiDaDuyet(int idCa) {
	    ArrayList<BacSi> listBacSi = new ArrayList<>();
	    String sql = "{call LayDSBacSiDaDuyetTheoCa(?)}"; 

	    try (CallableStatement cs = con.prepareCall(sql)) {
	        cs.setInt(1, idCa);
	        
	        try (ResultSet rs = cs.executeQuery()) {
	            while (rs.next()) {
	                BacSi bs = new BacSi();
	                
	                bs.setHoTen(rs.getString("HoTenBacSi")); 
	                bs.setSdt(rs.getString("sdt"));
	                bs.setMaBS(rs.getString("maBS"));
	                
	                ChuyenKhoa ck = new ChuyenKhoa();
	                ck.setTenKhoa(rs.getString("TenChuyenKhoa"));
	                bs.setChuyenKhoa(ck);
	                
	                listBacSi.add(bs);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        listBacSi = null;
	    }
	    return listBacSi;
	}
	

	public boolean luuLichChinhThuc(ArrayList<ThongTinDangKiBacSi> listLichDK, int idQuanLy) {
	    if (listLichDK == null || listLichDK.isEmpty()) return false;
	    
	    boolean kq = false;

	    final String SQL_FIND_TDKI = "SELECT id FROM tblThongTinDangKiBacSi WHERE tblCadangkid = ? AND tblBacsiid = ?";
	    final String SQL_UPDATE_TDKI = "UPDATE tblThongTinDangKiBacSi SET trangthai = 'DA_DUYET' WHERE id = ?";
	    final String SQL_INSERT_TDKI = "INSERT INTO tblThongTinDangKiBacSi(ngayTao, tblCadangkid, tblBacsiid, trangthai) VALUES(NOW(), ?, ?, 'DA_DUYET')";
	    final String SQL_INSERT_LCT = "INSERT INTO tblThongTinLichChinhThuc(trangthaiduyet, tblThongtindangkibacsiid, tblQuanlyid) VALUES('DA_DUUYET', ?, ?)";
	    
	    try {
	        this.con.setAutoCommit(false);
	        
	        for (ThongTinDangKiBacSi dk : listLichDK) {
	            int currentDkId = dk.getId();
	            int finalDkId = currentDkId;

	            if (currentDkId == 0) {
	               
	                try (PreparedStatement psInsertTDKI = con.prepareStatement(SQL_INSERT_TDKI, PreparedStatement.RETURN_GENERATED_KEYS)) {
	                    psInsertTDKI.setInt(1, dk.getCaDangKi().getId()); 
	                    psInsertTDKI.setString(2, dk.getBacSi().getMaBS());
	                    psInsertTDKI.executeUpdate();
	                    
	                    try (ResultSet rsKeys = psInsertTDKI.getGeneratedKeys()) {
	                        if (rsKeys.next()) {
	                            finalDkId = rsKeys.getInt(1);
	                        }
	                    }
	                }
	            } else {
	                try (PreparedStatement psUpdate = con.prepareStatement(SQL_UPDATE_TDKI)) {
	                    psUpdate.setInt(1, currentDkId); 
	                    psUpdate.executeUpdate();
	                }
	                finalDkId = currentDkId;
	            }

	            if (finalDkId > 0) {
	                try (PreparedStatement psThemLCT = con.prepareStatement(SQL_INSERT_LCT)) {
	                    psThemLCT.setInt(1, finalDkId);
	                    psThemLCT.setInt(2, idQuanLy);
	                    psThemLCT.executeUpdate();
	                }
	            } else {
	                throw new Exception("Bản ghi TDKI không có ID hợp lệ sau khi xử lý (ID=0).");
	            }
	        }
	        
	        this.con.commit(); 
	        kq = true;
	        
	    } catch (Exception e) {
	        try {
	            this.con.rollback(); 
	        } catch (Exception ee) {
	            kq = false;
	            ee.printStackTrace();
	        }
	        e.printStackTrace(); 
	    } finally {
	        try {
	            this.con.setAutoCommit(true); 
	        } catch (Exception e) {
	            kq = false;
	            e.printStackTrace();
	        }
	    }
	    return kq;
	}
}