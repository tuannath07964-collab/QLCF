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

@WebServlet("/NhanVienServlet")
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

        if (action == null) {
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

        doGet(request, response);

    }

    // ==========================
    // Hiển thị danh sách
    // ==========================
    private void listNhanVien(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        ArrayList<NhanVien> list = dao.getAllNhanVien();

        request.setAttribute("listNV", list);

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

        response.sendRedirect("NhanVienServlet");

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

        response.sendRedirect("NhanVienServlet");

    }

    // ==========================
    // Xóa nhân viên
    // ==========================
    private void deleteNhanVien(HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

        String maNV = request.getParameter("maNV");

        dao.deleteNhanVien(maNV);

        response.sendRedirect("NhanVienServlet");

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

        ArrayList<NhanVien> list = dao.searchNhanVien(keyword);

        request.setAttribute("listNV", list);

        request.getRequestDispatcher("/views/nhanvien.jsp")
                .forward(request, response);

    }

}