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

@WebServlet(name = "MenuServlet", urlPatterns = {
    "/Menu",
    "/themMenu",
    "/suaMenu",
    "/xoaMenu"
})
public class MenuServlet extends HttpServlet {

    MenuDAO dao = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

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

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getServletPath();

        switch (action) {

            case "/themMenu":
                insertMenu(request, response);
                break;

            case "/suaMenu":
                updateMenu(request, response);
                break;
        }

    }

    private void loadMenu(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Menu> list = dao.getAll();

        request.setAttribute("list", list);

        request.getRequestDispatcher("views/Menu.jsp")
                .forward(request, response);

    }

    private void insertMenu(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String ten = request.getParameter("tenMon");
        String loai = request.getParameter("loai");
        double gia = Double.parseDouble(request.getParameter("gia"));
        String trangThai = request.getParameter("trangThai");
        String hinh = request.getParameter("hinhAnh");

        Menu m = new Menu();

        m.setTenMon(ten);
        m.setLoai(loai);
        m.setGia(gia);
        m.setTrangThai(trangThai);
        m.setHinhAnh(hinh);

        dao.insert(m);

        response.sendRedirect("Menu");

    }

    private void showEdit(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Menu menu = dao.getById(id);

        request.setAttribute("menu", menu);

        request.getRequestDispatcher("views/suaMenu.jsp")
                .forward(request, response);

    }

    private void updateMenu(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("maMon"));
        String ten = request.getParameter("tenMon");
        String loai = request.getParameter("loai");
        double gia = Double.parseDouble(request.getParameter("gia"));
        String trangThai = request.getParameter("trangThai");
        String hinh = request.getParameter("hinhAnh");

        Menu m = new Menu();

        m.setMaMon(id);
        m.setTenMon(ten);
        m.setLoai(loai);
        m.setGia(gia);
        m.setTrangThai(trangThai);
        m.setHinhAnh(hinh);

        dao.update(m);

        response.sendRedirect("Menu");

    }

    private void deleteMenu(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        dao.delete(id);

        response.sendRedirect("Menu");

    }

}
