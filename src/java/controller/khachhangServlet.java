package controller;

import dao.KhachHangDAO;
import model.KhachHang;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/khachhang")
public class khachhangServlet
        extends HttpServlet {

    private KhachHangDAO dao;

    @Override
    public void init()
            throws ServletException {

        dao = new KhachHangDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action =
                request.getParameter("action");

        if (action == null
                || action.isBlank()) {
            action = "list";
        }

        try {
            switch (action) {
                case "loadForm" ->
                    loadForm(request, response);

                case "delete" ->
                    deleteKhachHang(
                            request,
                            response
                    );

                default ->
                    listKhachHang(
                            request,
                            response
                    );
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            listKhachHang(
                    request,
                    response
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action =
                request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                updateKhachHang(
                        request,
                        response
                );
            } else {
                insertKhachHang(
                        request,
                        response
                );
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            loadForm(request, response);
        }
    }

    private void listKhachHang(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "listKH",
                dao.getAllKhachHang()
        );

        request.getRequestDispatcher(
                "/views/khachhang.jsp"
        ).forward(request, response);
    }

    private void loadForm(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String maKH = trimToNull(
                request.getParameter("maKH")
        );

        if (maKH != null) {
            request.setAttribute(
                    "kh",
                    dao.getKhachHangById(maKH)
            );

            request.setAttribute(
                    "mode",
                    "edit"
            );
        } else {
            request.setAttribute(
                    "mode",
                    "add"
            );
        }

        request.getRequestDispatcher(
                "/views/khachhang1.jsp"
        ).forward(request, response);
    }

    private void insertKhachHang(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        dao.insertKhachHang(
                buildKhachHangFromRequest(
                        request
                )
        );

        response.sendRedirect(
                request.getContextPath()
                + "/khachhang?success=add"
        );
    }

    private void updateKhachHang(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        dao.updateKhachHang(
                buildKhachHangFromRequest(
                        request
                )
        );

        response.sendRedirect(
                request.getContextPath()
                + "/khachhang?success=edit"
        );
    }

    private void deleteKhachHang(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        String maKH = trimToNull(
                request.getParameter("maKH")
        );

        if (maKH != null) {
            dao.deleteKhachHang(maKH);
        }

        response.sendRedirect(
                request.getContextPath()
                + "/khachhang?success=delete"
        );
    }

    private KhachHang
            buildKhachHangFromRequest(
                    HttpServletRequest request
            ) {

        KhachHang kh =
                new KhachHang();

        kh.setMaKH(
                trimToNull(
                    request.getParameter("maKH")
                )
        );

        kh.setHoTen(
                trimToNull(
                    request.getParameter("hoTen")
                )
        );

        kh.setSdt(
                trimToNull(
                    request.getParameter("sdt")
                )
        );

        return kh;
    }

    private String trimToNull(
            String value
    ) {
        return value == null
                || value.isBlank()
                ? null
                : value.trim();
    }
}