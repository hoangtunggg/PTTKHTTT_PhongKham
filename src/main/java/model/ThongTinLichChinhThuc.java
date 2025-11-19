package model;

import java.sql.Date;

public class ThongTinLichChinhThuc {

    private int id;
    private boolean trangThaiDuyet; 
    private ThongTinDangKiBacSi ttDangKi; 
    private QuanLy quanLy;
    
    public ThongTinLichChinhThuc() { }
    
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public boolean isTrangThaiDuyet() {
		return trangThaiDuyet;
	}
	public void setTrangThaiDuyet(boolean trangThaiDuyet) {
		this.trangThaiDuyet = trangThaiDuyet;
	}
	public ThongTinDangKiBacSi getTtDangKi() {
		return ttDangKi;
	}
	public void setTtDangKi(ThongTinDangKiBacSi ttDangKi) {
		this.ttDangKi = ttDangKi;
	}
	public QuanLy getQuanLy() {
		return quanLy;
	}
	public void setQuanLy(QuanLy quanLy) {
		this.quanLy = quanLy;
	}

    
}
