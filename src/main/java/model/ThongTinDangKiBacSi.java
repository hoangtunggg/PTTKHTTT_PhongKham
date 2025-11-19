package model;

import java.sql.Date;

public class ThongTinDangKiBacSi {

    private int id;
    private Date ngayTao;
    private String trangThai;
    private CaDangKi caDangKi; 
    private BacSi bacSi; 

    public ThongTinDangKiBacSi() {
    }

    public ThongTinDangKiBacSi(int id, Date ngayTao, String trangThai, CaDangKi caDangKi, BacSi bacSi) {
        this.id = id;
        this.ngayTao = ngayTao;
        this.trangThai = trangThai;
        this.caDangKi = caDangKi;
        this.bacSi = bacSi;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }
    
    public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}

	public CaDangKi getCaDangKi() {
        return caDangKi;
    }

    public void setCaDangKi(CaDangKi caDangKi) {
        this.caDangKi = caDangKi;
    }

    public BacSi getBacSi() {
        return bacSi;
    }

    public void setBacSi(BacSi bacSi) {
        this.bacSi = bacSi;
    }
}