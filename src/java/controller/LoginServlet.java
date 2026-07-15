/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.NhanVienDAO;
import model.NhanVien;

/**
 * Login Servlet - Handles user authentication.
 * Credentials are validated against the database.
 * 
 * ⚠️ SECURITY NOTE: This servlet should be used with:
 * - HTTPS in production
 * - Password hashing with BCrypt
 * - Rate limiting on login attempts
 * - CSRF tokens for forms
 */
@WebServlet(name="LoginServlet", urlPatterns={"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();
    
    /**
     * Handles GET requests - redirects to login form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/views/loginform.jsp");
    }
    
    /**
     * Handles POST requests - validates user credentials.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String maNV = request.getParameter("maNV");
        String matKhau = request.getParameter("matKhau");
        
        // Input validation
        if (maNV == null || maNV.trim().isEmpty() || 
            matKhau == null || matKhau.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã nhân viên và mật khẩu");
            request.getRequestDispatcher("/views/loginform.jsp").forward(request, response);
            return;
        }
        
        try {
            // Query database for employee
            NhanVien nhanVien = nhanVienDAO.getNhanVienById(maNV);
            
            // Validate credentials
            // TODO: Implement BCrypt password hashing
            // For now, using simple password validation (MUST be changed for production)
            if (nhanVien != null && validatePassword(maNV, matKhau)) {
                
                // Create session and set attributes
                HttpSession session = request.getSession();
                session.setAttribute("maNV", nhanVien.getMaNV());
                session.setAttribute("tenNV", nhanVien.getHoTen());
                session.setAttribute("chucVu", nhanVien.getChucVu());
                
                // Set secure session settings
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to homepage
                response.sendRedirect(request.getContextPath() + "/views/homepage.jsp");
                
            } else {
                request.setAttribute("error", "Sai mã nhân viên hoặc mật khẩu");
                request.getRequestDispatcher("/views/loginform.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("[LoginServlet] Error during authentication: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau");
            request.getRequestDispatcher("/views/loginform.jsp").forward(request, response);
        }
    }
    
    /**
     * Validate password - this is a temporary implementation.
     * TODO: Replace with BCrypt hashing in production
     * 
     * @param maNV Employee ID
     * @param matKhau Password to validate
     * @return true if password is correct
     */
    private boolean validatePassword(String maNV, String matKhau) {
        // TODO: Query database for hashed password and use BCrypt.checkpw()
        // This is temporary for demo purposes only
        
        // Hard-coded for testing (REMOVE THIS IN PRODUCTION!)
        java.util.Map<String, String> credentials = new java.util.HashMap<>();
        credentials.put("TH08922", "123");
        credentials.put("TH07964", "123");
        credentials.put("TH07969", "123");
        credentials.put("TH08495", "123");
        credentials.put("TH08860", "123");
        credentials.put("TH08199", "123");
        
        String storedPassword = credentials.get(maNV);
        return storedPassword != null && storedPassword.equals(matKhau);
    }
    
    @Override
    public String getServletInfo() {
        return "Login Servlet - Handles user authentication";
    }
}
