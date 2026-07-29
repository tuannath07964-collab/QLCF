<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<%
    if (session.getAttribute("maNV") == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/LoginServlet"
        );
        return;
    }

    if (request.getAttribute("homepageLoaded") == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/homepage"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Trang chủ - Quản lý quán Cafe</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">
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
                       value="Tổng quan hoạt động hiện tại của quán"/>
        </jsp:include>

        <div class="app-content">

            <c:if test="${not empty errorMessage}">

                <div class="alert alert-danger">

                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMessage}
                </div>

            </c:if>

            <section class="welcome-panel">

                <div>

                    <h2>
                        Xin chào, ${sessionScope.tenNV}
                    </h2>

                    <p>
                        Theo dõi tình trạng bàn, hóa đơn đang xử lý,
                        nguyên liệu sắp hết và các thao tác phục vụ
                        thường dùng trong ca làm.
                    </p>

                </div>

                <div class="shift-summary">

                    <strong>
                        <i class="fa-regular fa-clock"></i>
                        Ca làm hiện tại
                    </strong>

                    <c:choose>

                        <c:when test="${caLamHienTai.quanLy}">

                            <p>
                                <i class="fa-solid fa-user-shield"></i>
                                Quản lý được truy cập toàn thời gian
                            </p>

                        </c:when>

                        <c:otherwise>

                            <p>
                                <i class="fa-solid fa-calendar-day"></i>
                                ${caLamHienTai.tenCa}
                            </p>

                            <p>
                                <i class="fa-regular fa-clock"></i>

                                ${caLamHienTai.gioBatDauHienThi}
                                -
                                ${caLamHienTai.gioKetThucHienThi}
                            </p>

                        </c:otherwise>

                    </c:choose>

                    <p id="currentDateTime">
                        --/--/---- --:--
                    </p>

                </div>

            </section>

            <section class="summary-grid">

                <div class="summary-card">

                    <div class="summary-icon green">
                        <i class="fa-solid fa-chair"></i>
                    </div>

                    <div class="summary-content">
                        <span>Bàn trống</span>

                        <strong>
                            ${tongQuan.banTrong}/${tongQuan.tongBan}
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon red">
                        <i class="fa-solid fa-mug-hot"></i>
                    </div>

                    <div class="summary-content">
                        <span>Đang phục vụ</span>
                        <strong>${tongQuan.banDangPhucVu}</strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon blue">
                        <i class="fa-solid fa-file-invoice"></i>
                    </div>

                    <div class="summary-content">
                        <span>Đơn đang xử lý</span>
                        <strong>${tongQuan.donDangXuLy}</strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon orange">
                        <i class="fa-solid fa-box-open"></i>
                    </div>

                    <div class="summary-content">
                        <span>Kho cần chú ý</span>
                        <strong>${tongQuan.nguyenLieuCanXuLy}</strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon purple">
                        <i class="fa-solid fa-users"></i>
                    </div>

                    <div class="summary-content">
                        <span>Nhân viên trong ca</span>
                        <strong>${tongQuan.nhanVienTrongCa}</strong>
                    </div>

                </div>

            </section>

            <section class="dashboard-grid">

                <div class="card">

                    <div class="card-body">

                        <div class="section-title">

                            <div>
                                <h3>Sơ đồ bàn</h3>

                                <p>
                                    Chọn bàn để nhận bàn hoặc mở hóa đơn
                                </p>
                            </div>

                            <a class="section-link"
                               href="${pageContext.request.contextPath}/ban">

                                Xem tất cả
                                <i class="fa-solid fa-arrow-right"></i>
                            </a>

                        </div>

                        <c:choose>

                            <c:when test="${not empty danhSachBanTrangChu}">

                                <div class="table-map">

                                    <c:forEach var="ban"
                                               items="${danhSachBanTrangChu}">

                                        <c:choose>

                                            <c:when test="${ban.trangThai == 0}">

                                                <c:url var="banLink"
                                                       value="/ban/nhanban">

                                                    <c:param name="id"
                                                             value="${ban.maBan}"/>
                                                </c:url>

                                            </c:when>

                                            <c:when test="${ban.trangThai == 1
                                                            and not empty ban.maHD}">

                                                <c:url var="banLink"
                                                       value="/hoadon">

                                                    <c:param name="action"
                                                             value="edit"/>

                                                    <c:param name="maHD"
                                                             value="${ban.maHD}"/>
                                                </c:url>

                                            </c:when>

                                            <c:when test="${ban.trangThai == 1}">

                                                <c:url var="banLink"
                                                       value="/ban/traban">

                                                    <c:param name="id"
                                                             value="${ban.maBan}"/>
                                                </c:url>

                                            </c:when>

                                            <c:otherwise>

                                                <c:url var="banLink"
                                                       value="/ban"/>

                                            </c:otherwise>

                                        </c:choose>

                                        <a class="table-tile ${ban.cssClass}"
                                           href="${banLink}">

                                            <div>

                                                <div class="table-tile-name">
                                                    ${ban.tenBan}
                                                </div>

                                                <div class="table-tile-meta">

                                                    ${ban.khuVuc}
                                                    ·
                                                    ${ban.soCho} chỗ
                                                </div>

                                            </div>

                                            <div class="table-tile-status">

                                                <span>
                                                    ${ban.trangThaiText}
                                                </span>

                                                <i class="fa-solid fa-chevron-right"></i>
                                            </div>

                                        </a>

                                    </c:forEach>

                                </div>

                            </c:when>

                            <c:otherwise>

                                <div class="empty-state">

                                    <i class="fa-solid fa-chair"></i>

                                    <strong>
                                        Chưa có dữ liệu bàn
                                    </strong>
                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

                <div class="card">

                    <div class="card-body">

                        <div class="section-title">

                            <div>
                                <h3>Cảnh báo kho</h3>

                                <p>
                                    Nguyên liệu còn từ 10 đơn vị trở xuống
                                </p>
                            </div>

                            <a class="section-link"
                               href="${pageContext.request.contextPath}/KhoServlet">

                                Mở kho
                                <i class="fa-solid fa-arrow-right"></i>
                            </a>

                        </div>

                        <c:choose>

                            <c:when test="${not empty canhBaoKho}">

                                <div class="stock-list">

                                    <c:forEach var="item"
                                               items="${canhBaoKho}">

                                        <div class="stock-item">

                                            <div>

                                                <strong>
                                                    ${item.tenNL}
                                                </strong>

                                                <small>
                                                    ${item.maNL}
                                                </small>

                                            </div>

                                            <div>

                                                <strong>

                                                    <fmt:formatNumber
                                                        value="${item.soLuong}"
                                                        pattern="#,##0.##"/>

                                                    ${item.donVi}
                                                </strong>

                                                <span class="badge badge-${item.cssClass}">
                                                    ${item.mucDo}
                                                </span>

                                            </div>

                                        </div>

                                    </c:forEach>

                                </div>

                            </c:when>

                            <c:otherwise>

                                <div class="empty-state">

                                    <i class="fa-solid fa-circle-check"></i>

                                    <strong>
                                        Kho đang ổn định
                                    </strong>

                                    <span>
                                        Không có nguyên liệu ở mức cảnh báo.
                                    </span>
                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

            </section>

            <section class="card">

                <div class="card-header">

                    <div>
                        <h3>Đơn đang xử lý gần nhất</h3>

                        <p>
                            Các hóa đơn chưa hoàn thành
                        </p>
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
                                <th>Hình thức</th>
                                <th>Khách hàng</th>
                                <th>Nhân viên</th>
                                <th>Ngày tạo</th>
                                <th>Tạm tính</th>
                                <th></th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:choose>

                                <c:when test="${not empty donDangXuLy}">

                                    <c:forEach var="don"
                                               items="${donDangXuLy}">

                                        <tr>

                                            <td>
                                                <strong>
                                                    ${don.maHienThi}
                                                </strong>
                                            </td>

                                            <td>
                                                <span class="badge badge-blue">
                                                    ${don.viTriPhucVu}
                                                </span>
                                            </td>

                                            <td>
                                                ${empty don.tenKhachHang
                                                    ? 'Khách lẻ'
                                                    : don.tenKhachHang}
                                            </td>

                                            <td>${don.maNV}</td>

                                            <td>${don.ngayTao}</td>

                                            <td>

                                                <strong>

                                                    <fmt:formatNumber
                                                        value="${don.tongTien}"
                                                        pattern="#,##0"/>

                                                    đ
                                                </strong>
                                            </td>

                                            <td>

                                                <a class="table-action"
                                                   href="${pageContext.request.contextPath}/hoadon?action=edit&maHD=${don.maHD}"
                                                   title="Mở hóa đơn">

                                                    <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                </a>
                                            </td>

                                        </tr>

                                    </c:forEach>

                                </c:when>

                                <c:otherwise>

                                    <tr>
                                        <td colspan="7">

                                            <div class="empty-state">

                                                <i class="fa-regular fa-file-lines"></i>

                                                <strong>
                                                    Không có đơn đang xử lý
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

            <section class="quick-actions">

                <a class="quick-action"
                   href="${pageContext.request.contextPath}/ban">

                    <div class="quick-action-icon">
                        <i class="fa-solid fa-chair"></i>
                    </div>

                    <div>
                        <strong>Bán tại bàn</strong>
                        <span>Chọn và nhận bàn trống</span>
                    </div>
                </a>

                <a class="quick-action"
                   href="${pageContext.request.contextPath}/hoadon?action=takeaway">

                    <div class="quick-action-icon">
                        <i class="fa-solid fa-bag-shopping"></i>
                    </div>

                    <div>
                        <strong>Bán mang về</strong>
                        <span>Tạo đơn không cần chọn bàn</span>
                    </div>
                </a>

                <a class="quick-action"
                   href="${pageContext.request.contextPath}/KhoServlet">

                    <div class="quick-action-icon">
                        <i class="fa-solid fa-box"></i>
                    </div>

                    <div>
                        <strong>Kiểm tra kho</strong>
                        <span>Theo dõi nguyên liệu hiện tại</span>
                    </div>
                </a>

            </section>

        </div>

    </main>

    <script>
        function updateDateTime() {
            const element =
                    document.getElementById("currentDateTime");

            if (!element) {
                return;
            }

            element.textContent =
                    new Date().toLocaleString(
                            "vi-VN",
                            {
                                hour: "2-digit",
                                minute: "2-digit",
                                second: "2-digit",
                                day: "2-digit",
                                month: "2-digit",
                                year: "numeric"
                            }
                    );
        }

        updateDateTime();
        setInterval(updateDateTime, 1000);
    </script>

</body>
</html>