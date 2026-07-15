package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.LoginService;
import model.NhanVien;

/**
 * LoginServlet - Xử lý đăng nhập
 * Gọi LoginService để xác thực
 */
@WebServlet(name="LoginServlet", urlPatterns={"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    
    private LoginService loginService = new LoginService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/views/loginform.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String maNV = request.getParameter("maNV");
        String matKhau = request.getParameter("matKhau");
        
        try {
            NhanVien nhanVien = loginService.authenticate(maNV, matKhau);
            
            if (nhanVien != null) {
                HttpSession session = request.getSession();
                session.setAttribute("maNV", nhanVien.getMaNV());
                session.setAttribute("tenNV", nhanVien.getHoTen());
                session.setAttribute("chucVu", nhanVien.getChucVu());
                session.setMaxInactiveInterval(30 * 60);
                
                response.sendRedirect(request.getContextPath() + "/views/homepage.jsp");
            } else {
                request.setAttribute("error", "Sai mã nhân viên hoặc mật khẩu");
                request.getRequestDispatcher("/views/loginform.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("[LoginServlet] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau");
            request.getRequestDispatcher("/views/loginform.jsp").forward(request, response);
        }
    }
}
