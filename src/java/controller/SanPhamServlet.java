package controller;

import dao.DanhMucSanPhamDAO;
import dao.MaTuDongDAO;
import dao.SanPhamDAO;
import dao.khoDAO;

import model.SanPham;

import util.SanPhamImageUtil;

import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.awt.image.BufferedImage;

import java.io.IOException;

import java.math.BigDecimal;

import java.util.List;

@WebServlet(
        urlPatterns = {
            "/san-pham/quan-ly",
            "/san-pham/danh-sach"
        }
)
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class SanPhamServlet
        extends HttpServlet {

    private SanPhamDAO sanPhamDAO;
    private DanhMucSanPhamDAO danhMucDAO;
    private khoDAO nguyenLieuDAO;
    private MaTuDongDAO maTuDongDAO;
    private SanPhamImageUtil imageUtil;

    @Override
    public void init()
            throws ServletException {

        sanPhamDAO =
                new SanPhamDAO();

        danhMucDAO =
                new DanhMucSanPhamDAO();

        nguyenLieuDAO =
                new khoDAO();

        maTuDongDAO =
                new MaTuDongDAO();

        imageUtil =
                new SanPhamImageUtil(
                        getServletContext()
                );
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
                "/san-pham/danh-sach".equals(
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
                prepareProductForm(
                        request
                );
            }

            if ("recipe".equals(action)) {
                prepareRecipeForm(
                        request
                );
            }

            loadQuanLy(
                    request,
                    response
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
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

        if ("toggle".equals(action)) {
            toggleStatus(
                    request,
                    response
            );

            return;
        }

        if ("recipe".equals(action)) {
            saveRecipe(
                    request,
                    response
            );

            return;
        }

        saveProduct(
                request,
                response
        );
    }

    private void prepareProductForm(
            HttpServletRequest request
    ) {
        String id =
                request.getParameter(
                        "id"
                );

        boolean edit =
                id != null
                && !id.isBlank();

        SanPham sanPham;

        if (edit) {
            sanPham =
                    sanPhamDAO.findById(id);

            if (sanPham == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy sản phẩm."
                );
            }

        } else {
            sanPham =
                    new SanPham();

            sanPham.setMaSanPham(
                    maTuDongDAO
                            .taoMaSanPham()
            );

            sanPham.setTrangThai(true);
        }

        imageUtil.applyImageInfo(
                sanPham
        );

        request.setAttribute(
                "sanPhamFormEdit",
                edit
        );

        request.setAttribute(
                "sanPhamEdit",
                sanPham
        );

        request.setAttribute(
                "showSanPhamModal",
                true
        );
    }

    private void prepareRecipeForm(
            HttpServletRequest request
    ) {
        String id =
                request.getParameter(
                        "id"
                );

        if (
                id == null
                || id.isBlank()
        ) {
            id =
                    request.getParameter(
                            "maSanPham"
                    );
        }

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

    private void toggleStatus(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
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

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            loadQuanLy(
                    request,
                    response
            );
        }
    }

    private void saveRecipe(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        try {
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

        } catch (Exception exception) {
            exception.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            prepareRecipeForm(
                    request
            );

            loadQuanLy(
                    request,
                    response
            );
        }
    }

    private void saveProduct(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        boolean edit =
                "edit".equals(
                        request.getParameter(
                                "mode"
                        )
                );

        SanPham sanPham =
                new SanPham();

        try {
            sanPham.setMaSanPham(
                    edit
                    ? trim(
                            request.getParameter(
                                    "maSanPham"
                            )
                    )
                    : maTuDongDAO
                            .taoMaSanPham()
            );

            sanPham.setTenSanPham(
                    trim(
                            request.getParameter(
                                    "tenSanPham"
                            )
                    )
            );

            sanPham.setMaDanhMuc(
                    trim(
                            request.getParameter(
                                    "maDanhMuc"
                            )
                    )
            );

            sanPham.setGiaBan(
                    parsePrice(
                            request.getParameter(
                                    "giaBan"
                            )
                    )
            );

            sanPham.setTrangThai(
                    request.getParameter(
                            "trangThai"
                    ) != null
            );

            BufferedImage uploadedImage =
                    imageUtil.readImage(
                            request.getPart(
                                    "hinhAnhFile"
                            )
                    );

            boolean removeImage =
                    "true".equals(
                            request.getParameter(
                                    "xoaHinhAnh"
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

            if (uploadedImage != null) {
                imageUtil.saveImage(
                        sanPham.getMaSanPham(),
                        uploadedImage
                );

            } else if (removeImage) {
                imageUtil.deleteImage(
                        sanPham.getMaSanPham()
                );
            }

            redirectSuccess(
                    request,
                    response,
                    "save"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            imageUtil.applyImageInfo(
                    sanPham
            );

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            request.setAttribute(
                    "sanPhamFormEdit",
                    edit
            );

            request.setAttribute(
                    "sanPhamEdit",
                    sanPham
            );

            request.setAttribute(
                    "showSanPhamModal",
                    true
            );

            loadQuanLy(
                    request,
                    response
            );
        }
    }

    private BigDecimal parsePrice(
            String value
    ) {
        try {
            return new BigDecimal(value);

        } catch (Exception exception) {
            throw new IllegalArgumentException(
                    "Giá sản phẩm không hợp lệ."
            );
        }
    }

    private void loadQuanLy(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        List<SanPham> sanPhamList =
                sanPhamDAO.getAll(
                        request.getParameter(
                                "keyword"
                        ),
                        request.getParameter(
                                "maDanhMuc"
                        ),
                        true
                );

        imageUtil.applyImageInfo(
                sanPhamList
        );

        request.setAttribute(
                "sanPhamList",
                sanPhamList
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

        List<SanPham> sanPhamList =
                sanPhamDAO.getAll(
                        request.getParameter(
                                "keyword"
                        ),
                        request.getParameter(
                                "maDanhMuc"
                        ),
                        false
                );

        imageUtil.applyImageInfo(
                sanPhamList
        );

        request.setAttribute(
                "sanPhamList",
                sanPhamList
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
            return "Đã xảy ra lỗi khi xử lý sản phẩm.";
        }

        return exception.getMessage();
    }
}