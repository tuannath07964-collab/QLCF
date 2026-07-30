package controller;

import dao.DanhMucSanPhamDAO;
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

    @Override
    public void init()
            throws ServletException {

        dao = new DanhMucSanPhamDAO();
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

                request.setAttribute(
                        "danhMucEdit",
                        dao.findById(id)
                );

                request.setAttribute(
                        "showDanhMucModal",
                        true
                );
            }

            if ("add".equals(action)) {
                request.setAttribute(
                        "showDanhMucModal",
                        true
                );
            }

            loadPage(
                    request,
                    response
            );

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
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

        try {
            if ("toggle".equals(action)) {
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

                return;
            }

            DanhMucSanPham danhMuc =
                    new DanhMucSanPham();

            danhMuc.setMaDanhMuc(
                    request.getParameter(
                            "maDanhMuc"
                    )
            );

            danhMuc.setTenDanhMuc(
                    request.getParameter(
                            "tenDanhMuc"
                    )
            );

            danhMuc.setTrangThai(
                    request.getParameter(
                            "trangThai"
                    ) != null
            );

            boolean edit =
                    "edit".equals(
                            request.getParameter(
                                    "mode"
                            )
                    );

            if (edit) {
                dao.update(danhMuc);

            } else {
                dao.insert(danhMuc);
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/danh-muc-san-pham"
                    + "?success=save"
            );

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
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
}