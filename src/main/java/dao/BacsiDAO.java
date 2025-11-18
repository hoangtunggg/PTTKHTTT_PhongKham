package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

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
    
    public ArrayList<BacSi> getDSBacSi() {
        ArrayList<BacSi> listBS = null;
        String sql = "{call LayDSBacSiChoQL()}"; 
        
        try (CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {
            
            while (rs.next()) {
                if (listBS == null) {
                    listBS = new ArrayList<>();
                }
                ChuyenKhoa ck = new ChuyenKhoa();
                ck.setTenKhoa(rs.getString("chuyenkhoa")); 
                
                BacSi bs = new BacSi();
                bs.setMaBS(rs.getString("maBS"));
                bs.setHoTen(rs.getString("hoTenBS")); 
                bs.setChuyenKhoa(ck); 
                listBS.add(bs);
            }
        } catch (Exception e) {
            e.printStackTrace();
            listBS = null;
        }
        return listBS;
    }
}