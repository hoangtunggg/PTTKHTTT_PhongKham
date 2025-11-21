package model;

public class CaDangKi {

    private int id;
    private String ngayLamViec; 
    private String caLamViec; 
    private TuanLamViec tuanLamViec;
    private int soNguoiToiDa;
    private int soNguoiDaDuyet;

    public CaDangKi() {
    }

    public CaDangKi(int id, String ngayLamViec, String caLamViec, TuanLamViec tuanLamViec, int soNguoiToiDa, int soNguoiDaDuyet) {
        this.id = id;
        this.ngayLamViec = ngayLamViec;
        this.caLamViec = caLamViec;
        this.tuanLamViec = tuanLamViec;
        this.soNguoiToiDa = soNguoiToiDa;
        this.soNguoiDaDuyet = soNguoiDaDuyet;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNgayLamViec() {
        return ngayLamViec;
    }

    public void setNgayLamViec(String ngayLamViec) {
        this.ngayLamViec = ngayLamViec;
    }

    public String getCaLamViec() {
        return caLamViec;
    }

    public void setCaLamViec(String caLamViec) {
        this.caLamViec = caLamViec;
    }

    public TuanLamViec getTuanLamViec() {
        return tuanLamViec;
    }

    public void setTuanLamViec(TuanLamViec tuanLamViec) {
        this.tuanLamViec = tuanLamViec;
    }
    
    public int getSoNguoiToiDa() {
        return soNguoiToiDa;
    }

    public void setSoNguoiToiDa(int soNguoiToiDa) {
        this.soNguoiToiDa = soNguoiToiDa;
    }

    public int getSoNguoiDaDuyet() {
        return soNguoiDaDuyet;
    }

    public void setSoNguoiDaDuyet(int soNguoiDaDuyet) {
        this.soNguoiDaDuyet = soNguoiDaDuyet;
    }
}