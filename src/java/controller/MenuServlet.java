package controller;

import dao.MenuDAO;
import model.Menu;

import java.io.IOException;
import java.util.ArrayList;
import java.math.BigDecimal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import dao.MenuDAO;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private MenuDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new MenuDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "search":
                    String keyword = request.getParameter("keyword");
                    List<Menu> searchList = dao.searchMenu(keyword);
                    request.setAttribute("listMenu", searchList);
                    request.getRequestDispatcher("/views/Menu.jsp").forward(request, response);
                    break;
                case "loadForm":
                    loadForm(request, response);
                    break; // Mở form Thêm/Sửa món (Menu1.jsp)
                case "detail":
                    detailMenu(request, response);
                    break; // Mở trang xem chi tiết (Menu2.jsp)
                case "add":
                    insertMenu(request, response);
                    break;
                case "edit":
                    updateMenu(request, response);
                    break;
                case "delete":
                    deleteMenu(request, response);
                    break;
                default:
                    listMenu(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    private void loadForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maMon = request.getParameter("maMon");
        if (maMon != null && !maMon.trim().isEmpty()) {
            Menu m = dao.getMenuById(maMon);
            request.setAttribute("menu", m);
            request.setAttribute("mode", "edit");
        } else {
            request.setAttribute("mode", "add");
        }
        request.getRequestDispatcher("/views/Menu1.jsp").forward(request, response);
    }

    private void detailMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maMon = request.getParameter("maMon");
        if (maMon != null && !maMon.trim().isEmpty()) {
            Menu m = dao.getMenuById(maMon);
            request.setAttribute("menu", m);
        }
        request.getRequestDispatcher("/views/Menu2.jsp").forward(request, response);
    }

    private void listMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("maNV") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String loaiMon = request.getParameter("loaiMon");
        ArrayList<Menu> listMenu;

        if (loaiMon != null && !loaiMon.trim().isEmpty() && !loaiMon.equals("all")) {
            listMenu = dao.getMenuByType(loaiMon);
            request.setAttribute("selectedLoai", loaiMon);
        } else {
            listMenu = dao.getAllMenu();
            request.setAttribute("selectedLoai", "all");
        }

        request.setAttribute("listMenu", listMenu);
        request.getRequestDispatcher("/views/Menu.jsp").forward(request, response);
    }

    private void insertMenu(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Menu m = buildMenuFromRequest(request);
        dao.insertMenu(m);
        response.sendRedirect(request.getContextPath() + "/menu?action=list");
    }

    private void updateMenu(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Menu m = buildMenuFromRequest(request);
        dao.updateMenu(m);
        response.sendRedirect(request.getContextPath() + "/menu?action=list");
    }

    private void deleteMenu(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String maMon = request.getParameter("maMon");
        if (maMon != null) {
            dao.deleteMenu(maMon);
        }
        response.sendRedirect(request.getContextPath() + "/menu?action=list");
    }

    private Menu buildMenuFromRequest(HttpServletRequest request) {
        Menu m = new Menu();
        m.setMaMon(request.getParameter("maMon"));
        m.setTenMon(request.getParameter("tenMon"));
        m.setLoaiMon(request.getParameter("loaiMon"));

        String giaStr = request.getParameter("gia");
        if (giaStr != null && !giaStr.trim().isEmpty()) {
            m.setGia(new BigDecimal(giaStr));
        }

        // Nếu checkbox được tích -> trả về true (Còn hàng), ngược lại không tích -> false (Hết hàng)
        boolean trangThai = request.getParameter("trangThai") != null;
        m.setTrangThai(trangThai);

        return m;
    }
}
