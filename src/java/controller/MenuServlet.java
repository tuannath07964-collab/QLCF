package controller;

import dao.MenuDAO;
import model.Menu;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MenuServlet", urlPatterns = {"/menu"})
public class MenuServlet extends HttpServlet {

    private final MenuDAO dao = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "them":
                request.getRequestDispatcher("/views/themMenu.jsp").forward(request, response);
                break;

            case "sua":
                showEdit(request, response);
                break;

            case "xoa":
                deleteMenu(request, response);
                break;

            default:
                loadMenu(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action"); // Lấy action từ URL

        if ("insert".equals(action)) {
            insertMenu(request, response);
        } else if ("update".equals(action)) {
            updateMenu(request, response);
        } else {
            response.sendRedirect("menu");
        }
    }

    private void loadMenu(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Menu> list = dao.getAll();
        request.setAttribute("list", list);
        request.getRequestDispatcher("/views/Menu.jsp").forward(request, response);
    }

    private void insertMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Menu m = new Menu();
        m.setTenMon(request.getParameter("tenMon"));
        m.setLoai(request.getParameter("loai"));
        m.setGia(Double.parseDouble(request.getParameter("gia")));
        m.setTrangThai(request.getParameter("trangThai"));
        m.setHinhAnh(request.getParameter("hinhAnh"));
        dao.insert(m);
        response.sendRedirect("menu");
    }

    private void showEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Menu menu = dao.getById(id);
        request.setAttribute("menu", menu);
        request.getRequestDispatcher("/views/suaMenu.jsp").forward(request, response);
    }

    private void updateMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Menu m = new Menu();
        m.setMaMon(Integer.parseInt(request.getParameter("maMon")));
        m.setTenMon(request.getParameter("tenMon"));
        m.setLoai(request.getParameter("loai"));
        m.setGia(Double.parseDouble(request.getParameter("gia")));
        m.setTrangThai(request.getParameter("trangThai"));
        m.setHinhAnh(request.getParameter("hinhAnh"));
        dao.update(m);
        response.sendRedirect("menu");
    }

    private void deleteMenu(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.delete(id);
        response.sendRedirect("menu");
    }
}
