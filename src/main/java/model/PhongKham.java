package model;

public class PhongKham {
    
    private int id;
    private String tenPhongKham;
    private String diaChi;
    private String moTa;

    public PhongKham() {
    }

    public PhongKham(int id, String tenPhongKham, String diaChi, String moTa) {
        this.id = id;
        this.tenPhongKham = tenPhongKham;
        this.diaChi = diaChi;
        this.moTa = moTa;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenPhongKham() {
        return tenPhongKham;
    }

    public void setTenPhongKham(String tenPhongKham) {
        this.tenPhongKham = tenPhongKham;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }
}