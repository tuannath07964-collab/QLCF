package controller;

import dao.DanhMucSanPhamDAO;
import dao.SanPhamDAO;
import dao.SanPhamHinhAnhDAO;
import dao.khoDAO;

import model.SanPham;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;

import java.math.BigDecimal;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

import java.util.List;
import java.util.Locale;
import java.util.UUID;

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

    private static final long MAX_IMAGE_SIZE =
            5L * 1024L * 1024L;

    private SanPhamDAO sanPhamDAO;
    private SanPhamHinhAnhDAO hinhAnhDAO;
    private DanhMucSanPhamDAO danhMucDAO;
    private khoDAO nguyenLieuDAO;

    @Override
    public void init()
            throws ServletException {

        sanPhamDAO =
                new SanPhamDAO();

        hinhAnhDAO =
                new SanPhamHinhAnhDAO();

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
                String id =
                        request.getParameter(
                                "id"
                        );

                boolean edit =
                        id != null
                        && !id.isBlank();

                request.setAttribute(
                        "sanPhamFormEdit",
                        edit
                );

                if (edit) {
                    SanPham sanPham =
                            sanPhamDAO.findById(id);

                    if (sanPham == null) {
                        throw new IllegalArgumentException(
                                "Không tìm thấy sản phẩm."
                        );
                    }

                    sanPham.setHinhAnh(
                            hinhAnhDAO.findHinhAnh(id)
                    );

                    request.setAttribute(
                            "sanPhamEdit",
                            sanPham
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

        String hinhAnhMoiDaLuu =
                null;

        String hinhAnhCu =
                null;

        SanPham sanPham =
                null;

        boolean edit =
                false;

        try {
            String action =
                    request.getParameter(
                            "action"
                    );

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

            sanPham =
                    readSanPham(request);

            edit =
                    "edit".equals(
                            request.getParameter(
                                    "mode"
                            )
                    );

            if (edit) {
                hinhAnhCu =
                        hinhAnhDAO.findHinhAnh(
                                sanPham.getMaSanPham()
                        );
            }

            boolean xoaHinhAnh =
                    "true".equals(
                            request.getParameter(
                                    "xoaHinhAnh"
                            )
                    );

            Part hinhAnhPart =
                    request.getPart(
                            "hinhAnhFile"
                    );

            if (
                    hinhAnhPart != null
                    && hinhAnhPart.getSize() > 0
            ) {
                hinhAnhMoiDaLuu =
                        saveImage(
                                hinhAnhPart,
                                sanPham.getMaSanPham()
                        );

                sanPham.setHinhAnh(
                        hinhAnhMoiDaLuu
                );

            } else if (xoaHinhAnh) {
                sanPham.setHinhAnh(null);

            } else {
                sanPham.setHinhAnh(
                        hinhAnhCu
                );
            }

            if (edit) {
                sanPhamDAO.update(
                        sanPham
                );

            } else {
                sanPhamDAO.insert(
                        sanPham
                );
            }

            hinhAnhDAO.updateHinhAnh(
                    sanPham.getMaSanPham(),
                    sanPham.getHinhAnh()
            );

            if (
                    hinhAnhMoiDaLuu != null
                    && hinhAnhCu != null
                    && !hinhAnhCu.equals(
                            hinhAnhMoiDaLuu
                    )
            ) {
                deleteImage(hinhAnhCu);
            }

            if (
                    hinhAnhMoiDaLuu == null
                    && sanPham.getHinhAnh() == null
                    && hinhAnhCu != null
            ) {
                deleteImage(hinhAnhCu);
            }

            redirectSuccess(
                    request,
                    response,
                    "save"
            );

        } catch (Exception exception) {
            exception.printStackTrace();

            if (hinhAnhMoiDaLuu != null) {
                deleteImage(
                        hinhAnhMoiDaLuu
                );
            }

            request.setAttribute(
                    "errorMessage",
                    getErrorMessage(exception)
            );

            request.setAttribute(
                    "showSanPhamModal",
                    true
            );

            request.setAttribute(
                    "sanPhamFormEdit",
                    edit
            );

            if (sanPham != null) {
                sanPham.setHinhAnh(
                        hinhAnhCu
                );

                request.setAttribute(
                        "sanPhamEdit",
                        sanPham
                );
            }

            loadQuanLy(
                    request,
                    response
            );
        }
    }

    private SanPham readSanPham(
            HttpServletRequest request
    ) {
        SanPham sanPham =
                new SanPham();

        sanPham.setMaSanPham(
                trim(
                        request.getParameter(
                                "maSanPham"
                        )
                )
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

        try {
            sanPham.setGiaBan(
                    new BigDecimal(
                            request.getParameter(
                                    "giaBan"
                            )
                    )
            );

        } catch (Exception exception) {
            throw new IllegalArgumentException(
                    "Giá sản phẩm không hợp lệ."
            );
        }

        sanPham.setTrangThai(
                request.getParameter(
                        "trangThai"
                ) != null
        );

        return sanPham;
    }

    private String saveImage(
            Part imagePart,
            String maSanPham
    ) throws IOException {

        if (imagePart.getSize() > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException(
                    "Ảnh sản phẩm không được lớn hơn 5 MB."
            );
        }

        String contentType =
                imagePart.getContentType();

        String extension =
                getImageExtension(
                        contentType
                );

        if (extension == null) {
            throw new IllegalArgumentException(
                    "Chỉ được chọn ảnh JPG, JPEG, PNG hoặc WEBP."
            );
        }

        String safeProductCode =
                maSanPham
                        .replaceAll(
                                "[^a-zA-Z0-9_-]",
                                ""
                        );

        if (safeProductCode.isBlank()) {
            safeProductCode =
                    "san-pham";
        }

        String fileName =
                safeProductCode
                + "-"
                + UUID.randomUUID()
                + extension;

        Path uploadDirectory =
                getUploadDirectory();

        Files.createDirectories(
                uploadDirectory
        );

        Path targetFile =
                uploadDirectory
                        .resolve(fileName)
                        .normalize();

        if (!targetFile.startsWith(uploadDirectory)) {
            throw new IOException(
                    "Đường dẫn lưu ảnh không hợp lệ."
            );
        }

        try (
                InputStream inputStream =
                        imagePart.getInputStream()
        ) {
            Files.copy(
                    inputStream,
                    targetFile,
                    StandardCopyOption.REPLACE_EXISTING
            );
        }

        return fileName;
    }

    private String getImageExtension(
            String contentType
    ) {
        if (contentType == null) {
            return null;
        }

        return switch (
                contentType
                        .toLowerCase(
                                Locale.ROOT
                        )
        ) {
            case "image/jpeg",
                 "image/jpg" ->
                ".jpg";

            case "image/png" ->
                ".png";

            case "image/webp" ->
                ".webp";

            default ->
                null;
        };
    }

    private Path getUploadDirectory() {
        return Path.of(
                System.getProperty(
                        "user.home"
                ),
                "QLCF_uploads",
                "sanpham"
        ).toAbsolutePath().normalize();
    }

    private void deleteImage(
            String fileName
    ) {
        if (
                fileName == null
                || fileName.isBlank()
        ) {
            return;
        }

        try {
            Path uploadDirectory =
                    getUploadDirectory();

            Path imageFile =
                    uploadDirectory
                            .resolve(fileName)
                            .normalize();

            if (imageFile.startsWith(uploadDirectory)) {
                Files.deleteIfExists(
                        imageFile
                );
            }

        } catch (IOException exception) {
            exception.printStackTrace();
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

        hinhAnhDAO.boSungHinhAnh(
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

        hinhAnhDAO.boSungHinhAnh(
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