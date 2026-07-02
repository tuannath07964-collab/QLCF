/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;
import java.io.PrintWriter;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.http.HttpSession;
/**
 *
 * @author trung
 */
@WebServlet(name="LoginServlet", urlPatterns={"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    private static final Map<String, String[]> ds = new HashMap<>(); 

    static {
    ds.put("TH08922", new String[]{"123", "Nguyễn Minh Đăng"});
    ds.put("TH07964", new String[]{"123", "Nguyễn Anh Tuấn"});
    ds.put("TH07969", new String[]{"123", "Phùng Chí Trung"});
    ds.put("TH08495", new String[]{"123", "Trần Dương Phương Hiếu"});
    ds.put("TH08860", new String[]{"123", "Ngô Thanh Long"});
    ds.put("TH08199", new String[]{"123", "Trịnh Bình Minh"});
}
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/views/loginform.jsp");
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String maNV = request.getParameter("maNV");
        String matKhau = request.getParameter("matKhau");

        String[] thongTinNV = ds.get(maNV);

        if (thongTinNV != null && thongTinNV[0].equals(matKhau)) {
            HttpSession session = request.getSession();

            session.setAttribute("maNV", maNV);
            session.setAttribute("tenNV", thongTinNV[1]);

            response.sendRedirect(request.getContextPath() + "/views/homepage.jsp");
        } else {
            request.setAttribute("error", "Sai mã nhân viên hoặc mật khẩu!");
            request.getRequestDispatcher("/views/loginform.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
