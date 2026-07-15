package service;

import dao.MenuDAO;
import model.Menu;
import java.util.List;

/**
 * ThongKeService - Business logic layer for Statistics/Reporting
 * Xử lý logic thống kê và báo cáo
 */
public class ThongKeService {
    
    private MenuDAO menuDAO = new MenuDAO();
    
    /**
     * Tính tổng doanh thu từ menu (giá x số lượng)
     * Hiện tại tính dự tính doanh thu
     * @return tổng giá trị menu
     */
    public double calculateTotalRevenue() {
        List<Menu> list = menuDAO.getAll();
        double total = 0;
        
        for (Menu m : list) {
            total += m.getGia();
        }
        
        return total;
    }
    
    /**
     * Lấy menu có giá cao nhất
     * @return Menu object
     */
    public Menu getHighestPriceMenu() {
        List<Menu> list = menuDAO.getAll();
        if (list == null || list.isEmpty()) {
            return null;
        }
        
        Menu highest = list.get(0);
        for (Menu m : list) {
            if (m.getGia() > highest.getGia()) {
                highest = m;
            }
        }
        
        return highest;
    }
    
    /**
     * Lấy menu có giá thấp nhất
     * @return Menu object
     */
    public Menu getLowestPriceMenu() {
        List<Menu> list = menuDAO.getAll();
        if (list == null || list.isEmpty()) {
            return null;
        }
        
        Menu lowest = list.get(0);
        for (Menu m : list) {
            if (m.getGia() < lowest.getGia()) {
                lowest = m;
            }
        }
        
        return lowest;
    }
    
    /**
     * Tính giá trung bình menu
     * @return giá trung bình
     */
    public double calculateAveragePrice() {
        List<Menu> list = menuDAO.getAll();
        if (list == null || list.isEmpty()) {
            return 0;
        }
        
        double total = 0;
        for (Menu m : list) {
            total += m.getGia();
        }
        
        return total / list.size();
    }
}
