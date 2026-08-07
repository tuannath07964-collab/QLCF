package controller;

import dao.MaTuDongDAO;
import dao.khoDAO;

import model.NguyenLieu;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/KhoServlet")
public class khoServlet
        extends HttpServlet {

    private khoDAO dao;
    private MaTuDongDAO maTuDongDAO;

    @Override
    public void init()
            throws ServletException {

        dao =
                new khoDAO();

        maTuDongDAO =
                new MaTuDongDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!checkLogin(request, response)) {
            return;
        }

        String action =
                request.getParameter(
                        "action"
                );

        try {
            if ("form".equals(action)) {
                prepareForm(request);
            }

            loadPage(
                    request,
                    response
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            loadPage(
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

        request.setCharacterEncoding(
                "UTF-8"
        );

        if (!checkLogin(request, response)) {
            return;
        }

        String action =
                request.getParameter(
                        "action"
                );

        if ("restock".equals(action)) {
            handleRestock(
                    request,
                    response
            );

            return;
        }

        handleSave(
                request,
                response
        );
    }

    private void prepareForm(
            HttpServletRequest request
    ) {
        String id =
                request.getParameter(
                        "id"
                );

        boolean edit =
                id != null
                && !id.isBlank();

        NguyenLieu nguyenLieu;

        if (edit) {
            nguyenLieu =
                    dao.findById(id);

            if (nguyenLieu == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy nguyên liệu."
                );
            }

        } else {
            nguyenLieu =
                    new NguyenLieu();

            nguyenLieu.setMaNguyenLieu(
                    maTuDongDAO
                            .taoMaNguyenLieu()
            );

            nguyenLieu.setSoLuongTon(
                    0
            );

            nguyenLieu.setMucNhapCoDinh(
                    100
            );

            nguyenLieu.setDonVi(
                    "g"
            );

            nguyenLieu.setTrangThai(
                    true
            );
        }

        request.setAttribute(
                "nguyenLieuFormEdit",
                edit
        );

        request.setAttribute(
                "nguyenLieuEdit",
                nguyenLieu
        );

        request.setAttribute(
                "showKhoModal",
                true
        );
    }

    private void handleRestock(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            dao.nhapKhoCoDinh(
                    request.getParameter(
                            "id"
                    )
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/KhoServlet?success=restock"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            loadPage(
                    request,
                    response
            );
        }
    }

    private void handleSave(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        boolean edit =
                "edit".equals(
                        request.getParameter(
                                "mode"
                        )
                );

        NguyenLieu nguyenLieu =
                new NguyenLieu();

        try {
            nguyenLieu.setMaNguyenLieu(
                    edit
                    ? trim(
                            request.getParameter(
                                    "maNguyenLieu"
                            )
                    )
                    : maTuDongDAO
                            .taoMaNguyenLieu()
            );

            nguyenLieu.setTenNguyenLieu(
                    trim(
                            request.getParameter(
                                    "tenNguyenLieu"
                            )
                    )
            );

            nguyenLieu.setDonVi(
                    trim(
                            request.getParameter(
                                    "donVi"
                            )
                    )
            );

            nguyenLieu.setSoLuongTon(
                    parseInteger(
                            request.getParameter(
                                    "soLuongTon"
                            ),
                            "Số lượng tồn không hợp lệ."
                    )
            );

            nguyenLieu.setMucNhapCoDinh(
                    parseInteger(
                            request.getParameter(
                                    "mucNhapCoDinh"
                            ),
                            "Mức nhập cố định không hợp lệ."
                    )
            );

            nguyenLieu.setTrangThai(
                    request.getParameter(
                            "trangThai"
                    ) != null
            );

            if (edit) {
                dao.update(
                        nguyenLieu
                );

            } else {
                dao.insert(
                        nguyenLieu
                );
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/KhoServlet?success=save"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            request.setAttribute(
                    "nguyenLieuFormEdit",
                    edit
            );

            request.setAttribute(
                    "nguyenLieuEdit",
                    nguyenLieu
            );

            request.setAttribute(
                    "showKhoModal",
                    true
            );

            loadPage(
                    request,
                    response
            );
        }
    }

    private int parseInteger(
            String value,
            String errorMessage
    ) {
        try {
            return Integer.parseInt(
                    value
            );

        } catch (Exception exception) {
            throw new IllegalArgumentException(
                    errorMessage
            );
        }
    }

    private void loadPage(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "nguyenLieuList",
                dao.getAll()
        );

        request.setAttribute(
                "donViList",
                dao.getDonViChoPhep()
        );

        request.getRequestDispatcher(
                "/views/kho.jsp"
        ).forward(
                request,
                response
        );
    }

    private boolean checkLogin(
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

    private String trim(
            String value
    ) {
        return value == null
                ? null
                : value.trim();
    }

    private String getErrorMessage(
            Exception exception
    ) {
        if (
                exception.getMessage() == null
                || exception.getMessage().isBlank()
        ) {
            return "Đã xảy ra lỗi khi xử lý kho nguyên liệu.";
        }

        return exception.getMessage();
    }
}