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
import java.math.BigDecimal;

@WebServlet("/nhanvien")
public class NhanVienServlet extends HttpServlet {

    private NhanVienDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new NhanVienDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "loadForm":
                    loadForm(request, response);
                    break; // Mở form Thêm/Sửa
                case "loadCa":
                    loadCaForm(request, response);
                    break;
                case "updateCa":
                    try {
                        updateCa(request, response);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    break;
                case "add":
                    insertNhanVien(request, response);
                    break;
                case "edit":
                    updateNhanVien(request, response);
                    break;
                case "delete":
                    deleteNhanVien(request, response);
                    break;
                default:
                    listNhanVien(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy action từ input hidden trong form
        String action = request.getParameter("action");

        if ("updateCa".equals(action)) {
            try {
                updateCa(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Lỗi khi cập nhật ca làm: " + e.getMessage());
            }
        } else {
            doGet(request, response);
        }
    }

    private void loadForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maNV = request.getParameter("maNV");
        if (maNV != null && !maNV.trim().isEmpty()) {
            NhanVien nv = dao.getNhanVienById(maNV);
            request.setAttribute("nv", nv);
            request.setAttribute("mode", "edit");
        } else {
            request.setAttribute("mode", "add");
        }
        request.getRequestDispatcher("/views/nhanvien1.jsp").forward(request, response);
    }

    private void listNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("maNV") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        ArrayList<NhanVien> listNV = dao.getAllNhanVien();
        request.setAttribute("listNV", listNV);
        request.getRequestDispatcher("/views/nhanvien.jsp").forward(request, response);
    }

    private void insertNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        NhanVien nv = buildNhanVienFromRequest(request);

        // Đảm bảo khi thêm mới nếu không nhập mật khẩu thì gán mặc định
        if (nv.getMatKhau() == null || nv.getMatKhau().trim().isEmpty()) {
            nv.setMatKhau("123456");
        }

        dao.insertNhanVien(nv);
        response.sendRedirect(request.getContextPath() + "/nhanvien?action=list");
    }

    private void updateNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        NhanVien nv = buildNhanVienFromRequest(request);

        // Nếu form gửi lên mật khẩu trống, giữ lại mật khẩu cũ trong database để không bị NULL
        if (nv.getMatKhau() == null || nv.getMatKhau().trim().isEmpty()) {
            NhanVien nvOld = dao.getNhanVienById(nv.getMaNV());
            if (nvOld != null) {
                nv.setMatKhau(nvOld.getMatKhau());
            }
        }

        dao.updateNhanVien(nv);
        response.sendRedirect(request.getContextPath() + "/nhanvien?action=list");
    }

    private void deleteNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String maNV = request.getParameter("maNV");
        if (maNV != null) {
            dao.deleteNhanVien(maNV);
        }
        response.sendRedirect(request.getContextPath() + "/nhanvien?action=list");
    }

    private void loadCaForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maNV = request.getParameter("maNV");
        NhanVien nv = dao.getNhanVienById(maNV);
        request.setAttribute("nv", nv);
        request.getRequestDispatcher("/views/nhanvien2.jsp").forward(request, response);
    }

    private void updateCa(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String maNV = request.getParameter("maNV");

        boolean caSang = request.getParameter("caSang") != null;
        boolean caChieu = request.getParameter("caChieu") != null;
        boolean caToi = request.getParameter("caToi") != null;

        String gioBatDau = request.getParameter("gioBatDau");
        String gioKetThuc = request.getParameter("gioKetThuc");

        dao.updateCaLam(maNV, caSang, caChieu, caToi, gioBatDau, gioKetThuc);

        response.sendRedirect(request.getContextPath() + "/nhanvien");
    }

    private NhanVien buildNhanVienFromRequest(HttpServletRequest request) {
        NhanVien nv = new NhanVien();
        nv.setMaNV(request.getParameter("maNV"));
        nv.setHoTen(request.getParameter("hoTen"));

        // Đã bổ sung đọc trường mật khẩu từ form gửi lên
        nv.setMatKhau(request.getParameter("matKhau"));

        nv.setGioiTinh(request.getParameter("gioiTinh"));
        nv.setSdt(request.getParameter("sdt"));
        nv.setChucVu(request.getParameter("chucVu"));
        nv.setCaSang(request.getParameter("caSang") != null);
        nv.setCaChieu(request.getParameter("caChieu") != null);
        nv.setCaToi(request.getParameter("caToi") != null);
        nv.setGioBatDau(request.getParameter("gioBatDau"));
        nv.setGioKetThuc(request.getParameter("gioKetThuc"));

        String ns = request.getParameter("ngaySinh");
        if (ns != null && !ns.trim().isEmpty()) {
            nv.setNgaySinh(Date.valueOf(ns));
        }
        String luong = request.getParameter("luongCoBan");
        if (luong != null && !luong.trim().isEmpty()) {
            nv.setLuongCoBan(new BigDecimal(luong));
        }

        return nv;
    }
}
