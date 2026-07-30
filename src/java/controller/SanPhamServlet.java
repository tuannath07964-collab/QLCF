package controller;

import dao.DanhMucSanPhamDAO;
import dao.SanPhamDAO;
import dao.khoDAO;

import model.SanPham;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(
        urlPatterns = {
            "/san-pham/quan-ly",
            "/san-pham/danh-sach"
        }
)
public class SanPhamServlet
        extends HttpServlet {

    private SanPhamDAO sanPhamDAO;
    private DanhMucSanPhamDAO danhMucDAO;
    private khoDAO nguyenLieuDAO;

    @Override
    public void init()
            throws ServletException {

        sanPhamDAO =
                new SanPhamDAO();

        danhMucDAO =
                new DanhMucSanPhamDAO();

        nguyenLieuDAO =
                new khoDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        if (!checkLogin(request, response)) {
            return;
        }

        if (
            "/san-pham/danh-sach"
                .equals(
                    request.getServletPath()
                )
        ) {
            loadDanhSach(
                    request,
                    response
            );

            return;
        }

        String action =
                request.getParameter(
                        "action"
                );

        try {
            if ("form".equals(action)) {
                String id =
                        request.getParameter(
                                "id"
                        );

                if (
                    id != null
                    && !id.isBlank()
                ) {
                    request.setAttribute(
                            "sanPhamEdit",
                            sanPhamDAO
                                .findById(id)
                    );
                }

                request.setAttribute(
                        "showSanPhamModal",
                        true
                );
            }

            if ("recipe".equals(action)) {
                String id =
                        request.getParameter(
                                "id"
                        );

                SanPham sanPham =
                        sanPhamDAO.findById(id);

                if (sanPham == null) {
                    throw new IllegalArgumentException(
                            "Không tìm thấy sản phẩm."
                    );
                }

                request.setAttribute(
                        "sanPhamCongThuc",
                        sanPham
                );

                request.setAttribute(
                        "congThucMap",
                        sanPhamDAO
                            .getCongThucMap(id)
                );

                request.setAttribute(
                        "nguyenLieuList",
                        nguyenLieuDAO.getAll()
                );

                request.setAttribute(
                        "showCongThucModal",
                        true
                );
            }

            loadQuanLy(
                    request,
                    response
            );

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            loadQuanLy(
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
                sanPhamDAO.toggleStatus(
                        request.getParameter(
                                "id"
                        )
                );

                redirectSuccess(
                        request,
                        response,
                        "toggle"
                );

                return;
            }

            if ("recipe".equals(action)) {
                sanPhamDAO.saveCongThuc(
                        request.getParameter(
                                "maSanPham"
                        ),
                        request.getParameterValues(
                                "maNguyenLieu"
                        ),
                        request.getParameterValues(
                                "soLuongCan"
                        )
                );

                redirectSuccess(
                        request,
                        response,
                        "recipe"
                );

                return;
            }

            SanPham sanPham =
                    new SanPham();

            sanPham.setMaSanPham(
                    request.getParameter(
                            "maSanPham"
                    )
            );

            sanPham.setTenSanPham(
                    request.getParameter(
                            "tenSanPham"
                    )
            );

            sanPham.setMaDanhMuc(
                    request.getParameter(
                            "maDanhMuc"
                    )
            );

            try {
                sanPham.setGiaBan(
                        new BigDecimal(
                            request.getParameter(
                                "giaBan"
                            )
                        )
                );

            } catch (Exception e) {
                throw new IllegalArgumentException(
                        "Giá sản phẩm không hợp lệ."
                );
            }

            sanPham.setTrangThai(
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
                sanPhamDAO.update(
                        sanPham
                );

            } else {
                sanPhamDAO.insert(
                        sanPham
                );
            }

            redirectSuccess(
                    request,
                    response,
                    "save"
            );

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    e.getMessage()
            );

            loadQuanLy(
                    request,
                    response
            );
        }
    }

    private void loadQuanLy(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String keyword =
                request.getParameter(
                        "keyword"
                );

        String maDanhMuc =
                request.getParameter(
                        "maDanhMuc"
                );

        request.setAttribute(
                "sanPhamList",
                sanPhamDAO.getAll(
                        keyword,
                        maDanhMuc,
                        true
                )
        );

        request.setAttribute(
                "danhMucList",
                danhMucDAO.getAll()
        );

        request.getRequestDispatcher(
                "/views/quanlysanpham.jsp"
        ).forward(
                request,
                response
        );
    }

    private void loadDanhSach(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setAttribute(
                "sanPhamList",
                sanPhamDAO.getAll(
                        request.getParameter(
                                "keyword"
                        ),
                        request.getParameter(
                                "maDanhMuc"
                        ),
                        false
                )
        );

        request.setAttribute(
                "danhMucList",
                danhMucDAO
                    .getDangHoatDong()
        );

        request.getRequestDispatcher(
                "/views/danhsachsanpham.jsp"
        ).forward(
                request,
                response
        );
    }

    private void redirectSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            String type
    ) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/san-pham/quan-ly"
                + "?success="
                + type
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