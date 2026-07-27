package controller;

import dao.khoDAO;
import model.NguyenLieu;

import java.io.IOException;
import java.util.ArrayList;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/KhoServlet")
public class khoServlet extends HttpServlet {

    private khoDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new khoDAO();
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
                    break;
                case "add":
                    insertNguyenLieu(request, response);
                    break;
                case "edit":
                    updateNguyenLieu(request, response);
                    break;
                case "delete":
                    deleteNguyenLieu(request, response);
                    break;
                default:
                    listKho(request, response);
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

    private void listKho(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("maNV") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        ArrayList<NguyenLieu> dsKho = dao.getAllNguyenLieu();
        request.setAttribute("dsKho", dsKho);
        request.getRequestDispatcher("/views/kho.jsp").forward(request, response);
    }

    private void loadForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String maNL = request.getParameter("maNL");
        if (maNL != null && !maNL.trim().isEmpty()) {
            NguyenLieu nl = dao.getNguyenLieuById(maNL);
            request.setAttribute("nl", nl);
            request.setAttribute("mode", "edit");
        } else {
            request.setAttribute("mode", "add");
        }
        request.setAttribute("showModal", true);
        ArrayList<NguyenLieu> dsKho = dao.getAllNguyenLieu();
        request.setAttribute("dsKho", dsKho);
        request.getRequestDispatcher("/views/kho.jsp").forward(request, response);
    }

    private void insertNguyenLieu(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        NguyenLieu nl = buildNguyenLieuFromRequest(request);
        dao.insertNguyenLieu(nl);
        response.sendRedirect(request.getContextPath() + "/KhoServlet?action=list");
    }

    private void updateNguyenLieu(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        NguyenLieu nl = buildNguyenLieuFromRequest(request);
        dao.updateNguyenLieu(nl);
        response.sendRedirect(request.getContextPath() + "/KhoServlet?action=list");
    }

    private void deleteNguyenLieu(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String maNL = request.getParameter("maNL");
        if (maNL != null) {
            dao.deleteNguyenLieu(maNL);
        }
        response.sendRedirect(request.getContextPath() + "/KhoServlet?action=list");
    }

    private NguyenLieu buildNguyenLieuFromRequest(HttpServletRequest request) {
        NguyenLieu nl = new NguyenLieu();
        nl.setMaNL(request.getParameter("maNL"));
        nl.setTenNL(request.getParameter("tenNL"));

        String soLuongStr = request.getParameter("soLuong");
        if (soLuongStr != null && !soLuongStr.trim().isEmpty()) {
            nl.setSoLuong(
                    new BigDecimal(soLuongStr)
            );

            nl.setDonVi(request.getParameter("donVi"));
            return nl;
        }
        return null;
    }
}
