package service;

import dao.NhanVienDAO;
import model.NhanVien;
import java.util.ArrayList;

/**
 * NhanVienService - Business logic layer for Employee management
 * Xử lý logic nghiệp vụ trước khi gọi DAO
 */
public class NhanVienService {
    
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();
    
    /**
     * Lấy danh sách tất cả nhân viên
     * @return ArrayList<NhanVien>
     */
    public ArrayList<NhanVien> getAllNhanVien() {
        return nhanVienDAO.getAllNhanVien();
    }
    
    /**
     * Lấy nhân viên theo mã
     * @param maNV mã nhân viên
     * @return NhanVien object hoặc null
     */
    public NhanVien getNhanVienById(String maNV) {
        if (maNV == null || maNV.trim().isEmpty()) {
            return null;
        }
        return nhanVienDAO.getNhanVienById(maNV);
    }
    
    /**
     * Thêm nhân viên mới với validation
     * @param nv NhanVien object
     * @return true nếu thành công
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    public boolean insertNhanVien(NhanVien nv) throws IllegalArgumentException {
        validateNhanVien(nv);
        return nhanVienDAO.insertNhanVien(nv);
    }
    
    /**
     * Cập nhật nhân viên với validation
     * @param nv NhanVien object
     * @return true nếu thành công
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    public boolean updateNhanVien(NhanVien nv) throws IllegalArgumentException {
        validateNhanVien(nv);
        return nhanVienDAO.updateNhanVien(nv);
    }
    
    /**
     * Xóa nhân viên
     * @param maNV mã nhân viên
     * @return true nếu thành công
     */
    public boolean deleteNhanVien(String maNV) {
        if (maNV == null || maNV.trim().isEmpty()) {
            return false;
        }
        return nhanVienDAO.deleteNhanVien(maNV);
    }
    
    /**
     * Tìm kiếm nhân viên theo keyword
     * @param keyword từ khóa tìm kiếm
     * @return ArrayList<NhanVien>
     */
    public ArrayList<NhanVien> searchNhanVien(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return nhanVienDAO.searchNhanVien(keyword);
    }
    
    /**
     * Validate dữ liệu nhân viên
     * @param nv NhanVien object
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    private void validateNhanVien(NhanVien nv) throws IllegalArgumentException {
        if (nv == null) {
            throw new IllegalArgumentException("Nhân viên không được null");
        }
        
        if (nv.getMaNV() == null || nv.getMaNV().trim().isEmpty()) {
            throw new IllegalArgumentException("Mã nhân viên không được để trống");
        }
        
        if (nv.getHoTen() == null || nv.getHoTen().trim().isEmpty()) {
            throw new IllegalArgumentException("Họ tên không được để trống");
        }
        
        if (nv.getLuong() < 0) {
            throw new IllegalArgumentException("Lương không được âm");
        }
    }
}
