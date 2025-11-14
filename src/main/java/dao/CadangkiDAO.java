package dao;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.CaDangKi;
import model.ThongTinDangKiBacSi;
import model.TuanLamViec;

public class CadangkiDAO extends DAO {

    public CadangkiDAO() {
        super();
    }

    public ArrayList<CaDangKi> getDSCaTheoTuan(int idTuanlamviec) {
        ArrayList<CaDangKi> listCa = null;
        String sql = "{call LayDSCaTheoTuan(?)}"; 
        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idTuanlamviec);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    if (listCa == null) {
                        listCa = new ArrayList<CaDangKi>();
                    }
                    CaDangKi ca = new CaDangKi();
                    ca.setId(rs.getInt("id"));
                    ca.setNgayLamViec(rs.getString("ngaylamviec"));
                    ca.setCaLamViec(rs.getString("calamviec"));
                    TuanLamViec tlv = new TuanLamViec();
                    tlv.setId(rs.getInt("idTuan"));
                    ca.setTuanLamViec(tlv);
                    listCa.add(ca);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            listCa = null;
        }
        return listCa;
    }

    public CaDangKi getCaDangKiByID(int idCa) {
        CaDangKi ca = null;
        String sql = "{call LayChiTietCa(?)}"; 
        
        try (CallableStatement cs = con.prepareCall(sql)) {
            
            cs.setInt(1, idCa);
            
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    ca = new CaDangKi();
                    ca.setId(rs.getInt("id")); 
                    ca.setNgayLamViec(rs.getString("ngaylamviec"));
                    ca.setCaLamViec(rs.getString("calamviec"));

                    TuanLamViec tlv = new TuanLamViec();
                    tlv.setId(rs.getInt("idTuan")); 
                    ca.setTuanLamViec(tlv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ca;
    }
}