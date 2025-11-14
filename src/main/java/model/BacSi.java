package model;

public class BacSi extends ThanhVien {
	
	private String chucVu;
	private String maBS;
	private String tkNganHang;
	private ChuyenKhoa chuyenKhoa;
	
	public BacSi() {
		super();
	}
	
	public BacSi(int id, String username, String password, String vaiTro, String hoTen, String sdt, String chucVu, String maBS, String tkNganHang) {
		super(id, username, password, vaiTro, hoTen, sdt); 
		this.chucVu = chucVu;
		this.maBS = maBS;
		this.tkNganHang = tkNganHang;
	}

	public String getChucVu() {
		return chucVu;
	}

	public void setChucVu(String chucVu) {
		this.chucVu = chucVu;
	}

	public String getMaBS() {
		return maBS;
	}

	public void setMaBS(String maBS) {
		this.maBS = maBS;
	}

	public String getTkNganHang() {
		return tkNganHang;
	}

	public void setTkNganHang(String tkNganHang) {
		this.tkNganHang = tkNganHang;
	}
	
	public ChuyenKhoa getChuyenKhoa() {
        return chuyenKhoa;
    }

    public void setChuyenKhoa(ChuyenKhoa chuyenKhoa) {
        this.chuyenKhoa = chuyenKhoa;
    }
}