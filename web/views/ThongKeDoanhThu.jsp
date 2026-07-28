<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<%@ taglib prefix="fn"
           uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Thống kê doanh thu</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background: #f4f6f9;
            color: #273444;
            font-family: Arial, sans-serif;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
            width: 260px;
            height: 100vh;
            background: #2c3e50;
            color: #fff;
        }

        .brand {
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, .12);
            font-size: 18px;
            font-weight: 700;
        }

        .brand i {
            margin-right: 8px;
        }

        .menu {
            flex: 1;
            margin: 0;
            padding: 18px 0;
            list-style: none;
        }

        .menu li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 22px;
            cursor: pointer;
            transition: background .2s;
        }

        .menu li:hover,
        .menu li.active {
            background: rgba(255, 255, 255, .13);
        }

        .menu li i {
            width: 20px;
            text-align: center;
        }

        .logout {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 22px;
            border-top: 1px solid rgba(255, 255, 255, .12);
            color: #ffabab;
            text-decoration: none;
        }

        .main {
            min-height: 100vh;
            margin-left: 260px;
        }

        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 72px;
            padding: 0 30px;
            border-bottom: 1px solid #e4e8ec;
            background: #fff;
        }

        .topbar h2 {
            margin: 0;
            color: #2c3e50;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #52606d;
            font-weight: 600;
        }

        .content {
            padding: 28px 30px 40px;
        }

        .page-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 22px;
        }

        .page-heading h1 {
            margin: 0;
            color: #253746;
            font-size: 30px;
        }

        .page-heading p {
            margin: 7px 0 0;
            color: #75808a;
        }

        .back-home {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 15px;
            border: 1px solid #dce1e5;
            border-radius: 8px;
            background: #fff;
            color: #2c3e50;
            text-decoration: none;
            font-weight: 700;
        }

        .back-home:hover {
            background: #2c3e50;
            color: #fff;
        }

        .message {
            margin-bottom: 20px;
            padding: 13px 16px;
            border: 1px solid #f5c2c7;
            border-radius: 8px;
            background: #f8d7da;
            color: #842029;
            font-weight: 600;
        }

        .filter-card {
            margin-bottom: 22px;
            padding: 18px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-end;
            gap: 14px;
        }

        .filter-field {
            min-width: 190px;
        }

        .filter-field label {
            display: block;
            margin-bottom: 7px;
            color: #45515c;
            font-size: 13px;
            font-weight: 700;
        }

        .filter-field input {
            width: 100%;
            height: 41px;
            padding: 0 11px;
            border: 1px solid #dce1e5;
            border-radius: 7px;
            outline: none;
            font-family: inherit;
        }

        .filter-field input:focus {
            border-color: #806044;
            box-shadow: 0 0 0 3px rgba(128, 96, 68, .1);
        }

        .btn-filter,
        .btn-reset {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            height: 41px;
            padding: 0 17px;
            border: 0;
            border-radius: 7px;
            cursor: pointer;
            font-family: inherit;
            font-weight: 700;
            text-decoration: none;
        }

        .btn-filter {
            background: #2c3e50;
            color: #fff;
        }

        .btn-filter:hover {
            background: #1f2d3a;
        }

        .btn-reset {
            border: 1px solid #dce1e5;
            background: #fff;
            color: #52606d;
        }

        .summary-grid {
            display: grid;
            grid-template-columns:
                repeat(3, minmax(190px, 1fr));
            gap: 17px;
            margin-bottom: 23px;
        }

        .summary-card {
            display: flex;
            align-items: center;
            gap: 15px;
            min-height: 120px;
            padding: 19px;
            border: 1px solid #edf0f2;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 3px 10px rgba(0, 0, 0, .045);
        }

        .summary-icon {
            display: flex;
            flex: 0 0 48px;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            border-radius: 12px;
            font-size: 21px;
        }

        .icon-green {
            background: #d1e7dd;
            color: #0f5132;
        }

        .icon-blue {
            background: #cfe2ff;
            color: #084298;
        }

        .icon-orange {
            background: #fff3cd;
            color: #664d03;
        }

        .icon-purple {
            background: #e7d9ff;
            color: #5a2ca0;
        }

        .icon-brown {
            background: #eadfd8;
            color: #67402e;
        }

        .icon-gray {
            background: #e9ecef;
            color: #41464b;
        }

        .summary-content {
            min-width: 0;
        }

        .summary-content span {
            display: block;
            margin-bottom: 7px;
            color: #75808a;
            font-size: 13px;
            font-weight: 700;
        }

        .summary-content strong {
            display: block;
            overflow: hidden;
            color: #273444;
            font-size: 22px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns:
                minmax(0, 2fr)
                minmax(280px, 1fr);
            gap: 20px;
            margin-bottom: 23px;
        }

        .panel {
            padding: 20px;
            border: 1px solid #edf0f2;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 3px 10px rgba(0, 0, 0, .045);
        }

        .panel h3 {
            margin: 0 0 18px;
            color: #2c3e50;
        }

        .chart-wrapper {
            position: relative;
            width: 100%;
            min-height: 320px;
        }

        .revenue-type-row {
            margin-bottom: 18px;
        }

        .revenue-type-label {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 7px;
            color: #52606d;
            font-size: 14px;
        }

        .revenue-type-label strong {
            color: #273444;
        }

        .progress {
            height: 10px;
            overflow: hidden;
            border-radius: 999px;
            background: #edf0f2;
        }

        .progress-bar {
            height: 100%;
            border-radius: inherit;
            background: #806044;
        }

        .progress-bar.green {
            background: #198754;
        }

        .table-card {
            overflow: hidden;
            border: 1px solid #edf0f2;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 3px 10px rgba(0, 0, 0, .045);
        }

        .table-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 17px 19px;
            border-bottom: 1px solid #edf0f2;
        }

        .table-toolbar h3 {
            margin: 0;
            color: #2c3e50;
        }

        .search-box {
            position: relative;
            width: 320px;
            max-width: 100%;
        }

        .search-box i {
            position: absolute;
            top: 50%;
            left: 12px;
            color: #7d8994;
            transform: translateY(-50%);
        }

        .search-box input {
            width: 100%;
            height: 39px;
            padding: 0 12px 0 38px;
            border: 1px solid #dce1e5;
            border-radius: 7px;
            outline: none;
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 1000px;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 13px 14px;
            border-bottom: 1px solid #edf0f2;
            text-align: left;
            font-size: 13px;
        }

        th {
            background: #f8fafb;
            color: #52606d;
            font-size: 12px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        tbody tr:hover {
            background: #fafbfc;
        }

        .invoice-code {
            color: #2c3e50;
            font-weight: 800;
        }

        .money {
            color: #198754;
            font-weight: 800;
            white-space: nowrap;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .badge-table {
            background: #cfe2ff;
            color: #084298;
        }

        .badge-takeaway {
            background: #fff3cd;
            color: #664d03;
        }

        .badge-cash {
            background: #d1e7dd;
            color: #0f5132;
        }

        .badge-other {
            background: #e9ecef;
            color: #41464b;
        }

        .empty-row {
            padding: 42px 20px;
            color: #75808a;
            text-align: center;
        }

        .empty-row i {
            display: block;
            margin-bottom: 10px;
            font-size: 35px;
        }

        .table-footer {
            padding: 13px 19px;
            color: #75808a;
            font-size: 13px;
        }

        @media (max-width: 1100px) {
            .summary-grid {
                grid-template-columns:
                    repeat(2, minmax(190px, 1fr));
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 800px) {
            .sidebar {
                position: static;
                width: 100%;
                height: auto;
            }

            .menu {
                display: none;
            }

            .main {
                margin-left: 0;
            }

            .content {
                padding: 20px 15px 30px;
            }

            .topbar {
                padding: 0 15px;
            }

            .page-heading {
                flex-direction: column;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .table-toolbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .search-box {
                width: 100%;
            }
        }

        @media print {
            .sidebar,
            .topbar,
            .filter-card,
            .back-home,
            .search-box {
                display: none !important;
            }

            .main {
                margin-left: 0;
            }

            .content {
                padding: 0;
            }

            .summary-card,
            .panel,
            .table-card {
                box-shadow: none;
            }
        }
    </style>
</head>

<body>

    <!-- ==================== SIDEBAR ==================== -->
    <aside class="sidebar">

        <div class="brand">
            <i class="fa-solid fa-mug-hot"></i>
            QUẢN LÝ CAFE
        </div>

        <ul class="menu">

            <li onclick="location.href='${pageContext.request.contextPath}/views/homepage.jsp'">
                <i class="fa-solid fa-house"></i>
                <span>Trang chủ</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/nhanvien'">
                <i class="fa-solid fa-user"></i>
                <span>Nhân viên</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/hoadon'">
                <i class="fa-solid fa-file-invoice-dollar"></i>
                <span>Hóa đơn</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/menu'">
                <i class="fa-solid fa-mug-saucer"></i>
                <span>Menu</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/ban'">
                <i class="fa-solid fa-chair"></i>
                <span>Bàn</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/KhoServlet'">
                <i class="fa-solid fa-box"></i>
                <span>Kho</span>
            </li>

            <li onclick="location.href='${pageContext.request.contextPath}/khachhang'">
                <i class="fa-solid fa-users"></i>
                <span>Khách hàng</span>
            </li>

            <li class="active"
                onclick="location.href='${pageContext.request.contextPath}/ThongKeServlet'">

                <i class="fa-solid fa-chart-column"></i>
                <span>Thống kê</span>
            </li>

        </ul>

        <a class="logout"
           href="${pageContext.request.contextPath}/LogoutServlet">

            <i class="fa-solid fa-right-from-bracket"></i>
            Đăng xuất
        </a>

    </aside>

    <!-- ==================== MAIN ==================== -->
    <main class="main">

        <header class="topbar">

            <h2>Thống kê doanh thu</h2>

            <div class="user-info">
                <i class="fa-solid fa-circle-user"></i>

                <span>
                    ${sessionScope.maNV}
                    -
                    ${sessionScope.tenNV}
                    -
                    ${sessionScope.chucVu}
                </span>
            </div>

        </header>

        <div class="content">

            <section class="page-heading">

                <div>
                    <h1>Báo cáo doanh thu</h1>

                    <p>
                        Chỉ tính các hóa đơn có trạng thái
                        Đã thanh toán
                    </p>
                </div>

                <a class="back-home"
                   href="${pageContext.request.contextPath}/views/homepage.jsp">

                    <i class="fa-solid fa-arrow-left"></i>
                    Quay lại trang chủ
                </a>

            </section>

            <c:if test="${not empty errorMessage}">

                <div class="message">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMessage}
                </div>

            </c:if>

            <!-- ==================== BỘ LỌC NGÀY ==================== -->
            <section class="filter-card">

                <form class="filter-form"
                      action="${pageContext.request.contextPath}/ThongKeServlet"
                      method="get">

                    <div class="filter-field">

                        <label for="tuNgay">
                            Từ ngày
                        </label>

                        <input type="date"
                               id="tuNgay"
                               name="tuNgay"
                               value="${tuNgay}"
                               required>

                    </div>

                    <div class="filter-field">

                        <label for="denNgay">
                            Đến ngày
                        </label>

                        <input type="date"
                               id="denNgay"
                               name="denNgay"
                               value="${denNgay}"
                               required>

                    </div>

                    <button type="submit"
                            class="btn-filter">

                        <i class="fa-solid fa-filter"></i>
                        Xem thống kê
                    </button>

                    <a class="btn-reset"
                       href="${pageContext.request.contextPath}/ThongKeServlet">

                        <i class="fa-solid fa-rotate-left"></i>
                        Tháng hiện tại
                    </a>

                    <button type="button"
                            class="btn-reset"
                            onclick="window.print()">

                        <i class="fa-solid fa-print"></i>
                        In báo cáo
                    </button>

                </form>

            </section>

            <!-- ==================== TỔNG QUAN ==================== -->
            <section class="summary-grid">

                <div class="summary-card">

                    <div class="summary-icon icon-blue">
                        <i class="fa-solid fa-file-invoice"></i>
                    </div>

                    <div class="summary-content">
                        <span>Số hóa đơn</span>

                        <strong>
                            <fmt:formatNumber
                                value="${empty soHoaDon ? 0 : soHoaDon}"
                                pattern="#,##0"/>
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon icon-green">
                        <i class="fa-solid fa-sack-dollar"></i>
                    </div>

                    <div class="summary-content">
                        <span>Tổng doanh thu</span>

                        <strong>
                            <fmt:formatNumber
                                value="${empty tongDoanhThu ? 0 : tongDoanhThu}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon icon-orange">
                        <i class="fa-solid fa-money-bill-wave"></i>
                    </div>

                    <div class="summary-content">
                        <span>Doanh thu tiền mặt</span>

                        <strong>
                            <fmt:formatNumber
                                value="${empty doanhThuTienMat
                                    ? 0
                                    : doanhThuTienMat}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon icon-purple">
                        <i class="fa-solid fa-wallet"></i>
                    </div>

                    <div class="summary-content">
                        <span>Phương thức khác</span>

                        <strong>
                            <fmt:formatNumber
                                value="${empty doanhThuKhac
                                    ? 0
                                    : doanhThuKhac}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon icon-brown">
                        <i class="fa-solid fa-chair"></i>
                    </div>

                    <div class="summary-content">
                        <span>Doanh thu tại bàn</span>

                        <strong>
                            <fmt:formatNumber
                                value="${empty doanhThuTaiBan
                                    ? 0
                                    : doanhThuTaiBan}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon icon-gray">
                        <i class="fa-solid fa-bag-shopping"></i>
                    </div>

                    <div class="summary-content">
                        <span>Doanh thu mang về</span>

                        <strong>
                            <fmt:formatNumber
                                value="${empty doanhThuMangVe
                                    ? 0
                                    : doanhThuMangVe}"
                                pattern="#,##0"/>

                            đ
                        </strong>
                    </div>

                </div>

            </section>

            <!-- ==================== BIỂU ĐỒ + TỶ LỆ ==================== -->
            <section class="dashboard-grid">

                <div class="panel">

                    <h3>
                        <i class="fa-solid fa-chart-line"></i>
                        Doanh thu theo ngày
                    </h3>

                    <div class="chart-wrapper">

                        <c:choose>

                            <c:when test="${not empty dsDoanhThuNgay}">

                                <canvas id="revenueChart"></canvas>

                            </c:when>

                            <c:otherwise>

                                <div class="empty-row">

                                    <i class="fa-solid fa-chart-line"></i>

                                    Chưa có dữ liệu doanh thu
                                    trong khoảng thời gian này.
                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

                <div class="panel">

                    <h3>
                        <i class="fa-solid fa-chart-pie"></i>
                        Cơ cấu doanh thu
                    </h3>

                    <c:set var="tongDoanhThuAnToan"
                           value="${empty tongDoanhThu
                                    ? 0
                                    : tongDoanhThu}"/>

                    <c:set var="tyLeTaiBan"
                           value="${tongDoanhThuAnToan > 0
                                    ? doanhThuTaiBan
                                      * 100
                                      / tongDoanhThuAnToan
                                    : 0}"/>

                    <c:set var="tyLeMangVe"
                           value="${tongDoanhThuAnToan > 0
                                    ? doanhThuMangVe
                                      * 100
                                      / tongDoanhThuAnToan
                                    : 0}"/>

                    <c:set var="tyLeTienMat"
                           value="${tongDoanhThuAnToan > 0
                                    ? doanhThuTienMat
                                      * 100
                                      / tongDoanhThuAnToan
                                    : 0}"/>

                    <c:set var="tyLeKhac"
                           value="${tongDoanhThuAnToan > 0
                                    ? doanhThuKhac
                                      * 100
                                      / tongDoanhThuAnToan
                                    : 0}"/>

                    <div class="revenue-type-row">

                        <div class="revenue-type-label">
                            <span>Tại bàn</span>

                            <strong>
                                <fmt:formatNumber
                                    value="${tyLeTaiBan}"
                                    maxFractionDigits="1"/>

                                %
                            </strong>
                        </div>

                        <div class="progress">

                            <div class="progress-bar"
                                 style="width:${tyLeTaiBan}%;"></div>
                        </div>

                    </div>

                    <div class="revenue-type-row">

                        <div class="revenue-type-label">
                            <span>Mang về</span>

                            <strong>
                                <fmt:formatNumber
                                    value="${tyLeMangVe}"
                                    maxFractionDigits="1"/>

                                %
                            </strong>
                        </div>

                        <div class="progress">

                            <div class="progress-bar green"
                                 style="width:${tyLeMangVe}%;"></div>
                        </div>

                    </div>

                    <hr style="
                        margin:22px 0;
                        border:0;
                        border-top:1px solid #edf0f2;">

                    <div class="revenue-type-row">

                        <div class="revenue-type-label">
                            <span>Tiền mặt</span>

                            <strong>
                                <fmt:formatNumber
                                    value="${tyLeTienMat}"
                                    maxFractionDigits="1"/>

                                %
                            </strong>
                        </div>

                        <div class="progress">

                            <div class="progress-bar green"
                                 style="width:${tyLeTienMat}%;"></div>
                        </div>

                    </div>

                    <div class="revenue-type-row">

                        <div class="revenue-type-label">
                            <span>Phương thức khác</span>

                            <strong>
                                <fmt:formatNumber
                                    value="${tyLeKhac}"
                                    maxFractionDigits="1"/>

                                %
                            </strong>
                        </div>

                        <div class="progress">

                            <div class="progress-bar"
                                 style="width:${tyLeKhac}%;"></div>
                        </div>

                    </div>

                </div>

            </section>

            <!-- ==================== DANH SÁCH HÓA ĐƠN ==================== -->
            <section class="table-card">

                <div class="table-toolbar">

                    <h3>
                        Danh sách hóa đơn đã thanh toán
                    </h3>

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               id="invoiceSearch"
                               autocomplete="off"
                               placeholder="Tìm mã hóa đơn, khách, nhân viên...">
                    </div>

                </div>

                <div class="table-responsive">

                    <table>

                        <thead>
                            <tr>
                                <th>Mã hóa đơn</th>
                                <th>Ngày thanh toán</th>
                                <th>Hình thức</th>
                                <th>Bàn</th>
                                <th>Khách hàng</th>
                                <th>Nhân viên</th>
                                <th>Thanh toán</th>
                                <th>Tổng tiền</th>
                            </tr>
                        </thead>

                        <tbody id="invoiceRows">

                            <c:choose>

                                <c:when test="${not empty dsThongKe}">

                                    <c:forEach var="hd"
                                               items="${dsThongKe}">

                                        <tr data-search="${fn:toLowerCase(hd.maHienThi)}
                                                         ${fn:toLowerCase(hd.tenKhachHang)}
                                                         ${fn:toLowerCase(hd.maNV)}
                                                         ${fn:toLowerCase(hd.phuongThucThanhToan)}
                                                         ${fn:toLowerCase(hd.hinhThuc)}
                                                         ${hd.maBan}">

                                            <td class="invoice-code">
                                                ${hd.maHienThi}
                                            </td>

                                            <td>
                                                ${hd.ngayThanhToan}
                                            </td>

                                            <td>

                                                <c:choose>

                                                    <c:when test="${hd.hinhThuc == 'Mang về'}">

                                                        <span class="badge badge-takeaway">
                                                            <i class="fa-solid fa-bag-shopping"></i>
                                                            Mang về
                                                        </span>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="badge badge-table">
                                                            <i class="fa-solid fa-chair"></i>
                                                            Tại bàn
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </td>

                                            <td>

                                                <c:choose>

                                                    <c:when test="${empty hd.maBan}">
                                                        —
                                                    </c:when>

                                                    <c:otherwise>
                                                        Bàn ${hd.maBan}
                                                    </c:otherwise>

                                                </c:choose>

                                            </td>

                                            <td>
                                                ${empty hd.tenKhachHang
                                                    ? 'Khách lẻ'
                                                    : hd.tenKhachHang}
                                            </td>

                                            <td>
                                                ${hd.maNV}
                                            </td>

                                            <td>

                                                <c:choose>

                                                    <c:when test="${hd.phuongThucThanhToan == 'Tiền mặt'}">

                                                        <span class="badge badge-cash">
                                                            <i class="fa-solid fa-money-bill"></i>
                                                            Tiền mặt
                                                        </span>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="badge badge-other">
                                                            <i class="fa-solid fa-wallet"></i>

                                                            ${empty hd.phuongThucThanhToan
                                                                ? 'Khác'
                                                                : hd.phuongThucThanhToan}
                                                        </span>

                                                    </c:otherwise>

                                                </c:choose>

                                            </td>

                                            <td class="money">

                                                <fmt:formatNumber
                                                    value="${empty hd.tongTien
                                                        ? 0
                                                        : hd.tongTien}"
                                                    pattern="#,##0"/>

                                                đ
                                            </td>

                                        </tr>

                                    </c:forEach>

                                    <tr id="noSearchResult"
                                        style="display:none;">

                                        <td colspan="8"
                                            class="empty-row">

                                            <i class="fa-solid fa-magnifying-glass"></i>

                                            Không tìm thấy hóa đơn phù hợp.
                                        </td>
                                    </tr>

                                </c:when>

                                <c:otherwise>

                                    <tr>

                                        <td colspan="8"
                                            class="empty-row">

                                            <i class="fa-regular fa-file-lines"></i>

                                            Không có hóa đơn đã thanh toán
                                            trong khoảng thời gian này.
                                        </td>

                                    </tr>

                                </c:otherwise>

                            </c:choose>

                        </tbody>

                    </table>

                </div>

                <div class="table-footer">

                    Hiển thị
                    ${fn:length(dsThongKe)}
                    hóa đơn đã thanh toán từ
                    <b>${tuNgay}</b>
                    đến
                    <b>${denNgay}</b>.
                </div>

            </section>

        </div>

    </main>

    <script>
        document.addEventListener(
            "DOMContentLoaded",
            function () {

                const searchInput =
                    document.getElementById(
                        "invoiceSearch"
                    );

                const invoiceRows =
                    document.querySelectorAll(
                        "#invoiceRows tr[data-search]"
                    );

                const noSearchResult =
                    document.getElementById(
                        "noSearchResult"
                    );

                function normalizeText(value) {
                    return String(value || "")
                        .toLowerCase()
                        .normalize("NFD")
                        .replace(
                            /[\u0300-\u036f]/g,
                            ""
                        );
                }

                if (searchInput) {
                    searchInput.addEventListener(
                        "input",
                        function () {

                            const keyword =
                                normalizeText(
                                    searchInput.value.trim()
                                );

                            let visibleCount = 0;

                            invoiceRows.forEach(
                                function (row) {

                                    const rowData =
                                        normalizeText(
                                            row.dataset.search
                                        );

                                    const visible =
                                        keyword === ""
                                        || rowData.includes(
                                            keyword
                                        );

                                    row.style.display =
                                        visible
                                            ? ""
                                            : "none";

                                    if (visible) {
                                        visibleCount++;
                                    }
                                }
                            );

                            if (noSearchResult) {
                                noSearchResult.style.display =
                                    visibleCount === 0
                                        ? ""
                                        : "none";
                            }
                        }
                    );
                }

                const chartElement =
                    document.getElementById(
                        "revenueChart"
                    );

                if (
                    chartElement
                    && typeof Chart !== "undefined"
                ) {
                    const labels = [

                        <c:forEach var="item"
                                   items="${dsDoanhThuNgay}"
                                   varStatus="status">

                            "${item.ngay}"

                            <c:if test="${not status.last}">
                                ,
                            </c:if>

                        </c:forEach>

                    ];

                    const revenueData = [

                        <c:forEach var="item"
                                   items="${dsDoanhThuNgay}"
                                   varStatus="status">

                            ${empty item.doanhThu
                                ? 0
                                : item.doanhThu}

                            <c:if test="${not status.last}">
                                ,
                            </c:if>

                        </c:forEach>

                    ];

                    const invoiceCountData = [

                        <c:forEach var="item"
                                   items="${dsDoanhThuNgay}"
                                   varStatus="status">

                            ${item.soHoaDon}

                            <c:if test="${not status.last}">
                                ,
                            </c:if>

                        </c:forEach>

                    ];

                    new Chart(
                        chartElement,
                        {
                            type: "bar",

                            data: {
                                labels: labels,

                                datasets: [
                                    {
                                        label: "Doanh thu",

                                        data: revenueData,

                                        borderWidth: 1,

                                        borderRadius: 5,

                                        yAxisID: "revenue"
                                    },

                                    {
                                        type: "line",

                                        label: "Số hóa đơn",

                                        data: invoiceCountData,

                                        tension: 0.25,

                                        borderWidth: 2,

                                        yAxisID: "invoiceCount"
                                    }
                                ]
                            },

                            options: {
                                responsive: true,

                                maintainAspectRatio: false,

                                interaction: {
                                    mode: "index",
                                    intersect: false
                                },

                                plugins: {
                                    tooltip: {
                                        callbacks: {
                                            label: function (
                                                context
                                            ) {
                                                if (
                                                    context.dataset
                                                        .yAxisID
                                                    === "revenue"
                                                ) {
                                                    return (
                                                        " Doanh thu: "
                                                        + Number(
                                                            context.raw
                                                        )
                                                        .toLocaleString(
                                                            "vi-VN"
                                                        )
                                                        + "đ"
                                                    );
                                                }

                                                return (
                                                    " Số hóa đơn: "
                                                    + context.raw
                                                );
                                            }
                                        }
                                    }
                                },

                                scales: {
                                    revenue: {
                                        type: "linear",
                                        position: "left",
                                        beginAtZero: true,

                                        ticks: {
                                            callback: function (
                                                value
                                            ) {
                                                return Number(
                                                    value
                                                ).toLocaleString(
                                                    "vi-VN"
                                                ) + "đ";
                                            }
                                        }
                                    },

                                    invoiceCount: {
                                        type: "linear",
                                        position: "right",
                                        beginAtZero: true,

                                        grid: {
                                            drawOnChartArea: false
                                        },

                                        ticks: {
                                            precision: 0
                                        }
                                    }
                                }
                            }
                        }
                    );
                }
            }
        );
    </script>

</body>
</html>