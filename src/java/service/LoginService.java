package service;

import dao.NhanVienDAO;
import model.NhanVien;

/**
 * LoginService - Business logic layer for Authentication
 * Xử lý logic đăng nhập và xác thực người dùng
 */
public class LoginService {
    
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();
    
    /**
     * Xác thực người dùng
     * @param maNV mã nhân viên
     * @param matKhau mật khẩu
     * @return NhanVien object nếu đúng, null nếu sai
     */
    public NhanVien authenticate(String maNV, String matKhau) {
        // Validation
        if (maNV == null || maNV.trim().isEmpty()) {
            System.err.println("[LoginService] Mã nhân viên không được để trống");
            return null;
        }
        
        if (matKhau == null || matKhau.trim().isEmpty()) {
            System.err.println("[LoginService] Mật khẩu không được để trống");
            return null;
        }
        
        // Query database
        NhanVien nhanVien = nhanVienDAO.getNhanVienById(maNV);
        
        if (nhanVien == null) {
            System.err.println("[LoginService] Nhân viên không tồn tại: " + maNV);
            return null;
        }
        
        // Verify password (hiện tại dùng hardcoded - TODO: thay bằng BCrypt)
        if (verifyPassword(maNV, matKhau)) {
            return nhanVien;
        }
        
        System.err.println("[LoginService] Sai mật khẩu cho nhân viên: " + maNV);
        return null;
    }
    
    /**
     * Kiểm tra mật khẩu (hiện tại hardcoded)
     * TODO: Replace with BCrypt in production
     * @param maNV mã nhân viên
     * @param matKhau mật khẩu
     * @return true nếu đúng
     */
    private boolean verifyPassword(String maNV, String matKhau) {
        // TODO: Thay thế bằng query từ database và BCrypt.checkpw()
        java.util.Map<String, String> credentials = new java.util.HashMap<>();
        credentials.put("TH08922", "123");
        credentials.put("TH07964", "123");
        credentials.put("TH07969", "123");
        credentials.put("TH08495", "123");
        credentials.put("TH08860", "123");
        credentials.put("TH08199", "123");
        
        String storedPassword = credentials.get(maNV);
        return storedPassword != null && storedPassword.equals(matKhau);
    }
}
