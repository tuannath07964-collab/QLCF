package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MenuService;
import model.Menu;
import java.util.List;

/**
 * MenuServlet - Quản lý Menu
 * Gọi MenuService để xử lý logic
 */
@WebServlet(name = "MenuServlet", urlPatterns = {
    "/Menu",
    "/themMenu",
    "/suaMenu",
    "/xoaMenu"
})
public class MenuServlet extends HttpServlet {

    private MenuService menuService = new MenuService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/Menu":
                    loadMenu(request, response);
                    break;
                case "/themMenu":
                    request.getRequestDispatcher("views/themMenu.jsp")
                            .forward(request, response);
                    break;
                case "/suaMenu":
                    showEdit(request, response);
                    break;
                case "/xoaMenu":
                    deleteMenu(request, response);
                    break;
                default:
                    loadMenu(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("[MenuServlet] Error in doGet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/themMenu":
                    insertMenu(request, response);
                    break;
                case "/suaMenu":
                    updateMenu(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("[MenuServlet] Error in doPost: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Load danh sách menu
    private void loadMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Menu> list = menuService.getAllMenu();
            request.setAttribute("list", list);
            request.getRequestDispatcher("views/menu.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            System.err.println("[MenuServlet] Error in loadMenu: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Thêm món
    private void insertMenu(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String tenMon = request.getParameter("tenMon");
            String loai = request.getParameter("loai");
            String giaStr = request.getParameter("gia");
            String trangThai = request.getParameter("trangThai");
            String hinhAnh = request.getParameter("hinhAnh");

            // Validation
            if (tenMon == null || tenMon.trim().isEmpty()) {
                System.err.println("[MenuServlet] Tên món trống");
                response.sendRedirect("themMenu?error=Tên món không được để trống");
                return;
            }

            double gia = 0;
            try {
                gia = Double.parseDouble(giaStr);
                if (gia <= 0) {
                    System.err.println("[MenuServlet] Giá âm");
                    response.sendRedirect("themMenu?error=Giá phải lớn hơn 0");
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("[MenuServlet] Giá không hợp lệ: " + giaStr);
                response.sendRedirect("themMenu?error=Giá phải là số");
                return;
            }

            Menu m = new Menu();
            m.setTenMon(tenMon);
            m.setLoai(loai);
            m.setGia(gia);
            m.setTrangThai(trangThai);
            m.setHinhAnh(hinhAnh);

            boolean success = menuService.insertMenu(m);
            if (success) {
                response.sendRedirect("Menu");
            } else {
                response.sendRedirect("themMenu?error=Thêm mới thất bại");
            }
        } catch (Exception e) {
            System.err.println("[MenuServlet] Error in insertMenu: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Hiển form sửa
    private void showEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("Menu");
                return;
            }

            int maMon = Integer.parseInt(idStr);
            Menu menu = menuService.getMenuById(maMon);

            if (menu != null) {
                request.setAttribute("menu", menu);
                request.getRequestDispatcher("views/suaMenu.jsp")
                        .forward(request, response);
            } else {
                response.sendRedirect("Menu");
            }
        } catch (NumberFormatException e) {
            System.err.println("[MenuServlet] Invalid menu ID: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Cập nhật món
    private void updateMenu(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String maMon_str = request.getParameter("maMon");
            String tenMon = request.getParameter("tenMon");
            String loai = request.getParameter("loai");
            String giaStr = request.getParameter("gia");
            String trangThai = request.getParameter("trangThai");
            String hinhAnh = request.getParameter("hinhAnh");

            // Validation
            if (tenMon == null || tenMon.trim().isEmpty()) {
                System.err.println("[MenuServlet] Tên món trống");
                response.sendRedirect("suaMenu?id=" + maMon_str + "&error=Tên món không được để trống");
                return;
            }

            int maMon = Integer.parseInt(maMon_str);
            double gia = 0;
            try {
                gia = Double.parseDouble(giaStr);
                if (gia <= 0) {
                    System.err.println("[MenuServlet] Giá âm");
                    response.sendRedirect("suaMenu?id=" + maMon + "&error=Giá phải lớn hơn 0");
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("[MenuServlet] Giá không hợp lệ: " + giaStr);
                response.sendRedirect("suaMenu?id=" + maMon + "&error=Giá phải là số");
                return;
            }

            Menu m = new Menu();
            m.setMaMon(maMon);
            m.setTenMon(tenMon);
            m.setLoai(loai);
            m.setGia(gia);
            m.setTrangThai(trangThai);
            m.setHinhAnh(hinhAnh);

            boolean success = menuService.updateMenu(m);
            if (success) {
                response.sendRedirect("Menu");
            } else {
                response.sendRedirect("suaMenu?id=" + maMon + "&error=Cập nhật thất bại");
            }
        } catch (NumberFormatException e) {
            System.err.println("[MenuServlet] Invalid data format: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Xóa món
    private void deleteMenu(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("Menu");
                return;
            }

            int maMon = Integer.parseInt(idStr);
            boolean success = menuService.deleteMenu(maMon);
            if (success) {
                System.out.println("[MenuServlet] Menu deleted: " + maMon);
            } else {
                System.err.println("[MenuServlet] Failed to delete menu: " + maMon);
            }
            response.sendRedirect("Menu");
        } catch (NumberFormatException e) {
            System.err.println("[MenuServlet] Invalid menu ID: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
