package service;

import dao.MenuDAO;
import model.Menu;
import java.util.List;

/**
 * MenuService - Business logic layer for Menu management
 * Xử lý logic nghiệp vụ trước khi gọi DAO
 */
public class MenuService {
    
    private MenuDAO menuDAO = new MenuDAO();
    
    /**
     * Lấy danh sách tất cả món
     * @return List<Menu>
     */
    public List<Menu> getAllMenu() {
        return menuDAO.getAll();
    }
    
    /**
     * Lấy món theo mã
     * @param maMon mã món
     * @return Menu object hoặc null
     */
    public Menu getMenuById(int maMon) {
        if (maMon <= 0) {
            return null;
        }
        return menuDAO.getById(maMon);
    }
    
    /**
     * Thêm món mới với validation
     * @param m Menu object
     * @return true nếu thành công
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    public boolean insertMenu(Menu m) throws IllegalArgumentException {
        validateMenu(m);
        return menuDAO.insert(m);
    }
    
    /**
     * Cập nhật món với validation
     * @param m Menu object
     * @return true nếu thành công
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    public boolean updateMenu(Menu m) throws IllegalArgumentException {
        validateMenu(m);
        return menuDAO.update(m);
    }
    
    /**
     * Xóa món
     * @param maMon mã món
     * @return true nếu thành công
     */
    public boolean deleteMenu(int maMon) {
        if (maMon <= 0) {
            return false;
        }
        return menuDAO.delete(maMon);
    }
    
    /**
     * Validate dữ liệu menu
     * @param m Menu object
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     */
    private void validateMenu(Menu m) throws IllegalArgumentException {
        if (m == null) {
            throw new IllegalArgumentException("Menu không được null");
        }
        
        if (m.getTenMon() == null || m.getTenMon().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên món không được để trống");
        }
        
        if (m.getGia() <= 0) {
            throw new IllegalArgumentException("Giá phải lớn hơn 0");
        }
    }
}
