package controller;

import dao.KhachHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.KhachHang;

@WebServlet(name = "KhachHangServlet", urlPatterns = {"/khachhang"})
public class khachhangServlet extends HttpServlet {

    private KhachHangDAO dao = new KhachHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                request.getRequestDispatcher("/views/khachhang1.jsp").forward(request, response);
                break;

            case "edit":
                String maKH = request.getParameter("maKH");
                KhachHang kh = dao.findById(maKH);
                request.setAttribute("kh", kh);
                request.setAttribute("action", "edit"); // Truyền action để form biết là đang sửa
                request.getRequestDispatcher("/views/khachhang1.jsp").forward(request, response);
                break;

            case "delete":
                String maKHDelete = request.getParameter("maKH");
                dao.delete(maKHDelete);
                response.sendRedirect("khachhang");
                break;

            default: // list
                ArrayList<KhachHang> list = dao.getAll();
                request.setAttribute("listKH", list);
                request.getRequestDispatcher("/views/khachhang.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String maKH = request.getParameter("maKH");
        String tenKH = request.getParameter("tenKH");
        String sdt = request.getParameter("sdt");

        KhachHang kh = new KhachHang(maKH, tenKH, sdt);

        if ("insert".equals(action)) {
            dao.insert(kh);
        } else if ("update".equals(action)) {
            dao.update(kh);
        }

        response.sendRedirect("khachhang");
    }
}