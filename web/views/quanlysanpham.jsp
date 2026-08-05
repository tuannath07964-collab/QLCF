<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Quản lý sản phẩm</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=120">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=120">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/cafe-theme.css?v=4">

    </head>

    <body>

        <jsp:include page="/views/components/sidebar.jsp">

            <jsp:param name="active"
                       value="productManage"/>

        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">

                <jsp:param name="title"
                           value="Quản lý sản phẩm"/>

                <jsp:param name="subtitle"
                           value="Thêm, sửa, hình ảnh, trạng thái và công thức"/>

            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'save'}">

                    <div class="alert alert-success">

                        <i class="fa-solid fa-circle-check"></i>

                        Lưu sản phẩm thành công.

                    </div>

                </c:if>

                <c:if test="${param.success == 'recipe'}">

                    <div class="alert alert-success">

                        <i class="fa-solid fa-circle-check"></i>

                        Lưu công thức sản phẩm thành công.

                    </div>

                </c:if>

                <c:if test="${param.success == 'toggle'}">

                    <div class="alert alert-success">

                        <i class="fa-solid fa-circle-check"></i>

                        Cập nhật trạng thái sản phẩm thành công.

                    </div>

                </c:if>

                <c:if test="${not empty errorMessage}">

                    <div class="alert alert-danger">

                        <i class="fa-solid fa-circle-exclamation"></i>

                        <c:out value="${errorMessage}"/>

                    </div>

                </c:if>

                <div class="page-header">

                    <div>

                        <h2>Quản lý sản phẩm</h2>

                        <p>
                            Thêm ảnh đại diện, giá bán, danh mục
                            và công thức nguyên liệu của sản phẩm.
                        </p>

                    </div>

                    <div class="page-actions">

                        <a class="btn btn-primary"
                           href="${pageContext.request.contextPath}/san-pham/quan-ly?action=form">

                            <i class="fa-solid fa-plus"></i>

                            Thêm sản phẩm

                        </a>

                    </div>

                </div>

                <form class="toolbar"
                      action="${pageContext.request.contextPath}/san-pham/quan-ly"
                      method="get">

                    <div class="toolbar-left product-search-toolbar">

                        <div class="search-box">

                            <i class="fa-solid fa-magnifying-glass"></i>

                            <input type="text"
                                   name="keyword"
                                   value="${param.keyword}"
                                   placeholder="Nhập mã hoặc tên sản phẩm..."
                                   autocomplete="off">

                        </div>

                        <select class="form-control toolbar-select"
                                name="maDanhMuc">

                            <option value="all">
                                Tất cả danh mục
                            </option>

                            <c:forEach var="danhMuc"
                                       items="${danhMucList}">

                                <option value="${danhMuc.maDanhMuc}"
                                        ${param.maDanhMuc == danhMuc.maDanhMuc
                                          ? 'selected'
                                          : ''}>

                                    <c:out value="${danhMuc.tenDanhMuc}"/>

                                </option>

                            </c:forEach>

                        </select>

                        <button class="btn btn-outline"
                                type="submit">

                            <i class="fa-solid fa-magnifying-glass"></i>

                            Tìm kiếm

                        </button>

                    </div>

                </form>

                <section class="card">

                    <div class="table-wrapper">

                        <table class="data-table product-management-table">

                            <thead>

                                <tr>

                                    <th>Ảnh</th>
                                    <th>Mã SP</th>
                                    <th>Sản phẩm</th>
                                    <th>Danh mục</th>
                                    <th>Giá bán</th>
                                    <th>Có thể bán</th>
                                    <th>Trạng thái</th>
                                    <th>Công thức</th>
                                    <th>Thao tác</th>

                                </tr>

                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty sanPhamList}">

                                        <c:forEach var="sanPham"
                                                   items="${sanPhamList}">

                                            <tr>

                                                <td>

                                                    <div class="product-table-image">

                                                        <c:if test="${not empty sanPham.hinhAnh}">

                                                            <img src="${pageContext.request.contextPath}/product-image/${sanPham.hinhAnh}"
                                                                 alt="${sanPham.tenSanPham}"
                                                                 data-product-image>

                                                        </c:if>

                                                        <span class="product-image-fallback
                                                              ${not empty sanPham.hinhAnh
                                                                ? 'hidden'
                                                                : ''}">

                                                            <i class="fa-solid fa-mug-saucer"></i>

                                                        </span>

                                                    </div>

                                                </td>

                                                <td>

                                                    <strong>
                                                        <c:out value="${sanPham.maSanPham}"/>
                                                    </strong>

                                                </td>

                                                <td>

                                                    <strong>
                                                        <c:out value="${sanPham.tenSanPham}"/>
                                                    </strong>

                                                </td>

                                                <td>

                                                    <span class="badge badge-blue">

                                                        <c:out value="${sanPham.tenDanhMuc}"/>

                                                    </span>

                                                </td>

                                                <td>

                                                    <strong>

                                                        <fmt:formatNumber
                                                            value="${sanPham.giaBan}"
                                                            pattern="#,##0"/>

                                                        đ

                                                    </strong>

                                                </td>

                                                <td>

                                                    ${sanPham.soLuongCoTheBan}
                                                    phần

                                                </td>

                                                <td>

                                                    <span class="badge
                                                          ${sanPham.trangThai
                                                            ? 'badge-success'
                                                            : 'badge-danger'}">

                                                        ${sanPham.trangThai
                                                          ? 'Đang bán'
                                                          : 'Ngừng bán'}

                                                    </span>

                                                </td>

                                                <td class="product-recipe-cell">

                                                    <c:out value="${sanPham.congThucText}"/>

                                                </td>

                                                <td>

                                                    <div class="table-actions">

                                                        <a class="table-action"
                                                           title="Sửa sản phẩm"
                                                           href="${pageContext.request.contextPath}/san-pham/quan-ly?action=form&id=${sanPham.maSanPham}">

                                                            <i class="fa-solid fa-pen"></i>

                                                        </a>

                                                        <a class="table-action"
                                                           title="Cấu hình công thức"
                                                           href="${pageContext.request.contextPath}/san-pham/quan-ly?action=recipe&id=${sanPham.maSanPham}">

                                                            <i class="fa-solid fa-flask"></i>

                                                        </a>

                                                        <form action="${pageContext.request.contextPath}/san-pham/quan-ly"
                                                              method="post"
                                                              class="inline-form">

                                                            <input type="hidden"
                                                                   name="action"
                                                                   value="toggle">

                                                            <input type="hidden"
                                                                   name="id"
                                                                   value="${sanPham.maSanPham}">

                                                            <button class="table-action"
                                                                    type="submit"
                                                                    title="${sanPham.trangThai
                                                                             ? 'Ngừng bán'
                                                                             : 'Cho phép bán'}">

                                                                <i class="fa-solid fa-power-off"></i>

                                                            </button>

                                                        </form>

                                                    </div>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>

                                            <td colspan="9">

                                                <div class="empty-state">

                                                    <i class="fa-solid fa-mug-saucer"></i>

                                                    <strong>
                                                        Không tìm thấy sản phẩm
                                                    </strong>

                                                </div>

                                            </td>

                                        </tr>

                                    </c:otherwise>

                                </c:choose>

                            </tbody>

                        </table>

                    </div>

                </section>

            </div>

        </main>

        <div class="modal-overlay
             ${showSanPhamModal ? 'show' : ''}">

            <div class="modal-dialog">

                <div class="modal-header">

                    <h3>

                        ${sanPhamFormEdit
                          ? 'Cập nhật sản phẩm'
                          : 'Thêm sản phẩm'}

                    </h3>

                    <a class="modal-close"
                       href="${pageContext.request.contextPath}/san-pham/quan-ly">

                        <i class="fa-solid fa-xmark"></i>

                    </a>

                </div>

                <div class="modal-body">

                    <form action="${pageContext.request.contextPath}/san-pham/quan-ly"
                          method="post"
                          enctype="multipart/form-data">

                        <input type="hidden"
                               name="mode"
                               value="${sanPhamFormEdit
                                        ? 'edit'
                                        : 'add'}">

                        <div class="form-grid">

                            <div class="form-group">

                                <label class="form-label"
                                       for="productCode">

                                    Mã sản phẩm

                                </label>

                                <input class="form-control"
                                       id="productCode"
                                       type="text"
                                       name="maSanPham"
                                       value="${sanPhamEdit.maSanPham}"
                                       maxlength="20"
                                       placeholder="Ví dụ: M21"
                                       ${sanPhamFormEdit
                                         ? 'readonly'
                                         : ''}
                                       required>

                            </div>

                            <div class="form-group">

                                <label class="form-label"
                                       for="productName">

                                    Tên sản phẩm

                                </label>

                                <input class="form-control"
                                       id="productName"
                                       type="text"
                                       name="tenSanPham"
                                       value="${sanPhamEdit.tenSanPham}"
                                       maxlength="255"
                                       placeholder="Nhập tên sản phẩm"
                                       required>

                            </div>

                            <div class="form-group">

                                <label class="form-label"
                                       for="productCategory">

                                    Danh mục

                                </label>

                                <select class="form-control"
                                        id="productCategory"
                                        name="maDanhMuc"
                                        required>

                                    <c:forEach var="danhMuc"
                                               items="${danhMucList}">

                                        <option value="${danhMuc.maDanhMuc}"
                                                ${sanPhamEdit.maDanhMuc == danhMuc.maDanhMuc
                                                  ? 'selected'
                                                  : ''}>

                                            <c:out value="${danhMuc.tenDanhMuc}"/>

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>

                            <div class="form-group">

                                <label class="form-label"
                                       for="productPrice">

                                    Giá bán

                                </label>

                                <input class="form-control"
                                       id="productPrice"
                                       type="number"
                                       name="giaBan"
                                       value="${sanPhamEdit.giaBan}"
                                       min="0"
                                       step="1000"
                                       placeholder="Ví dụ: 25000"
                                       required>

                            </div>

                            <div class="form-group full">

                                <label class="form-label">
                                    Ảnh sản phẩm
                                </label>

                                <div class="product-image-upload">

                                    <div class="product-image-preview"
                                         id="productImagePreview">

                                        <c:if test="${not empty sanPhamEdit.hinhAnh}">

                                            <img src="${pageContext.request.contextPath}/product-image/${sanPhamEdit.hinhAnh}"
                                                 alt="${sanPhamEdit.tenSanPham}"
                                                 id="productImagePreviewElement"
                                                 data-original-src="${pageContext.request.contextPath}/product-image/${sanPhamEdit.hinhAnh}">

                                        </c:if>

                                        <div class="product-image-preview-placeholder
                                             ${not empty sanPhamEdit.hinhAnh
                                               ? 'hidden'
                                               : ''}"
                                             id="productImagePreviewPlaceholder">

                                            <i class="fa-solid fa-image"></i>

                                            <span>
                                                Chưa chọn ảnh
                                            </span>

                                        </div>

                                    </div>

                                    <div class="product-image-upload-content">

                                        <label class="product-image-select-button"
                                               for="productImageInput">

                                            <i class="fa-solid fa-cloud-arrow-up"></i>

                                            Chọn ảnh sản phẩm

                                        </label>

                                        <input type="file"
                                               id="productImageInput"
                                               name="hinhAnhFile"
                                               accept="image/jpeg,image/png,image/webp"
                                               hidden>

                                        <small>

                                            Hỗ trợ JPG, PNG, WEBP.
                                            Dung lượng tối đa 5 MB.

                                        </small>

                                        <c:if test="${sanPhamFormEdit
                                                      and not empty sanPhamEdit.hinhAnh}">

                                            <label class="checkbox-item product-remove-image">

                                                <input type="checkbox"
                                                       id="removeProductImage"
                                                       name="xoaHinhAnh"
                                                       value="true">

                                                Xóa ảnh hiện tại

                                            </label>

                                        </c:if>

                                    </div>

                                </div>

                            </div>

                            <div class="form-group full">

                                <label class="checkbox-item">

                                    <input type="checkbox"
                                           name="trangThai"
                                           ${not sanPhamFormEdit
                                             or sanPhamEdit.trangThai
                                             ? 'checked'
                                             : ''}>

                                    Cho phép bán sản phẩm

                                </label>

                            </div>

                        </div>

                        <div class="form-actions">

                            <a class="btn btn-outline"
                               href="${pageContext.request.contextPath}/san-pham/quan-ly">

                                Hủy

                            </a>

                            <button class="btn btn-primary"
                                    type="submit">

                                <i class="fa-solid fa-floppy-disk"></i>

                                Lưu sản phẩm

                            </button>

                        </div>

                    </form>

                </div>

            </div>

        </div>

        <div class="modal-overlay
             ${showCongThucModal ? 'show' : ''}">

            <div class="modal-dialog large">

                <div class="modal-header">

                    <div>

                        <h3>Công thức sản phẩm</h3>

                        <p>

                            <c:out value="${sanPhamCongThuc.maSanPham}"/>

                            -

                            <c:out value="${sanPhamCongThuc.tenSanPham}"/>

                        </p>

                    </div>

                    <a class="modal-close"
                       href="${pageContext.request.contextPath}/san-pham/quan-ly">

                        <i class="fa-solid fa-xmark"></i>

                    </a>

                </div>

                <div class="modal-body">

                    <div class="alert alert-warning">

                        <i class="fa-solid fa-circle-info"></i>

                        Số lượng dưới đây sẽ bị trừ khỏi kho
                        khi bán một phần sản phẩm.

                    </div>

                    <form action="${pageContext.request.contextPath}/san-pham/quan-ly"
                          method="post">

                        <input type="hidden"
                               name="action"
                               value="recipe">

                        <input type="hidden"
                               name="maSanPham"
                               value="${sanPhamCongThuc.maSanPham}">

                        <div class="recipe-grid">

                            <c:forEach var="nguyenLieu"
                                       items="${nguyenLieuList}">

                                <div class="recipe-item">

                                    <input type="hidden"
                                           name="maNguyenLieu"
                                           value="${nguyenLieu.maNguyenLieu}">

                                    <div>

                                        <strong>

                                            <c:out value="${nguyenLieu.tenNguyenLieu}"/>

                                        </strong>

                                        <small>

                                            Tồn kho:

                                            ${nguyenLieu.soLuongTon}

                                            ${nguyenLieu.donVi}

                                        </small>

                                    </div>

                                    <div class="recipe-quantity-box">

                                        <input class="form-control recipe-input"
                                               type="number"
                                               name="soLuongCan"
                                               value="${congThucMap[nguyenLieu.maNguyenLieu]}"
                                               min="0"
                                               step="1"
                                               placeholder="0">

                                        <span class="recipe-unit">

                                            ${nguyenLieu.donVi}

                                        </span>

                                    </div>

                                </div>

                            </c:forEach>

                        </div>

                        <div class="form-actions">

                            <a class="btn btn-outline"
                               href="${pageContext.request.contextPath}/san-pham/quan-ly">

                                Hủy

                            </a>

                            <button class="btn btn-primary"
                                    type="submit">

                                <i class="fa-solid fa-floppy-disk"></i>

                                Lưu công thức

                            </button>

                        </div>

                    </form>

                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/js/sanpham.js?v=1"></script>

    </body>

</html>