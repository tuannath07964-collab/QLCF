<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<%@ taglib prefix="fn"
           uri="jakarta.tags.functions" %>

<%
    if (
        session.getAttribute("maNV")
        == null
    ) {
        response.sendRedirect(
                request.getContextPath()
                + "/LoginServlet"
        );

        return;
    }

    /*
     * Các trang cũ đang dẫn trực tiếp tới
     * /views/homepage.jsp.
     *
     * Đoạn này sẽ tự chuyển qua HomepageServlet
     * để lấy dữ liệu thật rồi mới quay lại JSP.
     */
    if (
        request.getAttribute(
                "homepageLoaded"
        ) == null
    ) {
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

    <title>
        Trang chủ - Quản lý quán Cafe
    </title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        * {
            box-sizing: border-box;
        }

        :root {
            --sidebar: #2d4358;
            --sidebar-hover: #38536b;
            --active: #3498db;
            --red: #ef4b3f;
            --green: #198754;
            --orange: #d97706;
            --blue: #1976a8;
            --text: #263746;
            --muted: #74818c;
            --border: #e5eaee;
            --background: #f4f7f9;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background: var(--background);
            color: var(--text);
            font-family:
                Arial,
                Helvetica,
                sans-serif;
        }

        a {
            color: inherit;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
            width: 290px;
            height: 100vh;
            background: var(--sidebar);
            color: white;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 9px;
            min-height: 70px;
            padding: 0 22px;
            border-bottom:
                1px solid
                rgba(255, 255, 255, .12);
            font-weight: 800;
        }

        .brand i {
            font-size: 19px;
        }

        .menu {
            flex: 1;
            margin: 0;
            padding: 110px 0 20px;
            list-style: none;
        }

        .menu li {
            display: flex;
            align-items: center;
            gap: 12px;
            min-height: 55px;
            padding: 0 26px;
            border-left:
                4px solid transparent;
            cursor: pointer;
            transition: .2s;
        }

        .menu li:hover {
            background:
                rgba(255, 255, 255, .08);
        }

        .menu li.active {
            border-left-color: white;
            background: var(--active);
        }

        .menu li i {
            width: 20px;
            text-align: center;
        }

        .logout {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 70px;
            background: var(--red);
            color: white;
            text-decoration: none;
            font-weight: 700;
        }

        .main {
            min-height: 100vh;
            margin-left: 290px;
        }

        .topbar {
            position: sticky;
            top: 0;
            z-index: 50;
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 72px;
            padding: 0 34px;
            border-bottom:
                1px solid var(--border);
            background: white;
            box-shadow:
                0 2px 8px
                rgba(0, 0, 0, .04);
        }

        .topbar h2 {
            margin: 0;
            font-size: 26px;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .refresh-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 39px;
            height: 39px;
            border: 1px solid var(--border);
            border-radius: 9px;
            background: white;
            color: var(--sidebar);
            text-decoration: none;
        }

        .refresh-button:hover {
            background: #eef3f6;
        }

        .account {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
        }

        .account-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #edf3f7;
            color: var(--sidebar);
        }

        .content {
            padding: 30px 34px 45px;
        }

        .message-error {
            margin-bottom: 20px;
            padding: 13px 16px;
            border:
                1px solid #f5c2c7;
            border-radius: 9px;
            background: #f8d7da;
            color: #842029;
            font-weight: 600;
        }

        .welcome {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 25px;
            min-height: 180px;
            margin-bottom: 24px;
            padding: 30px 34px;
            border-radius: 18px;
            background:
                linear-gradient(
                    135deg,
                    #2d4358,
                    #3f6785
                );
            color: white;
            box-shadow:
                0 8px 22px
                rgba(45, 67, 88, .18);
        }

        .welcome::after {
            position: absolute;
            right: -50px;
            bottom: -85px;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background:
                rgba(255, 255, 255, .08);
            content: "";
        }

        .welcome-text {
            position: relative;
            z-index: 1;
        }

        .welcome-text h1 {
            margin: 0 0 11px;
            font-size: 31px;
        }

        .welcome-text p {
            max-width: 650px;
            margin: 0;
            color:
                rgba(255, 255, 255, .82);
            line-height: 1.6;
        }

        .shift-box {
            position: relative;
            z-index: 1;
            min-width: 290px;
            padding: 18px 20px;
            border:
                1px solid
                rgba(255, 255, 255, .16);
            border-radius: 13px;
            background:
                rgba(255, 255, 255, .1);
        }

        .shift-box h4 {
            margin: 0 0 13px;
            font-size: 15px;
        }

        .shift-line {
            display: flex;
            align-items: center;
            gap: 9px;
            margin: 8px 0;
            font-size: 13px;
        }

        .shift-line i {
            width: 18px;
            text-align: center;
        }

        .shift-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 7px;
            padding: 6px 10px;
            border-radius: 999px;
            background:
                rgba(255, 255, 255, .16);
            font-size: 12px;
            font-weight: 700;
        }

        .shift-status::before {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #6ee7a5;
            content: "";
        }

        .shift-status.off::before {
            background: #ffd166;
        }

        .summary-grid {
            display: grid;
            grid-template-columns:
                repeat(
                    6,
                    minmax(150px, 1fr)
                );
            gap: 15px;
            margin-bottom: 25px;
        }

        .summary-card {
            min-width: 0;
            padding: 18px;
            border:
                1px solid var(--border);
            border-radius: 14px;
            background: white;
            box-shadow:
                0 3px 10px
                rgba(0, 0, 0, .045);
        }

        .summary-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 14px;
        }

        .summary-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 11px;
            font-size: 17px;
        }

        .summary-icon.green {
            background: #d1e7dd;
            color: #0f5132;
        }

        .summary-icon.red {
            background: #f8d7da;
            color: #842029;
        }

        .summary-icon.blue {
            background: #cfe2ff;
            color: #084298;
        }

        .summary-icon.orange {
            background: #fff3cd;
            color: #664d03;
        }

        .summary-icon.purple {
            background: #eadcff;
            color: #5d2b90;
        }

        .summary-icon.gray {
            background: #e9ecef;
            color: #41464b;
        }

        .summary-card span {
            display: block;
            overflow: hidden;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .summary-card strong {
            display: block;
            margin-top: 8px;
            color: var(--text);
            font-size: 23px;
        }

        .section-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 16px;
        }

        .section-header h3 {
            margin: 0;
            font-size: 21px;
        }

        .section-header p {
            margin: 5px 0 0;
            color: var(--muted);
            font-size: 13px;
        }

        .view-all {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            color: var(--blue);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns:
                minmax(0, 1.6fr)
                minmax(320px, .7fr);
            gap: 19px;
            margin-bottom: 25px;
        }

        .panel {
            padding: 22px;
            border:
                1px solid var(--border);
            border-radius: 15px;
            background: white;
            box-shadow:
                0 3px 12px
                rgba(0, 0, 0, .045);
        }

        .table-legend {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 17px;
            color: var(--muted);
            font-size: 12px;
        }

        .legend-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .legend-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
        }

        .legend-dot.empty {
            background: #28a76a;
        }

        .legend-dot.serving {
            background: #ef4b3f;
        }

        .legend-dot.attention {
            background: #e2a10a;
        }

        .mini-table-grid {
            display: grid;
            grid-template-columns:
                repeat(
                    5,
                    minmax(105px, 1fr)
                );
            gap: 11px;
        }

        .table-mini {
            display: flex;
            min-height: 105px;
            flex-direction: column;
            justify-content: space-between;
            padding: 12px;
            border:
                1px solid var(--border);
            border-left:
                4px solid #28a76a;
            border-radius: 10px;
            background: #fbfcfd;
            color: var(--text);
            text-decoration: none;
            transition: .2s;
        }

        .table-mini:hover {
            transform: translateY(-2px);
            box-shadow:
                0 6px 14px
                rgba(0, 0, 0, .08);
        }

        .table-mini.serving {
            border-left-color: #ef4b3f;
            background: #fff8f7;
        }

        .table-mini.attention {
            border-left-color: #e2a10a;
            background: #fffaf0;
        }

        .table-mini-name {
            font-size: 14px;
            font-weight: 800;
        }

        .table-mini-location {
            margin-top: 5px;
            color: var(--muted);
            font-size: 11px;
        }

        .table-mini-status {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 7px;
            margin-top: 13px;
            font-size: 11px;
            font-weight: 700;
        }

        .table-mini-status i {
            font-size: 10px;
        }

        .inventory-list {
            display: grid;
            gap: 11px;
        }

        .inventory-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 13px;
            padding: 13px 14px;
            border-radius: 10px;
            background: #f7f9fa;
        }

        .inventory-name {
            min-width: 0;
        }

        .inventory-name strong {
            display: block;
            overflow: hidden;
            margin-bottom: 4px;
            font-size: 13px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .inventory-name span {
            color: var(--muted);
            font-size: 11px;
        }

        .stock-value {
            text-align: right;
            white-space: nowrap;
        }

        .stock-value strong {
            display: block;
            font-size: 13px;
        }

        .stock-level {
            display: inline-block;
            margin-top: 5px;
            padding: 4px 7px;
            border-radius: 999px;
            font-size: 10px;
            font-weight: 700;
        }

        .stock-level.warning {
            background: #fff3cd;
            color: #664d03;
        }

        .stock-level.critical {
            background: #ffe0b2;
            color: #8a4b00;
        }

        .stock-level.danger {
            background: #f8d7da;
            color: #842029;
        }

        .empty-panel {
            padding: 35px 15px;
            color: var(--muted);
            text-align: center;
        }

        .empty-panel i {
            display: block;
            margin-bottom: 10px;
            color: #9faab3;
            font-size: 34px;
        }

        .orders-panel {
            margin-bottom: 25px;
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 800px;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 13px 14px;
            border-bottom:
                1px solid #edf0f2;
            text-align: left;
            font-size: 13px;
        }

        th {
            background: #f7f9fa;
            color: #64717c;
            font-size: 11px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        tbody tr:hover {
            background: #fbfcfd;
        }

        .invoice-code {
            color: var(--sidebar);
            font-weight: 800;
        }

        .order-type {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 8px;
            border-radius: 999px;
            background: #e7f1ff;
            color: #084298;
            font-size: 11px;
            font-weight: 700;
        }

        .order-type.takeaway {
            background: #fff3cd;
            color: #664d03;
        }

        .money {
            color: var(--green);
            font-weight: 800;
            white-space: nowrap;
        }

        .btn-open {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 10px;
            border-radius: 7px;
            background: var(--sidebar);
            color: white;
            text-decoration: none;
            font-size: 11px;
            font-weight: 700;
        }

        .quick-grid {
            display: grid;
            grid-template-columns:
                repeat(
                    4,
                    minmax(190px, 1fr)
                );
            gap: 15px;
        }

        .quick-card {
            display: flex;
            align-items: center;
            gap: 13px;
            min-height: 85px;
            padding: 16px;
            border:
                1px solid var(--border);
            border-radius: 13px;
            background: white;
            color: var(--text);
            text-decoration: none;
            box-shadow:
                0 3px 10px
                rgba(0, 0, 0, .04);
            transition: .2s;
        }

        .quick-card:hover {
            border-color: #aac0ce;
            transform: translateY(-2px);
        }

        .quick-icon {
            display: flex;
            flex: 0 0 43px;
            align-items: center;
            justify-content: center;
            width: 43px;
            height: 43px;
            border-radius: 11px;
            background: #edf3f7;
            color: var(--sidebar);
            font-size: 18px;
        }

        .quick-card strong {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }

        .quick-card span {
            display: block;
            color: var(--muted);
            font-size: 11px;
            line-height: 1.4;
        }

        @media (max-width: 1350px) {
            .summary-grid {
                grid-template-columns:
                    repeat(
                        3,
                        minmax(160px, 1fr)
                    );
            }

            .mini-table-grid {
                grid-template-columns:
                    repeat(
                        4,
                        minmax(105px, 1fr)
                    );
            }
        }

        @media (max-width: 1050px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .quick-grid {
                grid-template-columns:
                    repeat(
                        2,
                        minmax(190px, 1fr)
                    );
            }

            .mini-table-grid {
                grid-template-columns:
                    repeat(
                        5,
                        minmax(105px, 1fr)
                    );
            }
        }

        @media (max-width: 850px) {
            .sidebar {
                position: static;
                width: 100%;
                height: auto;
            }

            .menu {
                padding: 12px 0;
            }

            .main {
                margin-left: 0;
            }

            .topbar {
                position: static;
                padding: 0 18px;
            }

            .content {
                padding: 20px 15px 30px;
            }

            .welcome {
                align-items: flex-start;
                flex-direction: column;
                padding: 25px;
            }

            .shift-box {
                width: 100%;
                min-width: 0;
            }

            .summary-grid {
                grid-template-columns:
                    repeat(
                        2,
                        minmax(150px, 1fr)
                    );
            }

            .mini-table-grid {
                grid-template-columns:
                    repeat(
                        3,
                        minmax(100px, 1fr)
                    );
            }
        }

        @media (max-width: 570px) {
            .account span {
                display: none;
            }

            .summary-grid,
            .quick-grid {
                grid-template-columns: 1fr;
            }

            .mini-table-grid {
                grid-template-columns:
                    repeat(
                        2,
                        minmax(100px, 1fr)
                    );
            }

            .section-header {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

    <aside class="sidebar">

        <div class="brand">
            <i class="fa-solid fa-mug-hot"></i>
            QUẢN LÝ QUÁN CAFE
        </div>

        <ul class="menu">

            <li class="active"
                onclick="location.href='${pageContext.request.contextPath}/homepage'">

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

            <c:if test="${sessionScope.chucVu == 'Quản lý'}">

                <li onclick="location.href='${pageContext.request.contextPath}/ThongKeServlet'">

                    <i class="fa-solid fa-chart-column"></i>
                    <span>Thống kê</span>
                </li>

            </c:if>

        </ul>

        <a class="logout"
           href="${pageContext.request.contextPath}/LogoutServlet">

            <i class="fa-solid fa-right-from-bracket"></i>
            Đăng xuất
        </a>

    </aside>

    <main class="main">

        <header class="topbar">

            <h2>Trang chủ</h2>

            <div class="topbar-right">

                <a class="refresh-button"
                   href="${pageContext.request.contextPath}/homepage"
                   title="Tải lại dữ liệu">

                    <i class="fa-solid fa-rotate-right"></i>
                </a>

                <div class="account">

                    <div class="account-icon">
                        <i class="fa-solid fa-user"></i>
                    </div>

                    <span>
                        ${sessionScope.maNV}
                        -
                        ${sessionScope.tenNV}
                    </span>

                </div>

            </div>

        </header>

        <div class="content">

            <c:if test="${not empty errorMessage}">

                <div class="message-error">

                    <i class="fa-solid fa-circle-exclamation"></i>

                    ${errorMessage}
                </div>

            </c:if>

            <section class="welcome">

                <div class="welcome-text">

                    <h1>
                        Xin chào,
                        ${sessionScope.tenNV}
                    </h1>

                    <p>
                        Đây là tình trạng vận hành hiện tại
                        của quán. M có thể nhận bàn, tiếp tục
                        xử lý hóa đơn và kiểm tra các cảnh báo
                        cần chú ý ngay trên trang này.
                    </p>

                </div>

                <div class="shift-box">

                    <h4>
                        <i class="fa-regular fa-clock"></i>
                        Ca làm hiện tại
                    </h4>

                    <c:choose>

                        <c:when test="${caLamHienTai.quanLy}">

                            <div class="shift-line">

                                <i class="fa-solid fa-user-shield"></i>

                                <span>
                                    Vai trò:
                                    <b>Quản lý</b>
                                </span>
                            </div>

                            <div class="shift-line">

                                <i class="fa-solid fa-key"></i>

                                <span>
                                    Được truy cập ngoài giờ ca
                                </span>
                            </div>

                        </c:when>

                        <c:otherwise>

                            <div class="shift-line">

                                <i class="fa-solid fa-calendar-day"></i>

                                <span>
                                    ${caLamHienTai.tenCa}
                                </span>
                            </div>

                            <div class="shift-line">

                                <i class="fa-regular fa-clock"></i>

                                <span>
                                    ${caLamHienTai.gioBatDauHienThi}
                                    -
                                    ${caLamHienTai.gioKetThucHienThi}
                                </span>
                            </div>

                        </c:otherwise>

                    </c:choose>

                    <div class="shift-line">

                        <i class="fa-regular fa-calendar"></i>

                        <span id="currentDateTime">
                            --/--/---- --:--
                        </span>
                    </div>

                    <span class="shift-status
                          ${caLamHienTai.trongCa
                            ? ''
                            : 'off'}">

                        <c:choose>

                            <c:when test="${caLamHienTai.trongCa}">
                                Đang trong ca làm
                            </c:when>

                            <c:otherwise>
                                Ngoài thời gian ca
                            </c:otherwise>

                        </c:choose>

                    </span>

                </div>

            </section>

            <section class="summary-grid">

                <div class="summary-card">

                    <div class="summary-top">

                        <div class="summary-icon green">
                            <i class="fa-solid fa-chair"></i>
                        </div>

                    </div>

                    <span>Bàn trống</span>

                    <strong>
                        ${tongQuan.banTrong}
                        /
                        ${tongQuan.tongBan}
                    </strong>

                </div>

                <div class="summary-card">

                    <div class="summary-top">

                        <div class="summary-icon red">
                            <i class="fa-solid fa-mug-hot"></i>
                        </div>

                    </div>

                    <span>Bàn đang phục vụ</span>

                    <strong>
                        ${tongQuan.banDangPhucVu}
                    </strong>

                </div>

                <div class="summary-card">

                    <div class="summary-top">

                        <div class="summary-icon blue">
                            <i class="fa-solid fa-file-invoice"></i>
                        </div>

                    </div>

                    <span>Đơn đang xử lý</span>

                    <strong>
                        ${tongQuan.donDangXuLy}
                    </strong>

                </div>

                <div class="summary-card">

                    <div class="summary-top">

                        <div class="summary-icon orange">
                            <i class="fa-solid fa-box-open"></i>
                        </div>

                    </div>

                    <span>Kho cần chú ý</span>

                    <strong>
                        ${tongQuan.nguyenLieuCanXuLy}
                    </strong>

                </div>

                <div class="summary-card">

                    <div class="summary-top">

                        <div class="summary-icon purple">
                            <i class="fa-solid fa-users"></i>
                        </div>

                    </div>

                    <span>Nhân viên trong ca</span>

                    <strong>
                        ${tongQuan.nhanVienTrongCa}
                    </strong>

                </div>

                <div class="summary-card">

                    <div class="summary-top">

                        <div class="summary-icon gray">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>

                    </div>

                    <span>Bàn cần cập nhật</span>

                    <strong>
                        ${tongQuan.banCanXuLy}
                    </strong>

                </div>

            </section>

            <section class="dashboard-grid">

                <div class="panel">

                    <div class="section-header">

                        <div>
                            <h3>Sơ đồ bàn</h3>

                            <p>
                                Bấm vào bàn để nhận bàn
                                hoặc mở hóa đơn đang phục vụ
                            </p>
                        </div>

                        <a class="view-all"
                           href="${pageContext.request.contextPath}/ban">

                            Xem toàn bộ bàn
                            <i class="fa-solid fa-arrow-right"></i>
                        </a>

                    </div>

                    <div class="table-legend">

                        <span class="legend-item">

                            <span class="legend-dot empty"></span>
                            Trống
                        </span>

                        <span class="legend-item">

                            <span class="legend-dot serving"></span>
                            Đang phục vụ
                        </span>

                        <span class="legend-item">

                            <span class="legend-dot attention"></span>
                            Cần cập nhật
                        </span>

                    </div>

                    <c:choose>

                        <c:when test="${not empty danhSachBanTrangChu}">

                            <div class="mini-table-grid">

                                <c:forEach var="ban"
                                           items="${danhSachBanTrangChu}">

                                    <c:choose>

                                        <c:when test="${ban.trangThai == 0}">

                                            <c:url var="banLink"
                                                   value="/ban/nhanban">

                                                <c:param name="id"
                                                         value="${ban.maBan}"/>
                                            </c:url>

                                            <c:set var="banAction"
                                                   value="Nhận bàn"/>

                                        </c:when>

                                        <c:when test="${ban.trangThai == 1}">

                                            <c:choose>

                                                <c:when test="${not empty ban.maHD}">

                                                    <c:url var="banLink"
                                                           value="/hoadon">

                                                        <c:param name="action"
                                                                 value="edit"/>

                                                        <c:param name="maHD"
                                                                 value="${ban.maHD}"/>
                                                    </c:url>

                                                </c:when>

                                                <c:otherwise>

                                                    <c:url var="banLink"
                                                           value="/ban/traban">

                                                        <c:param name="id"
                                                                 value="${ban.maBan}"/>
                                                    </c:url>

                                                </c:otherwise>

                                            </c:choose>

                                            <c:set var="banAction"
                                                   value="Mở hóa đơn"/>

                                        </c:when>

                                        <c:otherwise>

                                            <c:url var="banLink"
                                                   value="/ban"/>

                                            <c:set var="banAction"
                                                   value="Kiểm tra bàn"/>

                                        </c:otherwise>

                                    </c:choose>

                                    <a class="table-mini ${ban.cssClass}"
                                       href="${banLink}"
                                       title="${banAction}">

                                        <div>

                                            <div class="table-mini-name">
                                                ${ban.tenBan}
                                            </div>

                                            <div class="table-mini-location">

                                                ${ban.khuVuc}
                                                ·
                                                ${ban.soCho} chỗ
                                            </div>

                                        </div>

                                        <div class="table-mini-status">

                                            <span>
                                                <i class="fa-solid fa-circle"></i>
                                                ${ban.trangThaiText}
                                            </span>

                                            <i class="fa-solid fa-chevron-right"></i>
                                        </div>

                                    </a>

                                </c:forEach>

                            </div>

                        </c:when>

                        <c:otherwise>

                            <div class="empty-panel">

                                <i class="fa-solid fa-chair"></i>

                                Không tải được danh sách bàn.
                            </div>

                        </c:otherwise>

                    </c:choose>

                </div>

                <div class="panel">

                    <div class="section-header">

                        <div>
                            <h3>Cảnh báo kho</h3>

                            <p>
                                Nguyên liệu còn từ 10 đơn vị trở xuống
                            </p>
                        </div>

                        <a class="view-all"
                           href="${pageContext.request.contextPath}/KhoServlet">

                            Mở kho
                            <i class="fa-solid fa-arrow-right"></i>
                        </a>

                    </div>

                    <c:choose>

                        <c:when test="${not empty canhBaoKho}">

                            <div class="inventory-list">

                                <c:forEach var="item"
                                           items="${canhBaoKho}">

                                    <div class="inventory-item">

                                        <div class="inventory-name">

                                            <strong>
                                                ${item.tenNL}
                                            </strong>

                                            <span>
                                                ${item.maNL}
                                            </span>

                                        </div>

                                        <div class="stock-value">

                                            <strong>

                                                <fmt:formatNumber
                                                    value="${item.soLuong}"
                                                    pattern="#,##0.##"/>

                                                ${item.donVi}
                                            </strong>

                                            <span class="stock-level ${item.cssClass}">
                                                ${item.mucDo}
                                            </span>

                                        </div>

                                    </div>

                                </c:forEach>

                            </div>

                        </c:when>

                        <c:otherwise>

                            <div class="empty-panel">

                                <i class="fa-solid fa-circle-check"></i>

                                Kho hiện không có nguyên liệu
                                nào ở mức cảnh báo.
                            </div>

                        </c:otherwise>

                    </c:choose>

                </div>

            </section>

            <section class="panel orders-panel">

                <div class="section-header">

                    <div>
                        <h3>Đơn đang xử lý gần nhất</h3>

                        <p>
                            Các hóa đơn chưa thanh toán
                            hoặc chưa hủy
                        </p>
                    </div>

                    <a class="view-all"
                       href="${pageContext.request.contextPath}/hoadon">

                        Xem tất cả hóa đơn
                        <i class="fa-solid fa-arrow-right"></i>
                    </a>

                </div>

                <div class="table-responsive">

                    <table>

                        <thead>
                            <tr>
                                <th>Mã hóa đơn</th>
                                <th>Hình thức</th>
                                <th>Khách hàng</th>
                                <th>Nhân viên</th>
                                <th>Ngày tạo</th>
                                <th>Tạm tính</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:choose>

                                <c:when test="${not empty donDangXuLy}">

                                    <c:forEach var="don"
                                               items="${donDangXuLy}">

                                        <c:url var="invoiceLink"
                                               value="/hoadon">

                                            <c:param name="action"
                                                     value="edit"/>

                                            <c:param name="maHD"
                                                     value="${don.maHD}"/>
                                        </c:url>

                                        <tr>

                                            <td class="invoice-code">
                                                ${don.maHienThi}
                                            </td>

                                            <td>

                                                <span class="order-type
                                                      ${don.hinhThuc == 'Mang về'
                                                        ? 'takeaway'
                                                        : ''}">

                                                    <i class="fa-solid
                                                       ${don.hinhThuc == 'Mang về'
                                                         ? 'fa-bag-shopping'
                                                         : 'fa-chair'}"></i>

                                                    ${don.viTriPhucVu}
                                                </span>

                                            </td>

                                            <td>
                                                ${empty don.tenKhachHang
                                                    ? 'Khách lẻ'
                                                    : don.tenKhachHang}
                                            </td>

                                            <td>
                                                ${don.maNV}
                                            </td>

                                            <td>
                                                ${don.ngayTao}
                                            </td>

                                            <td class="money">

                                                <fmt:formatNumber
                                                    value="${don.tongTien}"
                                                    pattern="#,##0"/>

                                                đ
                                            </td>

                                            <td>

                                                <a class="btn-open"
                                                   href="${invoiceLink}">

                                                    <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                                    Mở đơn
                                                </a>

                                            </td>

                                        </tr>

                                    </c:forEach>

                                </c:when>

                                <c:otherwise>

                                    <tr>

                                        <td colspan="7">

                                            <div class="empty-panel">

                                                <i class="fa-regular fa-file-lines"></i>

                                                Hiện không có đơn nào
                                                đang xử lý.
                                            </div>

                                        </td>

                                    </tr>

                                </c:otherwise>

                            </c:choose>

                        </tbody>

                    </table>

                </div>

            </section>

            <div class="section-header">

                <div>
                    <h3>Thao tác nhanh</h3>

                    <p>
                        Các chức năng thường dùng trong ca làm
                    </p>
                </div>

            </div>

            <section class="quick-grid">

                <a class="quick-card"
                   href="${pageContext.request.contextPath}/ban">

                    <div class="quick-icon">
                        <i class="fa-solid fa-chair"></i>
                    </div>

                    <div>
                        <strong>Bán tại bàn</strong>

                        <span>
                            Chọn và nhận bàn trống
                        </span>
                    </div>

                </a>

                <a class="quick-card"
                   href="${pageContext.request.contextPath}/hoadon?action=takeaway">

                    <div class="quick-icon">
                        <i class="fa-solid fa-bag-shopping"></i>
                    </div>

                    <div>
                        <strong>Bán mang về</strong>

                        <span>
                            Tạo đơn không cần chọn bàn
                        </span>
                    </div>

                </a>

                <a class="quick-card"
                   href="${pageContext.request.contextPath}/hoadon">

                    <div class="quick-icon">
                        <i class="fa-solid fa-file-invoice-dollar"></i>
                    </div>

                    <div>
                        <strong>Danh sách hóa đơn</strong>

                        <span>
                            Kiểm tra trạng thái các đơn
                        </span>
                    </div>

                </a>

                <c:choose>

                    <c:when test="${sessionScope.chucVu == 'Quản lý'}">

                        <a class="quick-card"
                           href="${pageContext.request.contextPath}/ThongKeServlet">

                            <div class="quick-icon">
                                <i class="fa-solid fa-chart-column"></i>
                            </div>

                            <div>
                                <strong>Báo cáo doanh thu</strong>

                                <span>
                                    Xem thống kê dành cho quản lý
                                </span>
                            </div>

                        </a>

                    </c:when>

                    <c:otherwise>

                        <a class="quick-card"
                           href="${pageContext.request.contextPath}/KhoServlet">

                            <div class="quick-icon">
                                <i class="fa-solid fa-box"></i>
                            </div>

                            <div>
                                <strong>Kiểm tra kho</strong>

                                <span>
                                    Xem tình trạng nguyên liệu
                                </span>
                            </div>

                        </a>

                    </c:otherwise>

                </c:choose>

            </section>

        </div>

    </main>

    <script>
        function updateDateTime() {

            const element =
                    document.getElementById(
                            "currentDateTime"
                    );

            if (!element) {
                return;
            }

            const now =
                    new Date();

            element.textContent =
                    now.toLocaleString(
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

        setInterval(
                updateDateTime,
                1000
        );
    </script>

</body>
</html>