package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.BacSi;
import model.CaDangKi;
import model.ThongTinDangKiBacSi;
import model.TuanLamViec;

public class ThongtindkibsiDAO extends DAO {

    public ThongtindkibsiDAO() {
        super();
    }

    public ArrayList<ThongTinDangKiBacSi> getDKiCuaBS(String maBacsi, int idTuanlamviec) {
        ArrayList<ThongTinDangKiBacSi> kq = null;
        String sql = "{call LayLichDKiCuaBS(?,?)}"; 
        
        try (CallableStatement cs = con.prepareCall(sql)) {
            
            cs.setString(1, maBacsi);
            cs.setInt(2, idTuanlamviec);
            
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    if (kq == null) kq = new ArrayList<ThongTinDangKiBacSi>();
                    
                    TuanLamViec tlv = new TuanLamViec();
                    tlv.setId(rs.getInt("idTuan"));
                    tlv.setTen(rs.getString("tenTuan"));
                    
                    CaDangKi cdk = new CaDangKi();
                    cdk.setId(rs.getInt("idCa"));
                    cdk.setNgayLamViec(rs.getString("ngayLamViec"));
                    cdk.setCaLamViec(rs.getString("caLamViec"));
                    cdk.setTuanLamViec(tlv);
                    
                    BacSi bs = new BacSi();
                    bs.setMaBS(rs.getString("maBS"));
                    
                    ThongTinDangKiBacSi ttDKBS = new ThongTinDangKiBacSi();
                    ttDKBS.setId(rs.getInt("idLichDki"));
                    ttDKBS.setNgayTao(rs.getDate("ngayTao"));
                    ttDKBS.setTrangThai(rs.getString("trangthai"));
                    ttDKBS.setCaDangKi(cdk);
                    ttDKBS.setBacSi(bs);
                    
                    kq.add(ttDKBS);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            kq = null;
        }
        return kq;
    }
    
    public boolean luuDangKyBacSi(ArrayList<ThongTinDangKiBacSi> listDKBS) {
        if ((listDKBS == null) || (listDKBS.size() == 0)) return false;
        boolean kq = false;
        String sqlFindTDKI = "SELECT id FROM tblThongTinDangKiBacSi WHERE tblCadangkid = ? AND tblBacsiid = ?";
        String sqlInsertTDKI = "INSERT INTO tblThongTinDangKiBacSi(ngayTao, tblCadangkid, tblBacsiid, trangthai) VALUES(NOW(),?,?,'CHO_DUYET')";
        try {
            this.con.setAutoCommit(false);
            String maBacsi = listDKBS.get(0).getBacSi().getMaBS();
            int idQuanLy = listDKBS.get(0).getBacSi().getId();
            for (ThongTinDangKiBacSi dk : listDKBS) {
                int caId = dk.getCaDangKi().getId();
                PreparedStatement psFind = con.prepareStatement(sqlFindTDKI);
                psFind.setInt(1, caId);
                psFind.setString(2, maBacsi);
                ResultSet rs = psFind.executeQuery();
                
                int existingDkId = 0;
                if (rs.next()) {
                    existingDkId = rs.getInt("id");
                }
                rs.close();

                if (existingDkId == 0) {
                    PreparedStatement psInsertTDKI = con.prepareStatement(sqlInsertTDKI, PreparedStatement.RETURN_GENERATED_KEYS);
                    psInsertTDKI.setInt(1, caId);
                    psInsertTDKI.setString(2, maBacsi);
                    psInsertTDKI.executeUpdate();
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