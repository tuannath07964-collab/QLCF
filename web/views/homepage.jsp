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

    <title>Trang chủ - Quản lý bán hàng</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css?v=50">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/store.css?v=50">
</head>

<body>

    <jsp:include page="/views/components/sidebar.jsp">
        <jsp:param name="active"
                   value="home"/>
    </jsp:include>

    <main class="app-main">

        <jsp:include page="/views/components/topbar.jsp">
            <jsp:param name="title"
                       value="Trang chủ"/>

            <jsp:param name="subtitle"
                       value="Tổng quan hoạt động bán hàng của quán"/>
        </jsp:include>

        <div class="app-content">

            <c:if test="${not empty errorMessage}">

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <c:out value="${errorMessage}"/>
                </div>

            </c:if>

            <section class="home-hero">

                <div>

                    <span class="home-hero-label">
                        QUẢN LÝ BÁN HÀNG
                    </span>

                    <h2>
                        Xin chào,
                        <c:out value="${sessionScope.tenNV}"/>
                    </h2>

                    <p>
                        Tạo hóa đơn, quản lý sản phẩm, kiểm tra tồn kho
                        và theo dõi các đơn đang chờ thanh toán.
                    </p>

                </div>

                <a class="btn btn-blue home-hero-button"
                   href="${pageContext.request.contextPath}/hoadon?action=create">

                    <i class="fa-solid fa-plus"></i>
                    Tạo hóa đơn mới
                </a>

            </section>

            <section class="home-summary-grid">

                <article class="home-summary-card">

                    <span class="home-summary-icon blue">
                        <i class="fa-solid fa-hourglass-half"></i>
                    </span>

                    <div>
                        <span>Đơn chờ thanh toán</span>
                        <strong>${tongQuan.donChoThanhToan}</strong>
                    </div>

                </article>

                <article class="home-summary-card">

                    <span class="home-summary-icon green">
                        <i class="fa-solid fa-circle-check"></i>
                    </span>

                    <div>
                        <span>Đơn đã bán hôm nay</span>
                        <strong>${tongQuan.donHomNay}</strong>
                    </div>

                </article>

                <article class="home-summary-card">

                    <span class="home-summary-icon purple">
                        <i class="fa-solid fa-mug-saucer"></i>
                    </span>

                    <div>
                        <span>Sản phẩm đang bán</span>
                        <strong>${tongQuan.sanPhamDangBan}</strong>
                    </div>

                </article>

                <article class="home-summary-card">

                    <span class="home-summary-icon orange">
                        <i class="fa-solid fa-box-open"></i>
                    </span>

                    <div>
                        <span>Nguyên liệu cần nhập</span>
                        <strong>${tongQuan.nguyenLieuCanNhap}</strong>
                    </div>

                </article>

                <article class="home-summary-card revenue">

                    <span class="home-summary-icon green">
                        <i class="fa-solid fa-sack-dollar"></i>
                    </span>

                    <div>
                        <span>Doanh thu hôm nay</span>

                        <strong>
                            <fmt:formatNumber
                                value="${tongQuan.doanhThuHomNay}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </article>

            </section>

            <section class="quick-grid">

                <a class="quick-card"
                   href="${pageContext.request.contextPath}/hoadon?action=create">

                    <span>
                        <i class="fa-solid fa-file-circle-plus"></i>
                    </span>

                    <div>
                        <strong>Tạo hóa đơn</strong>
                        <small>Bắt đầu đơn bán hàng mới</small>
                    </div>

                </a>

                <a class="quick-card"
                   href="${pageContext.request.contextPath}/san-pham/quan-ly">

                    <span>
                        <i class="fa-solid fa-mug-saucer"></i>
                    </span>

                    <div>
                        <strong>Quản lý sản phẩm</strong>
                        <small>Thêm món và cấu hình công thức</small>
                    </div>

                </a>

                <a class="quick-card"
                   href="${pageContext.request.contextPath}/KhoServlet">

                    <span>
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </span>

                    <div>
                        <strong>Kiểm tra kho</strong>
                        <small>Nhập nguyên liệu theo mức cố định</small>
                    </div>

                </a>

                <a class="quick-card"
                   href="${pageContext.request.contextPath}/ThongKeServlet">

                    <span>
                        <i class="fa-solid fa-chart-line"></i>
                    </span>

                    <div>
                        <strong>Xem thống kê</strong>
                        <small>Doanh thu và sản phẩm bán chạy</small>
                    </div>

                </a>

            </section>

            <section class="home-content-grid">

                <article class="card">

                    <div class="card-header">

                        <div>
                            <h3>Đơn chờ thanh toán</h3>
                            <p>Các hóa đơn chưa hoàn tất</p>
                        </div>

                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/hoadon">

                            Xem tất cả
                        </a>

                    </div>

                    <div class="table-wrapper">

                        <table class="data-table">

                            <thead>
                                <tr>
                                    <th>Mã hóa đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>Tạm tính</th>
                                    <th></th>
                                </tr>
                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty donChoThanhToan}">

                                        <c:forEach var="hoaDon"
                                                   items="${donChoThanhToan}">

                                            <tr>

                                                <td>
                                                    <strong>
                                                        ${hoaDon.maHienThi}
                                                    </strong>
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.tenKhachHang}"/>
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.tenTaiKhoan}"/>
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.ngayTao}"/>
                                                </td>

                                                <td>
                                                    <fmt:formatNumber
                                                        value="${hoaDon.tongTien}"
                                                        pattern="#,##0"/>

                                                    đ
                                                </td>

                                                <td>

                                                    <a class="table-action"
                                                       href="${pageContext.request.contextPath}/hoadon?action=edit&id=${hoaDon.maHD}"
                                                       title="Mở hóa đơn">

                                                        <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                    </a>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>
                                            <td colspan="6">

                                                <div class="empty-state">

                                                    <i class="fa-solid fa-circle-check"></i>

                                                    <strong>
                                                        Không có đơn chờ thanh toán
                                                    </strong>
                                                </div>

                                            </td>
                                        </tr>

                                    </c:otherwise>

                                </c:choose>

                            </tbody>

                        </table>

                    </div>

                </article>

                <article class="card">

                    <div class="card-header">

                        <div>
                            <h3>Cảnh báo kho</h3>
                            <p>Nguyên liệu hết hoặc sắp hết</p>
                        </div>

                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/KhoServlet">

                            Mở kho
                        </a>

                    </div>

                    <div class="card-body">

                        <c:choose>

                            <c:when test="${not empty nguyenLieuCanNhap}">

                                <div class="warning-stock-list">

                                    <c:forEach var="nguyenLieu"
                                               items="${nguyenLieuCanNhap}">

                                        <div class="warning-stock-item">

                                            <div>

                                                <strong>
                                                    <c:out value="${nguyenLieu.tenNguyenLieu}"/>
                                                </strong>

                                                <small>
                                                    ${nguyenLieu.maNguyenLieu}
                                                </small>

                                            </div>

                                            <div class="warning-stock-value">

                                                <strong>
                                                    ${nguyenLieu.soLuongTon}
                                                </strong>

                                                <span>
                                                    ${nguyenLieu.donVi}
                                                </span>

                                            </div>

                                        </div>

                                    </c:forEach>

                                </div>

                            </c:when>

                            <c:otherwise>

                                <div class="empty-state">

                                    <i class="fa-solid fa-box"></i>

                                    <strong>
                                        Kho đang ổn định
                                    </strong>

                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </article>

            </section>

        </div>

    </main>

</body>
</html>