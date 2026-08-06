package controller;

import dao.DanhMucSanPhamDAO;
import dao.MaTuDongDAO;

import model.DanhMucSanPham;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/danh-muc-san-pham")
public class DanhMucSanPhamServlet
        extends HttpServlet {

    private DanhMucSanPhamDAO dao;
    private MaTuDongDAO maTuDongDAO;

    @Override
    public void init()
            throws ServletException {

        dao =
                new DanhMucSanPhamDAO();

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
            if ("edit".equals(action)) {
                String id =
                        request.getParameter(
                                "id"
                        );

                DanhMucSanPham danhMuc =
                        dao.findById(id);

                if (danhMuc == null) {
                    throw new IllegalArgumentException(
                            "Không tìm thấy danh mục."
                    );
                }

                request.setAttribute(
                        "danhMucFormEdit",
                        true
                );

                request.setAttribute(
                        "danhMucEdit",
                        danhMuc
                );

                request.setAttribute(
                        "showDanhMucModal",
                        true
                );
            }

            if ("add".equals(action)) {
                DanhMucSanPham danhMuc =
                        new DanhMucSanPham();

                danhMuc.setMaDanhMuc(
                        maTuDongDAO
                                .taoMaDanhMuc()
                );

                danhMuc.setTrangThai(
                        true
                );

                request.setAttribute(
                        "danhMucFormEdit",
                        false
                );

                request.setAttribute(
                        "danhMucEdit",
                        danhMuc
                );

                request.setAttribute(
                        "showDanhMucModal",
                        true
                );
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

        if ("toggle".equals(action)) {
            handleToggle(
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

    private void handleToggle(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
            dao.toggleStatus(
                    request.getParameter(
                            "id"
                    )
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/danh-muc-san-pham"
                    + "?success=toggle"
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

        DanhMucSanPham danhMuc =
                new DanhMucSanPham();

        try {
            danhMuc.setMaDanhMuc(
                    edit
                    ? trim(
                            request.getParameter(
                                    "maDanhMuc"
                            )
                    )
                    : maTuDongDAO
                            .taoMaDanhMuc()
            );

            danhMuc.setTenDanhMuc(
                    trim(
                            request.getParameter(
                                    "tenDanhMuc"
                            )
                    )
            );

            danhMuc.setTrangThai(
                    request.getParameter(
                            "trangThai"
                    ) != null
            );

            if (edit) {
                dao.update(
                        danhMuc
                );

            } else {
                dao.insert(
                        danhMuc
                );
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/danh-muc-san-pham"
                    + "?success=save"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            request.setAttribute(
                    "danhMucFormEdit",
                    edit
            );

            request.setAttribute(
                    "danhMucEdit",
                    danhMuc
            );

            request.setAttribute(
                    "showDanhMucModal",
                    true
            );

            loadPage(
                    request,
                    response
            );
        }
    }

    private void loadPage(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "danhMucList",
                dao.getAll()
        );

        request.getRequestDispatcher(
                "/views/danhmucsanpham.jsp"
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
            return "Đã xảy ra lỗi khi xử lý danh mục.";
        }

        return exception.getMessage();
    }
}