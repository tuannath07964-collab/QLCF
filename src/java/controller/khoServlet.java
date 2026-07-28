package controller;

import dao.khoDAO;
import model.NguyenLieu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;

@WebServlet("/KhoServlet")
public class khoServlet
        extends HttpServlet {

    private khoDAO dao;

    @Override
    public void init()
            throws ServletException {

        dao = new khoDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (!daDangNhap(request, response)) {
            return;
        }

        String action =
                request.getParameter(
                        "action"
                );

        if (
            action == null
            || action.isBlank()
        ) {
            action = "list";
        }

        try {
            switch (action) {

                case "loadForm" ->
                    loadForm(
                            request,
                            response
                    );

                default ->
                    listKho(
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

            listKho(
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

        if (!daDangNhap(request, response)) {
            return;
        }

        String action =
                request.getParameter(
                        "action"
                );

        try {
            if ("edit".equals(action)) {
                updateNguyenLieu(
                        request,
                        response
                );

            } else if ("add".equals(action)) {
                insertNguyenLieu(
                        request,
                        response
                );

            } else {
                response.sendRedirect(
                        request.getContextPath()
                        + "/KhoServlet"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            loadForm(
                    request,
                    response
            );
        }
    }

    private void listKho(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        ArrayList<NguyenLieu> dsKho =
                dao.getAllNguyenLieu();

        request.setAttribute(
                "dsKho",
                dsKho
        );

        request.getRequestDispatcher(
                "/views/kho.jsp"
        ).forward(request, response);
    }

    private void loadForm(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String maNL =
                trimToNull(
                        request.getParameter(
                                "maNL"
                        )
                );

        if (maNL != null) {
            NguyenLieu nl =
                    dao.getNguyenLieuById(
                            maNL
                    );

            if (nl == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy nguyên liệu."
                );
            }

            request.setAttribute(
                    "nl",
                    nl
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

        request.setAttribute(
                "showModal",
                true
        );

        request.setAttribute(
                "dsKho",
                dao.getAllNguyenLieu()
        );

        request.getRequestDispatcher(
                "/views/kho.jsp"
        ).forward(request, response);
    }

    private void insertNguyenLieu(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        NguyenLieu nl =
                buildNguyenLieuFromRequest(
                        request
                );

        if (!dao.insertNguyenLieu(nl)) {
            throw new IllegalStateException(
                    "Không thêm được nguyên liệu."
            );
        }

        response.sendRedirect(
                request.getContextPath()
                + "/KhoServlet?success=add"
        );
    }

    private void updateNguyenLieu(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        NguyenLieu nl =
                buildNguyenLieuFromRequest(
                        request
                );

        if (!dao.updateNguyenLieu(nl)) {
            throw new IllegalStateException(
                    "Không cập nhật được nguyên liệu."
            );
        }

        response.sendRedirect(
                request.getContextPath()
                + "/KhoServlet?success=edit"
        );
    }

    private NguyenLieu buildNguyenLieuFromRequest(
            HttpServletRequest request
    ) {
        NguyenLieu nl =
                new NguyenLieu();

        String maNL =
                trimToNull(
                        request.getParameter(
                                "maNL"
                        )
                );

        String tenNL =
                trimToNull(
                        request.getParameter(
                                "tenNL"
                        )
                );

        String soLuong =
                trimToNull(
                        request.getParameter(
                                "soLuong"
                        )
                );

        String donVi =
                trimToNull(
                        request.getParameter(
                                "donVi"
                        )
                );

        if (maNL == null) {
            throw new IllegalArgumentException(
                    "Mã nguyên liệu là bắt buộc."
            );
        }

        if (tenNL == null) {
            throw new IllegalArgumentException(
                    "Tên nguyên liệu là bắt buộc."
            );
        }

        if (soLuong == null) {
            throw new IllegalArgumentException(
                    "Số lượng là bắt buộc."
            );
        }

        if (donVi == null) {
            throw new IllegalArgumentException(
                    "Đơn vị tính là bắt buộc."
            );
        }

        BigDecimal soLuongValue;

        try {
            soLuongValue =
                    new BigDecimal(soLuong);

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Số lượng nguyên liệu không hợp lệ."
            );
        }

        if (
            soLuongValue.compareTo(
                    BigDecimal.ZERO
            ) < 0
        ) {
            throw new IllegalArgumentException(
                    "Số lượng nguyên liệu không được âm."
            );
        }

        nl.setMaNL(maNL);
        nl.setTenNL(tenNL);
        nl.setSoLuong(soLuongValue);
        nl.setDonVi(donVi);

        return nl;
    }

    private boolean daDangNhap(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        HttpSession session =
                request.getSession(false);

        if (
            session == null
            || session.getAttribute(
                    "maNV"
            ) == null
        ) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/LoginServlet"
            );

            return false;
        }

        return true;
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