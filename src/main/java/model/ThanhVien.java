package model;

public class ThanhVien {
	private int id;
	private String username, password, vaiTro, hoTen, sdt;
	
	public ThanhVien() {
	}
	
	public ThanhVien(int id, String username, String password, String vaiTro, String hoTen, String sdt) {
		this.id = id;
		this.username = username;
		this.password = password;
		this.vaiTro = vaiTro;
		this.hoTen = hoTen;
		this.sdt = sdt;
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() { 
		return password;
	}
	
	public String getVaiTro() {
		return vaiTro;
	}

	public void setVaiTro(String vaiTro) {
		this.vaiTro = vaiTro;
	}

	public void setPassword(String password) { 
		this.password = password;
	}
	public String getHoTen() {
		return hoTen;
	}
	public void setHoTen(String hoTen) {
		this.hoTen = hoTen;
	}
	public String getSdt() {
		return sdt;
	}
	public void setSdt(String sdt) {
		this.sdt = sdt;
	}
	
}