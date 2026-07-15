package controller;


import dao.HoaDonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.HoaDon;

@WebServlet(name = "HoaDonServlet", urlPatterns = {"/hoadon"})
public class HoaDonServlet extends HttpServlet {

    private HoaDonDAO dao = new HoaDonDAO();

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
            case "new":
                request.getRequestDispatcher("/views/hoadon2.jsp").forward(request, response);
                break;

            case "edit":
                String maHDEdit = request.getParameter("maHD");
                HoaDon hd = dao.findById(maHDEdit);
                request.setAttribute("hoadon", hd);
                request.getRequestDispatcher("/views/hoadon2.jsp").forward(request, response);
                break;

            case "delete":
                String maHDDelete = request.getParameter("maHD");
                dao.delete(maHDDelete);
                response.sendRedirect("hoadon");
                break;

            default:
                ArrayList<HoaDon> list = dao.getAll();
                request.setAttribute("listHoaDon", list);
                request.getRequestDispatcher("/views/hoadon1.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        String maHD = request.getParameter("maHD");
        String maBan = request.getParameter("maBan");
        String maNV = request.getParameter("maNV");
        String ngayTao = request.getParameter("ngayTao");
        String trangThai = request.getParameter("trangThai");
        
        double tongTien = 0;
        try {
            if (request.getParameter("tongTien") != null) {
                tongTien = Double.parseDouble(request.getParameter("tongTien"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if ("insert".equals(action)) {
            HoaDon hd = new HoaDon(maHD, maBan, maNV, ngayTao, tongTien, trangThai);
            dao.insert(hd);
        } 
        else if ("update".equals(action)) {
            HoaDon hd = new HoaDon(maHD, maBan, maNV, ngayTao, tongTien, trangThai);
            dao.update(hd);
        } 
        else if ("updateStatus".equals(action)) {
            dao.updateStatus(maHD, trangThai);
        }

        response.sendRedirect("hoadon");
    }
}