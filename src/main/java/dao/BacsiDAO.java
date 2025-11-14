package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;

import model.BacSi;
import model.ChuyenKhoa;

public class BacsiDAO extends DAO {

    public BacsiDAO() {
        super();
    }
 
    public BacSi getBacSiByThanhVienId(int idThanhVien) {
        BacSi bs = null;
        String sql = "{call LayChiTietBacSi(?)}"; 

        try {
        	CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, idThanhVien);
            ResultSet rs = cs.executeQuery(); 
            if (rs.next()) {
                bs = new BacSi();
                bs.setMaBS(rs.getString("maBS"));
                bs.setChucVu(rs.getString("chucvu"));
                bs.setTkNganHang(rs.getString("tknganhang"));
                bs.setId(idThanhVien); 
                
                ChuyenKhoa ck = new ChuyenKhoa();
                ck.setId(rs.getInt("idchuyenkhoa")); 
                ck.setTenKhoa(rs.getString("tenkhoa"));
                bs.setChuyenKhoa(ck);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bs;
    }
}