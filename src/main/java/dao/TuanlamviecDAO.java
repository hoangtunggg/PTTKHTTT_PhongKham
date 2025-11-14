package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.Calendar;

import model.TuanLamViec;

public class TuanlamviecDAO extends DAO {

    public int getTuanhtai() {
        Calendar cal = Calendar.getInstance();
        Date currentDate = new Date(cal.getTimeInMillis());
        
        int idTuan = -1;
        String sql = "{call LayTuanHienTai(?)}"; 
        
        try{
        	CallableStatement cs = con.prepareCall(sql);
            cs.setDate(1, currentDate);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
              idTuan = rs.getInt("id"); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return idTuan;
    }
    
    public TuanLamViec getTuanById(int idTuan) {
        TuanLamViec tlv = null;
        String sql = "{call LayChiTietTuan(?)}"; 
        try{
        	CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, idTuan);
        	ResultSet rs = cs.executeQuery();
        	if (rs.next()) {
                tlv = new TuanLamViec();
                tlv.setId(rs.getInt("id"));
                tlv.setTen(rs.getString("ten"));
                tlv.setNgayBatDau(rs.getDate("ngayBatDau"));
                tlv.setNgayKetThuc(rs.getDate("ngayKetThuc"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tlv;
    }
}