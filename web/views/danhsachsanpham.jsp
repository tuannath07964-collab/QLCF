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

        <title>Danh sách sản phẩm</title>

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
                       value="productList"/>

        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">

                <jsp:param name="title"
                           value="Danh sách sản phẩm"/>

                <jsp:param name="subtitle"
                           value="Các sản phẩm hiện đang được phép bán"/>

            </jsp:include>

            <div class="app-content">

                <div class="page-header">

                    <div>

                        <h2>Sản phẩm đang bán</h2>

                        <p>
                            Ảnh, giá và số phần có thể bán
                            được lấy từ thông tin quản lý sản phẩm.
                        </p>

                    </div>

                </div>

                <form class="toolbar"
                      action="${pageContext.request.contextPath}/san-pham/danh-sach"
                      method="get">

                    <div class="toolbar-left product-search-toolbar">

                        <div class="search-box">

                            <i class="fa-solid fa-magnifying-glass"></i>

                            <input type="text"
                                   name="keyword"
                                   value="${param.keyword}"
                                   placeholder="Nhập tên hoặc mã sản phẩm..."
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

                <c:choose>

                    <c:when test="${not empty sanPhamList}">

                        <section class="product-display-grid">

                            <c:forEach var="sanPham"
                                       items="${sanPhamList}">

                                <article class="product-display-card
                                         ${sanPham.coTheBan
                                           ? ''
                                           : 'unavailable'}">

                                    <div class="product-display-media">

                                        <c:if test="${not empty sanPham.hinhAnh}">

                                            <img src="${pageContext.request.contextPath}/product-image/${sanPham.hinhAnh}"
                                                 alt="${sanPham.tenSanPham}"
                                                 data-product-image>

                                        </c:if>

                                        <div class="product-display-image-fallback
                                             ${not empty sanPham.hinhAnh
                                               ? 'hidden'
                                               : ''}">

                                            <i class="fa-solid fa-mug-saucer"></i>

                                        </div>

                                        <span class="product-display-category-badge">

                                            <c:out value="${sanPham.tenDanhMuc}"/>

                                        </span>

                                    </div>

                                    <div class="product-display-body">

                                        <div class="product-display-category">

                                            <c:out value="${sanPham.tenDanhMuc}"/>

                                        </div>

                                        <h3>

                                            <c:out value="${sanPham.tenSanPham}"/>

                                        </h3>

                                        <small>

                                            <c:out value="${sanPham.maSanPham}"/>

                                        </small>

                                        <p class="product-display-recipe">

                                            <c:out value="${sanPham.congThucText}"/>

                                        </p>

                                        <div class="product-display-footer">

                                            <strong>

                                                <fmt:formatNumber
                                                    value="${sanPham.giaBan}"
                                                    pattern="#,##0"/>

                                                đ

                                            </strong>

                                            <span class="badge
                                                  ${sanPham.coTheBan
                                                    ? 'badge-success'
                                                    : 'badge-danger'}">

                                                <c:choose>

                                                    <c:when test="${sanPham.coTheBan}">

                                                        ${sanPham.soLuongCoTheBan}
                                                        phần

                                                    </c:when>

                                                    <c:otherwise>

                                                        Hết nguyên liệu

                                                    </c:otherwise>

                                                </c:choose>

                                            </span>

                                        </div>

                                    </div>

                                </article>

                            </c:forEach>

                        </section>

                    </c:when>

                    <c:otherwise>

                        <section class="card">

                            <div class="empty-state">

                                <i class="fa-solid fa-mug-saucer"></i>

                                <strong>
                                    Không tìm thấy sản phẩm
                                </strong>

                            </div>

                        </section>

                    </c:otherwise>

                </c:choose>

            </div>

        </main>

        <script src="${pageContext.request.contextPath}/js/sanpham.js?v=1"></script>

    </body>

</html>