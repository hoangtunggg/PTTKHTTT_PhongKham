package model;

public class ChuyenKhoa {

    private int id;
    private String tenKhoa;
    private PhongKham phongKham;

    public ChuyenKhoa() {
    }

    public ChuyenKhoa(int id, String tenKhoa, PhongKham phongKham) {
        this.id = id;
        this.tenKhoa = tenKhoa;
        this.phongKham = phongKham;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTenKhoa() {
        return tenKhoa;
    }

    public void setTenKhoa(String tenKhoa) {
        this.tenKhoa = tenKhoa;
    }

    public PhongKham getPhongKham() {
        return phongKham;
    }

    public void setPhongKham(PhongKham phongKham) {
        this.phongKham = phongKham;
    }
}