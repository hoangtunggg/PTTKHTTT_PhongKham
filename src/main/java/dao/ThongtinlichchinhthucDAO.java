package dao;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Iterator;
import model.ThongTinDangKiBacSi;

public class ThongtinlichchinhthucDAO extends DAO {

    public ThongtinlichchinhthucDAO() {
        super();
    }

	// Phương thức 1: CẬP NHẬT TRẠNG THÁI (UPDATE)
	private void capNhatTrangThaiTDKI(ThongTinDangKiBacSi dk) throws Exception {
	    // Cập nhật trạng thái trong bảng đăng ký ban đầu thành 'DA_DUYET'
	    String sqlUpdateTDKI = "UPDATE tblThongTinDangKiBacSi SET trangthai = 'DA_DUYET' WHERE id = ?";
	    
	    try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdateTDKI)) {
	        psUpdate.setInt(1, dk.getId()); 
	        psUpdate.executeUpdate();
	    }
	}

	// Phương thức 2: THÊM BẢN GHI LỊCH CHÍNH THỨC (INSERT)
	private void themLichChinhThuc(ThongTinDangKiBacSi dk, int idQuanLy) throws Exception {
	    // Chèn vào bảng lịch chính thức (tblThongTinLichChinhThuc) với trạng thái 1 (DA_DUYET)
	    String sqlThemLCT = "INSERT INTO tblThongTinLichChinhThuc(trangthaiduyet, tblThongtindangkibacsiid, tblQuanlyid) VALUES(1, ?, ?)"; 
	    
	    try (PreparedStatement psThemLCT = con.prepareStatement(sqlThemLCT)) {
	        psThemLCT.setInt(1, dk.getId()); // ID TDKI làm Khóa ngoại
	        psThemLCT.setInt(2, idQuanLy);
	        psThemLCT.executeUpdate();
	    }
	}

	// Phương thức 3: ĐIỀU PHỐI CHÍNH (Quản lý Transaction)
	public boolean luuLichChinhThuc(ArrayList<ThongTinDangKiBacSi> listLichDK, int idQuanLy) {
	    if (listLichDK == null || listLichDK.isEmpty()) return false;
	    
	    boolean kq = false;
	    
	    try {
	        // Bắt đầu Giao dịch (Transaction)
	        this.con.setAutoCommit(false);
	        
	        // Vòng lặp chỉ xử lý các bản ghi có ID TDKI hợp lệ (đã có trong DB)
	        for (ThongTinDangKiBacSi dk : listLichDK) {
	             
	            // LƯU Ý: Ta chỉ muốn xử lý các bản ghi đã được lưu vào DB (ID > 0)
	            // và đang ở trạng thái CHO_DUYET (để không xử lý lại lịch đã duyệt)
	            int currentDkId = dk.getId();
	            
	            // Bỏ qua các bản ghi không có ID hoặc đã có trạng thái 'DA_DUYET'
	            // (Logic kiểm tra trạng thái cần được thực hiện trước khi gọi hàm này)
	            if (currentDkId <= 0 || "DA_DUYET".equalsIgnoreCase(dk.getTrangThai())) {
                    // Nếu là bản nháp mới (ID=0), nó không được lưu vào LCT.
	                continue; 
	            }
	            
	            // 1. UPDATE: Cập nhật trạng thái TDKI (TDKI phải có ID hợp lệ trong DB)
	            capNhatTrangThaiTDKI(dk);
	            
	            // 2. INSERT: Thêm bản ghi LCT mới (tham chiếu đến ID TDKI)
	            themLichChinhThuc(dk, idQuanLy);
	        }
	        
	        // Xác nhận Giao dịch
	        this.con.commit(); 
	        kq = true;
	        
	    } catch (Exception e) {
	        try {
	            // Hoàn tác nếu có lỗi (Đặc biệt quan trọng với LCT)
	            this.con.rollback(); 
	        } catch (Exception ee) {
	            kq = false;
	            ee.printStackTrace();
	        }
	        e.printStackTrace(); 
	    } finally {
	        try {
	            // Đặt lại chế độ AutoCommit
	            this.con.setAutoCommit(true); 
	        } catch (Exception e) {
	            kq = false;
	            e.printStackTrace();
	        }
	    }
	    return kq;
	}
}