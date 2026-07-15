package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.NhanVienService;
import model.NhanVien;
import java.util.ArrayList;

/**
 * NhanVienServlet - Quản lý Nhân Viên
 * Gọi NhanVienService để xử lý logic
 */
@WebServlet(name="NhanVienServlet", urlPatterns={
    "/NhanVien",
    "/themNhanVien",
    "/suaNhanVien",
    "/xoaNhanVien",
    "/timNhanVien"
})
public class NhanVienServlet extends HttpServlet {
    
    private NhanVienService nhanVienService = new NhanVienService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/NhanVien":
                    loadNhanVien(request, response);
                    break;
                case "/themNhanVien":
                    request.getRequestDispatcher("views/themNhanVien.jsp")
                            .forward(request, response);
                    break;
                case "/suaNhanVien":
                    showEdit(request, response);
                    break;
                case "/xoaNhanVien":
                    deleteNhanVien(request, response);
                    break;
                case "/timNhanVien":
                    searchNhanVien(request, response);
                    break;
                default:
                    loadNhanVien(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in doGet: " + e.getMessage());
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
                case "/themNhanVien":
                    insertNhanVien(request, response);
                    break;
                case "/suaNhanVien":
                    updateNhanVien(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in doPost: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Load danh sách nhân viên
    private void loadNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ArrayList<NhanVien> list = nhanVienService.getAllNhanVien();
            request.setAttribute("list", list);
            request.getRequestDispatcher("views/nhanvien.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in loadNhanVien: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Thêm nhân viên
    private void insertNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String maNV = request.getParameter("maNV");
            String hoTen = request.getParameter("hoTen");
            String gioiTinh = request.getParameter("gioiTinh");
            String ngaySimh = request.getParameter("ngaySinh");
            String sdt = request.getParameter("sdt");
            String diaChi = request.getParameter("diaChi");
            String chucVu = request.getParameter("chucVu");
            String luongStr = request.getParameter("luong");
            String trangThai = request.getParameter("trangThai");
            
            // Validation
            if (maNV == null || maNV.trim().isEmpty() || hoTen == null || hoTen.trim().isEmpty()) {
                System.err.println("[NhanVienServlet] Mã hoặc tên trống");
                response.sendRedirect("themNhanVien?error=Mã và tên không được để trống");
                return;
            }
            
            double luong = 0;
            try {
                luong = Double.parseDouble(luongStr);
                if (luong < 0) {
                    System.err.println("[NhanVienServlet] Lương âm");
                    response.sendRedirect("themNhanVien?error=Lương không được âm");
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("[NhanVienServlet] Lương không hợp lệ: " + luongStr);
                response.sendRedirect("themNhanVien?error=Lương phải là số");
                return;
            }
            
            NhanVien nv = new NhanVien();
            nv.setMaNV(maNV);
            nv.setHoTen(hoTen);
            nv.setGioiTinh(gioiTinh);
            nv.setSdt(sdt);
            nv.setDiaChi(diaChi);
            nv.setChucVu(chucVu);
            nv.setLuong(luong);
            nv.setTrangThai(trangThai);
            
            try {
                nv.setNgaySinh(java.sql.Date.valueOf(ngaySimh));
            } catch (Exception e) {
                System.err.println("[NhanVienServlet] Ngày sinh không hợp lệ: " + ngaySimh);
            }
            
            boolean success = nhanVienService.insertNhanVien(nv);
            if (success) {
                response.sendRedirect("NhanVien");
            } else {
                response.sendRedirect("themNhanVien?error=Thêm thất bại");
            }
        } catch (IllegalArgumentException e) {
            System.err.println("[NhanVienServlet] Validation error: " + e.getMessage());
            response.sendRedirect("themNhanVien?error=" + e.getMessage());
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in insertNhanVien: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Hiển form sửa
    private void showEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String maNV = request.getParameter("id");
            if (maNV == null || maNV.isEmpty()) {
                response.sendRedirect("NhanVien");
                return;
            }
            
            NhanVien nv = nhanVienService.getNhanVienById(maNV);
            if (nv != null) {
                request.setAttribute("nhanvien", nv);
                request.getRequestDispatcher("views/suaNhanVien.jsp")
                        .forward(request, response);
            } else {
                response.sendRedirect("NhanVien");
            }
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in showEdit: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Cập nhật nhân viên
    private void updateNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String maNV = request.getParameter("maNV");
            String hoTen = request.getParameter("hoTen");
            String gioiTinh = request.getParameter("gioiTinh");
            String ngaySinh = request.getParameter("ngaySinh");
            String sdt = request.getParameter("sdt");
            String diaChi = request.getParameter("diaChi");
            String chucVu = request.getParameter("chucVu");
            String luongStr = request.getParameter("luong");
            String trangThai = request.getParameter("trangThai");
            
            // Validation
            if (hoTen == null || hoTen.trim().isEmpty()) {
                System.err.println("[NhanVienServlet] Tên trống");
                response.sendRedirect("suaNhanVien?id=" + maNV + "&error=Tên không được để trống");
                return;
            }
            
            double luong = 0;
            try {
                luong = Double.parseDouble(luongStr);
                if (luong < 0) {
                    System.err.println("[NhanVienServlet] Lương âm");
                    response.sendRedirect("suaNhanVien?id=" + maNV + "&error=Lương không được âm");
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("[NhanVienServlet] Lương không hợp lệ: " + luongStr);
                response.sendRedirect("suaNhanVien?id=" + maNV + "&error=Lương phải là số");
                return;
            }
            
            NhanVien nv = new NhanVien();
            nv.setMaNV(maNV);
            nv.setHoTen(hoTen);
            nv.setGioiTinh(gioiTinh);
            nv.setSdt(sdt);
            nv.setDiaChi(diaChi);
            nv.setChucVu(chucVu);
            nv.setLuong(luong);
            nv.setTrangThai(trangThai);
            
            try {
                nv.setNgaySinh(java.sql.Date.valueOf(ngaySinh));
            } catch (Exception e) {
                System.err.println("[NhanVienServlet] Ngày sinh không hợp lệ: " + ngaySinh);
            }
            
            boolean success = nhanVienService.updateNhanVien(nv);
            if (success) {
                response.sendRedirect("NhanVien");
            } else {
                response.sendRedirect("suaNhanVien?id=" + maNV + "&error=Cập nhật thất bại");
            }
        } catch (IllegalArgumentException e) {
            System.err.println("[NhanVienServlet] Validation error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in updateNhanVien: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Xóa nhân viên
    private void deleteNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String maNV = request.getParameter("id");
            if (maNV == null || maNV.isEmpty()) {
                response.sendRedirect("NhanVien");
                return;
            }
            
            boolean success = nhanVienService.deleteNhanVien(maNV);
            if (success) {
                System.out.println("[NhanVienServlet] Employee deleted: " + maNV);
            } else {
                System.err.println("[NhanVienServlet] Failed to delete employee: " + maNV);
            }
            response.sendRedirect("NhanVien");
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in deleteNhanVien: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Tìm kiếm nhân viên
    private void searchNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            if (keyword == null || keyword.trim().isEmpty()) {
                response.sendRedirect("NhanVien");
                return;
            }
            
            ArrayList<NhanVien> list = nhanVienService.searchNhanVien(keyword);
            request.setAttribute("list", list);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("views/nhanvien.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            System.err.println("[NhanVienServlet] Error in searchNhanVien: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
