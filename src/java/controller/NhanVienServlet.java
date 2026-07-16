package controller;

import dao.NhanVienDAO;
import model.NhanVien;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/nhanvien")
public class NhanVienServlet extends HttpServlet {

    private NhanVienDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new NhanVienDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        try {

            switch (action) {

                case "add":
                    insertNhanVien(request, response);
                    break;

                case "edit":
                    updateNhanVien(request, response);
                    break;

                case "delete":
                    deleteNhanVien(request, response);
                    break;

                case "search":
                    searchNhanVien(request, response);
                    break;

                default:
                    listNhanVien(request, response);
                    break;
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        doGet(request, response);

    }

    // ==========================
    // Danh sách nhân viên
    // ==========================
    private void listNhanVien(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("maNV") == null) { // Kiểm tra key "maNV" đã được lưu ở LoginServlet
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        ArrayList<NhanVien> listNV = dao.getAllNhanVien();

        request.setAttribute("listNV", listNV);

        request.getRequestDispatcher("/views/nhanvien.jsp")
                .forward(request, response);

    }

    // ==========================
    // Thêm nhân viên
    // ==========================
    private void insertNhanVien(HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        NhanVien nv = new NhanVien();

        nv.setMaNV(request.getParameter("maNV"));
        nv.setHoTen(request.getParameter("hoTen"));
        nv.setGioiTinh(request.getParameter("gioiTinh"));
        nv.setNgaySinh(Date.valueOf(request.getParameter("ngaySinh")));
        nv.setSdt(request.getParameter("sdt"));
        nv.setDiaChi(request.getParameter("diaChi"));
        nv.setChucVu(request.getParameter("chucVu"));
        nv.setLuong(Double.parseDouble(request.getParameter("luong")));
        nv.setTrangThai(request.getParameter("trangThai"));

        dao.insertNhanVien(nv);

        response.sendRedirect(request.getContextPath() + "/nhanvien");

    }

    // ==========================
    // Cập nhật nhân viên
    // ==========================
    private void updateNhanVien(HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        NhanVien nv = new NhanVien();

        nv.setMaNV(request.getParameter("maNV"));
        nv.setHoTen(request.getParameter("hoTen"));
        nv.setGioiTinh(request.getParameter("gioiTinh"));
        nv.setNgaySinh(Date.valueOf(request.getParameter("ngaySinh")));
        nv.setSdt(request.getParameter("sdt"));
        nv.setDiaChi(request.getParameter("diaChi"));
        nv.setChucVu(request.getParameter("chucVu"));
        nv.setLuong(Double.parseDouble(request.getParameter("luong")));
        nv.setTrangThai(request.getParameter("trangThai"));

        dao.updateNhanVien(nv);

        response.sendRedirect(request.getContextPath() + "/nhanvien");

    }

    // ==========================
    // Xóa nhân viên
    // ==========================
    private void deleteNhanVien(HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String maNV = request.getParameter("maNV");

        dao.deleteNhanVien(maNV);

        response.sendRedirect(request.getContextPath() + "/nhanvien");

    }

    // ==========================
    // Tìm kiếm nhân viên
    // ==========================
    private void searchNhanVien(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        if (keyword == null) {
            keyword = "";
        }

        ArrayList<NhanVien> listNV = dao.searchNhanVien(keyword);

        request.setAttribute("listNV", listNV);

        request.getRequestDispatcher("/views/nhanvien.jsp")
                .forward(request, response);

    }

}
