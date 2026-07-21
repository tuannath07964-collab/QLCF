package controller;

import dao.NhanVienDAO;
import model.NhanVien;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet", "/login"})
public class LoginServlet extends HttpServlet {

    private NhanVienDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new NhanVienDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Dùng sendRedirect để trình duyệt tự ghép đúng context path (/qlcf/views/loginform.jsp)
        response.sendRedirect(request.getContextPath() + "/views/loginform.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        String maNV = request.getParameter("maNV");
        String matKhau = request.getParameter("matKhau");

        try {
            NhanVien nv = dao.checkLogin(maNV, matKhau);

            if (nv != null) {
                HttpSession session = request.getSession();
                session.setAttribute("acc", nv);
                session.setAttribute("maNV", nv.getMaNV());
                session.setAttribute("tenNV", nv.getHoTen());

                response.sendRedirect(request.getContextPath() + "/views/homepage.jsp");
            } else {
                request.setAttribute("error", "Sai mã nhân viên hoặc mật khẩu!");
                getServletContext().getRequestDispatcher("/views/loginform.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    public String getServletInfo() {
        return "LoginServlet quản lý đăng nhập hệ thống quán cà phê";
    }
}
