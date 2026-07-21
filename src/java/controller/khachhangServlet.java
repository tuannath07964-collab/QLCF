package controller;

import dao.KhachHangDAO;
import model.KhachHang;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/khachhang")
public class khachhangServlet extends HttpServlet {

    private KhachHangDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new KhachHangDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: Đã vào được Servlet KhachHang!");
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "loadForm":
                    loadForm(request, response);
                    break;
                case "add":
                    insertKhachHang(request, response);
                    break;
                case "edit":
                    updateKhachHang(request, response);
                    break;
                case "delete":
                    deleteKhachHang(request, response);
                    break;
                default:
                    listKhachHang(request, response);
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
        doGet(request, response);
    }

    private void listKhachHang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<KhachHang> listKH = (ArrayList<KhachHang>) dao.getAllKhachHang();
        request.setAttribute("listKH", listKH);
        request.getRequestDispatcher("/views/khachhang.jsp").forward(request, response);
    }

    private void loadForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    java.util.ArrayList<String> listGiamGia = new java.util.ArrayList<>();
    listGiamGia.add("GIAM10");
    listGiamGia.add("VIP20");
    listGiamGia.add("KM30");
    request.setAttribute("listGiamGia", listGiamGia);
    String maKH = request.getParameter("maKH");
    if (maKH != null && !maKH.trim().isEmpty()) {
        KhachHang kh = dao.getKhachHangById(maKH);
        request.setAttribute("kh", kh);
        request.setAttribute("mode", "edit");
    } else {
        request.setAttribute("mode", "add");
    }
    request.getRequestDispatcher("/views/khachhang1.jsp").forward(request, response);
}

    private void insertKhachHang(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        KhachHang kh = buildKhachHangFromRequest(request);
        dao.insertKhachHang(kh);
        response.sendRedirect(request.getContextPath() + "/khachhang?action=list");
    }

    private void updateKhachHang(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        KhachHang kh = buildKhachHangFromRequest(request);
        dao.updateKhachHang(kh);
        response.sendRedirect(request.getContextPath() + "/khachhang?action=list");
    }

    private void deleteKhachHang(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String maKH = request.getParameter("maKH");
        if (maKH != null) {
            dao.deleteKhachHang(maKH);
        }
        response.sendRedirect(request.getContextPath() + "/khachhang?action=list");
    }

    private KhachHang buildKhachHangFromRequest(HttpServletRequest request) {
        KhachHang kh = new KhachHang();
        kh.setMaKH(request.getParameter("maKH"));
        kh.setHoTen(request.getParameter("hoTen"));
        kh.setSdt(request.getParameter("sdt"));
        kh.setMaGiamGia(request.getParameter("maGiamGia"));
        return kh;
    }
}