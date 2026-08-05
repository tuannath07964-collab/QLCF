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

        <title>Thống kê bán hàng</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=61">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=61">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/cafe-theme.css?v=2">

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>

    <body>

        <jsp:include page="/views/components/sidebar.jsp">
            <jsp:param name="active"
                       value="statistics"/>
        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">
                <jsp:param name="title"
                           value="Thống kê bán hàng"/>

                <jsp:param name="subtitle"
                           value="Theo dõi doanh thu và sản phẩm bán chạy"/>
            </jsp:include>

            <div class="app-content">

                <c:if test="${not empty errorMessage}">

                    <div class="alert alert-danger">

                        <i class="fa-solid fa-circle-exclamation"></i>

                        <c:out value="${errorMessage}"/>
                    </div>

                </c:if>

                <div class="page-header">

                    <div>
                        <h2>Báo cáo bán hàng</h2>

                        <p>
                            Chỉ tính các hóa đơn đã thanh toán.
                        </p>
                    </div>

                </div>

                <form class="toolbar statistics-filter"
                      action="${pageContext.request.contextPath}/ThongKeServlet"
                      method="get">

                    <div class="toolbar-left">

                        <div class="form-group statistics-date">

                            <label class="form-label">
                                Từ ngày
                            </label>

                            <input class="form-control"
                                   type="date"
                                   name="tuNgay"
                                   value="${tuNgay}"
                                   required>
                        </div>

                        <div class="form-group statistics-date">

                            <label class="form-label">
                                Đến ngày
                            </label>

                            <input class="form-control"
                                   type="date"
                                   name="denNgay"
                                   value="${denNgay}"
                                   required>
                        </div>

                        <button class="btn btn-primary statistics-submit"
                                type="submit">

                            <i class="fa-solid fa-filter"></i>
                            Xem báo cáo
                        </button>

                    </div>

                </form>

                <section class="summary-grid statistics-summary-grid">

                    <article class="summary-card">

                        <div class="summary-icon blue">
                            <i class="fa-solid fa-file-invoice"></i>
                        </div>

                        <div class="summary-content">

                            <span>Số hóa đơn</span>

                            <strong>
                                ${tongQuan.soHoaDon}
                            </strong>
                        </div>

                    </article>

                    <article class="summary-card">

                        <div class="summary-icon green">
                            <i class="fa-solid fa-sack-dollar"></i>
                        </div>

                        <div class="summary-content">

                            <span>Tổng doanh thu</span>

                            <strong>
                                <fmt:formatNumber
                                    value="${tongQuan.tongDoanhThu}"
                                    pattern="#,##0"/>

                                đ
                            </strong>
                        </div>

                    </article>

                    <article class="summary-card">

                        <div class="summary-icon purple">
                            <i class="fa-solid fa-receipt"></i>
                        </div>

                        <div class="summary-content">

                            <span>Giá trị đơn trung bình</span>

                            <strong>
                                <fmt:formatNumber
                                    value="${tongQuan.giaTriTrungBinh}"
                                    pattern="#,##0"/>

                                đ
                            </strong>
                        </div>

                    </article>

                </section>

                <section class="statistics-main-grid">

                    <article class="card chart-card">

                        <div class="card-header">

                            <div>
                                <h3>Doanh thu theo ngày</h3>

                                <p>
                                    Biến động doanh thu trong thời gian đã chọn
                                </p>
                            </div>

                        </div>

                        <div class="card-body chart-canvas-wrapper">

                            <canvas id="revenueChart"></canvas>
                        </div>

                    </article>

                    <article class="card best-seller-card">

                        <div class="card-header">

                            <div>
                                <h3>5 món bán chạy nhất</h3>

                                <p>
                                    Xếp hạng theo số lượng đã bán
                                </p>
                            </div>

                        </div>

                        <div class="card-body">

                            <c:choose>

                                <c:when test="${not empty topSanPhamList}">

                                    <div class="best-seller-list">

                                        <c:forEach var="sanPham"
                                                   items="${topSanPhamList}"
                                                   varStatus="status">

                                            <div class="best-seller-item">

                                                <span class="best-seller-rank">
                                                    ${status.index + 1}
                                                </span>

                                                <div class="best-seller-info">

                                                    <strong>
                                                        <c:out value="${sanPham.tenSanPham}"/>
                                                    </strong>

                                                    <span>
                                                        Đã bán:
                                                        ${sanPham.soLuongBan}
                                                        sản phẩm
                                                    </span>
                                                </div>

                                                <div class="best-seller-revenue">

                                                    <strong>
                                                        <fmt:formatNumber
                                                            value="${sanPham.doanhThu}"
                                                            pattern="#,##0"/>

                                                        đ
                                                    </strong>

                                                    <span>Doanh thu</span>
                                                </div>

                                            </div>

                                        </c:forEach>

                                    </div>

                                </c:when>

                                <c:otherwise>

                                    <div class="empty-state">

                                        <i class="fa-solid fa-ranking-star"></i>

                                        <strong>
                                            Chưa có dữ liệu sản phẩm bán chạy
                                        </strong>
                                    </div>

                                </c:otherwise>

                            </c:choose>

                        </div>

                    </article>

                </section>

                <section class="card">

                    <div class="card-header">

                        <div>
                            <h3>Hóa đơn đã thanh toán</h3>

                            <p>
                                Chi tiết hóa đơn trong thời gian đã chọn
                            </p>
                        </div>

                        <div class="search-box">

                            <i class="fa-solid fa-magnifying-glass"></i>

                            <input type="text"
                                   id="statisticsSearch"
                                   placeholder="Tìm hóa đơn, khách hàng..."
                                   autocomplete="off">
                        </div>

                    </div>

                    <div class="table-wrapper">

                        <table class="data-table">

                            <thead>
                                <tr>
                                    <th>Mã hóa đơn</th>
                                    <th>Ngày thanh toán</th>
                                    <th>Người bán</th>
                                    <th>Khách hàng</th>
                                    <th>Tổng tiền</th>
                                </tr>
                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty hoaDonThongKeList}">

                                        <c:forEach var="hoaDon"
                                                   items="${hoaDonThongKeList}">

                                            <tr class="statistics-row"
                                                data-search="${hoaDon.maHienThi}
                                                ${hoaDon.tenTaiKhoan}
                                                ${hoaDon.tenKhachHang}">

                                                <td>
                                                    <strong>
                                                        ${hoaDon.maHienThi}
                                                    </strong>
                                                </td>

                                                <td>
                                                    ${hoaDon.ngayThanhToan}
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.tenTaiKhoan}"/>
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.tenKhachHang}"/>
                                                </td>

                                                <td>
                                                    <strong>
                                                        <fmt:formatNumber
                                                            value="${hoaDon.tongTien}"
                                                            pattern="#,##0"/>

                                                        đ
                                                    </strong>
                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>
                                            <td colspan="5">

                                                <div class="empty-state">

                                                    <i class="fa-solid fa-chart-line"></i>

                                                    <strong>
                                                        Không có dữ liệu
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

        <div id="revenueChartData"
             class="hidden">

            <c:forEach var="item"
                       items="${doanhThuNgayList}">

                <span data-label="${item.ngay}"
                      data-value="${item.doanhThu}">
                </span>

            </c:forEach>

        </div>

        <script>
            function readRevenueData() {
                const labels = [];
                const values = [];

                const container =
                        document.getElementById(
                                "revenueChartData"
                                );

                if (!container) {
                    return {
                        labels: labels,
                        values: values
                    };
                }

                container.querySelectorAll("span")
                        .forEach(function (item) {
                            labels.push(
                                    item.dataset.label
                                    );

                            values.push(
                                    Number(
                                            item.dataset.value
                                            ) || 0
                                    );
                        });

                return {
                    labels: labels,
                    values: values
                };
            }

            const revenueData =
                    readRevenueData();

            const revenueCanvas =
                    document.getElementById(
                            "revenueChart"
                            );

            if (revenueCanvas) {
                new Chart(
                        revenueCanvas,
                        {
                            type: "line",

                            data: {
                                labels: revenueData.labels,

                                datasets: [
                                    {
                                        label: "Doanh thu",
                                        data: revenueData.values,
                                        borderColor: "#3b82f6",
                                        backgroundColor:
                                                "rgba(59, 130, 246, 0.12)",
                                        fill: true,
                                        tension: 0.35,
                                        pointRadius: 4,
                                        pointHoverRadius: 6
                                    }
                                ]
                            },

                            options: {
                                responsive: true,
                                maintainAspectRatio: false,

                                plugins: {
                                    legend: {
                                        display: false
                                    }
                                },

                                scales: {
                                    y: {
                                        beginAtZero: true,

                                        ticks: {
                                            callback: function (value) {
                                                return Number(value)
                                                        .toLocaleString("vi-VN")
                                                        + "đ";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                );
            }

            const statisticsSearch =
                    document.getElementById(
                            "statisticsSearch"
                            );

            function normalizeText(value) {
                return (value || "")
                        .toLowerCase()
                        .normalize("NFD")
                        .replace(
                                /[\u0300-\u036f]/g,
                                ""
                                );
            }

            if (statisticsSearch) {
                statisticsSearch.addEventListener(
                        "input",
                        function () {
                            const keyword =
                                    normalizeText(
                                            statisticsSearch.value
                                            );

                            document.querySelectorAll(
                                    ".statistics-row"
                                    ).forEach(
                                    function (row) {
                                        const text =
                                                normalizeText(
                                                        row.dataset.search
                                                        );

                                        row.style.display =
                                                text.includes(keyword)
                                                ? ""
                                                : "none";
                                    }
                            );
                        }
                );
            }
        </script>

    </body>
</html>