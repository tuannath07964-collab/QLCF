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

    <title>Thống kê doanh thu</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">

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
                       value="Thống kê doanh thu"/>

            <jsp:param name="subtitle"
                       value="Báo cáo dành riêng cho tài khoản quản lý"/>
        </jsp:include>

        <div class="app-content">

            <c:if test="${not empty errorMessage}">

                <div class="alert alert-danger">

                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMessage}
                </div>

            </c:if>

            <div class="page-header">

                <div>
                    <h2>Báo cáo doanh thu</h2>

                    <p>
                        Chỉ tính các hóa đơn đã thanh toán.
                    </p>
                </div>

            </div>

            <form class="toolbar"
                  action="${pageContext.request.contextPath}/ThongKeServlet"
                  method="get">

                <div class="toolbar-left">

                    <div class="form-group">

                        <label class="form-label"
                               for="tuNgay">

                            Từ ngày
                        </label>

                        <input class="form-control"
                               type="date"
                               id="tuNgay"
                               name="tuNgay"
                               value="${tuNgay}">
                    </div>

                    <div class="form-group">

                        <label class="form-label"
                               for="denNgay">

                            Đến ngày
                        </label>

                        <input class="form-control"
                               type="date"
                               id="denNgay"
                               name="denNgay"
                               value="${denNgay}">
                    </div>

                </div>

                <div class="toolbar-right">

                    <button type="submit"
                            class="btn btn-primary">

                        <i class="fa-solid fa-filter"></i>
                        Xem thống kê
                    </button>

                </div>

            </form>

            <section class="summary-grid">

                <div class="summary-card">

                    <div class="summary-icon blue">
                        <i class="fa-solid fa-file-invoice"></i>
                    </div>

                    <div class="summary-content">
                        <span>Số hóa đơn</span>
                        <strong>${soHoaDon}</strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon green">
                        <i class="fa-solid fa-sack-dollar"></i>
                    </div>

                    <div class="summary-content">

                        <span>Tổng doanh thu</span>

                        <strong>

                            <fmt:formatNumber
                                value="${tongDoanhThu}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon orange">
                        <i class="fa-solid fa-money-bill-wave"></i>
                    </div>

                    <div class="summary-content">

                        <span>Tiền mặt</span>

                        <strong>

                            <fmt:formatNumber
                                value="${doanhThuTienMat}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon purple">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>

                    <div class="summary-content">

                        <span>Thanh toán khác</span>

                        <strong>

                            <fmt:formatNumber
                                value="${doanhThuKhac}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

            </section>

            <section class="statistics-layout">

                <div class="card">

                    <div class="card-header">

                        <div>
                            <h3>Doanh thu theo ngày</h3>

                            <p>
                                Biểu đồ trong khoảng thời gian đã chọn
                            </p>
                        </div>

                    </div>

                    <div class="card-body">

                        <div class="chart-box">
                            <canvas id="revenueChart"></canvas>
                        </div>

                    </div>

                </div>

                <div class="card">

                    <div class="card-header">

                        <div>
                            <h3>Cơ cấu doanh thu</h3>

                            <p>
                                Phân loại theo hình thức bán
                            </p>
                        </div>

                    </div>

                    <div class="card-body">

                        <div class="breakdown-list">

                            <div class="breakdown-item">

                                <div class="breakdown-item-header">

                                    <span>Tại bàn</span>

                                    <strong>

                                        <fmt:formatNumber
                                            value="${doanhThuTaiBan}"
                                            pattern="#,##0"/>

                                        đ
                                    </strong>
                                </div>

                                <div class="breakdown-progress">

                                    <span style="
                                          width:${tongDoanhThu > 0
                                            ? doanhThuTaiBan
                                                * 100
                                                / tongDoanhThu
                                            : 0}%;">
                                    </span>

                                </div>

                            </div>

                            <div class="breakdown-item">

                                <div class="breakdown-item-header">

                                    <span>Mang về</span>

                                    <strong>

                                        <fmt:formatNumber
                                            value="${doanhThuMangVe}"
                                            pattern="#,##0"/>

                                        đ
                                    </strong>
                                </div>

                                <div class="breakdown-progress">

                                    <span style="
                                          width:${tongDoanhThu > 0
                                            ? doanhThuMangVe
                                                * 100
                                                / tongDoanhThu
                                            : 0}%;">
                                    </span>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </section>

            <section class="card">

                <div class="card-header">

                    <div>
                        <h3>Hóa đơn đã thanh toán</h3>

                        <p>
                            Chi tiết doanh thu trong khoảng thời gian
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
                                <th>Hình thức</th>
                                <th>Bàn</th>
                                <th>Nhân viên</th>
                                <th>Khách hàng</th>
                                <th>Thanh toán</th>
                                <th>Tổng tiền</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:choose>

                                <c:when test="${not empty dsThongKe}">

                                    <c:forEach var="hd"
                                               items="${dsThongKe}">

                                        <tr class="statistics-row"
                                            data-search="${hd.maHD}
                                                         ${hd.maHienThi}
                                                         ${hd.maNV}
                                                         ${hd.maBan}
                                                         ${hd.tenKhachHang}
                                                         ${hd.hinhThuc}
                                                         ${hd.phuongThucThanhToan}">

                                            <td>
                                                <strong>
                                                    ${hd.maHienThi}
                                                </strong>
                                            </td>

                                            <td>${hd.ngayThanhToan}</td>

                                            <td>
                                                <span class="badge badge-blue">
                                                    ${hd.hinhThuc}
                                                </span>
                                            </td>

                                            <td>
                                                ${empty hd.maBan
                                                    ? 'Không dùng bàn'
                                                    : hd.maBan}
                                            </td>

                                            <td>${hd.maNV}</td>

                                            <td>
                                                ${empty hd.tenKhachHang
                                                    ? 'Khách lẻ'
                                                    : hd.tenKhachHang}
                                            </td>

                                            <td>
                                                ${hd.phuongThucThanhToan}
                                            </td>

                                            <td>

                                                <strong>

                                                    <fmt:formatNumber
                                                        value="${hd.tongTien}"
                                                        pattern="#,##0"/>

                                                    đ
                                                </strong>
                                            </td>

                                        </tr>

                                    </c:forEach>

                                </c:when>

                                <c:otherwise>

                                    <tr>
                                        <td colspan="8">

                                            <div class="empty-state">

                                                <i class="fa-solid fa-chart-line"></i>

                                                <strong>
                                                    Không có dữ liệu doanh thu
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

    <script>
        const chartLabels = [
            <c:forEach var="item"
                       items="${dsDoanhThuNgay}"
                       varStatus="status">

                "${item.ngay}"${status.last ? "" : ","}
            </c:forEach>
        ];

        const chartValues = [
            <c:forEach var="item"
                       items="${dsDoanhThuNgay}"
                       varStatus="status">

                ${item.doanhThu}${status.last ? "" : ","}
            </c:forEach>
        ];

        const chartCanvas =
                document.getElementById("revenueChart");

        if (chartCanvas) {
            new Chart(
                    chartCanvas,
                    {
                        type: "line",

                        data: {
                            labels: chartLabels,

                            datasets: [
                                {
                                    label: "Doanh thu",
                                    data: chartValues,
                                    borderColor: "#3b82f6",
                                    backgroundColor:
                                            "rgba(59, 130, 246, 0.10)",
                                    fill: true,
                                    tension: 0.35
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

        document.getElementById("statisticsSearch")
                .addEventListener(
                        "input",
                        function () {
                            const keyword =
                                    this.value
                                            .toLowerCase()
                                            .normalize("NFD")
                                            .replace(
                                                    /[\u0300-\u036f]/g,
                                                    ""
                                            );

                            document.querySelectorAll(".statistics-row")
                                    .forEach(row => {
                                        const text =
                                                row.dataset.search
                                                        .toLowerCase()
                                                        .normalize("NFD")
                                                        .replace(
                                                                /[\u0300-\u036f]/g,
                                                                ""
                                                        );

                                        row.style.display =
                                                text.includes(keyword)
                                                ? ""
                                                : "none";
                                    });
                        }
                );
    </script>

</body>
</html>