package model;

public class QuanLy extends ThanhVien{
	private String phongBan;

	public QuanLy() {
		super();

	}

	public QuanLy(int id, String username, String password, String vaiTro, String hoTen, String sdt, String phongBan) {
		super(id, username, password, vaiTro, hoTen, sdt);
		this.phongBan = phongBan;
	}

	public String getPhongBan() {
		return phongBan;
	}

	public void setPhongBan(String phongBan) {
		this.phongBan = phongBan;
	}
}
