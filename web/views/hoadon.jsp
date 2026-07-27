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

    <title>Quản lý hóa đơn</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            background: #f4f6f9;
            color: #263238;
            font-family: "Inter", sans-serif;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 260px;
            height: 100vh;
            display: flex;
            flex-direction: column;
            background: #2c3e50;
            color: white;
            z-index: 100;
        }

        .brand {
            padding: 25px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, .12);
            font-family: "Playfair Display", serif;
            font-size: 18px;
            font-weight: 700;
        }

        .brand i {
            margin-right: 8px;
        }

        .menu {
            list-style: none;
            padding: 18px 0;
            margin: 0;
            flex: 1;
        }

        .menu li {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 22px;
            cursor: pointer;
            transition: .2s;
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
            color: #ff9f9f;
            text-decoration: none;
            border-top: 1px solid rgba(255, 255, 255, .12);
        }

        .main-content {
            width: calc(100% - 260px);
            min-height: 100vh;
            margin-left: 260px;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 24px;
        }

        .page-header h1 {
            margin: 0;
            font-family: "Playfair Display", serif;
            font-size: 30px;
            color: #253746;
        }

        .page-header p {
            margin: 6px 0 0;
            color: #75808a;
            font-size: 14px;
        }

        .btn-add {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 17px;
            border: none;
            border-radius: 9px;
            background: #198754;
            color: white;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 3px 8px rgba(25, 135, 84, .2);
        }

        .btn-add:hover {
            background: #157347;
        }

        .message {
            margin-bottom: 20px;
            padding: 13px 16px;
            border-radius: 9px;
            font-weight: 600;
        }

        .message.error {
            background: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }

        .message.success {
            background: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
        }

        .toolbar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px;
            padding: 15px;
            margin-bottom: 22px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .04);
        }

        .search-box {
            position: relative;
            flex: 1;
            min-width: 240px;
        }

        .search-box i {
            position: absolute;
            top: 50%;
            left: 13px;
            transform: translateY(-50%);
            color: #7c8791;
        }

        .search-box input {
            width: 100%;
            height: 40px;
            padding: 0 14px 0 39px;
            border: 1px solid #dfe4e8;
            border-radius: 8px;
            font-family: inherit;
            outline: none;
        }

        .search-box input:focus {
            border-color: #806044;
            box-shadow: 0 0 0 3px rgba(128, 96, 68, .1);
        }

        .filter-btn {
            height: 40px;
            padding: 0 15px;
            border: 1px solid #dfe4e8;
            border-radius: 8px;
            background: white;
            color: #4a5560;
            font-family: inherit;
            font-weight: 600;
            cursor: pointer;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: #2c3e50;
            color: white;
            border-color: #2c3e50;
        }

        .invoice-grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fill, minmax(290px, 1fr));
            gap: 20px;
        }

        .invoice-card {
            display: flex;
            flex-direction: column;
            min-height: 260px;
            padding: 20px;
            background: white;
            border: 1px solid #edf0f2;
            border-top: 4px solid #e67e22;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, .05);
            transition: transform .2s, box-shadow .2s;
        }

        .invoice-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 18px rgba(0, 0, 0, .09);
        }

        .invoice-card.paid {
            border-top-color: #198754;
        }

        .invoice-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 18px;
        }

        .invoice-code {
            color: #2c3e50;
            font-size: 19px;
            font-weight: 800;
        }

        .status {
            display: inline-flex;
            align-items: center;
            padding: 5px 10px;
            border-radius: 20px;
            background: #fff0dc;
            color: #b45309;
            font-size: 11px;
            font-weight: 700;
        }

        .status.paid {
            background: #d1e7dd;
            color: #0f5132;
        }

        .invoice-info {
            flex: 1;
        }

        .invoice-info p {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 9px 0;
            color: #56616b;
            font-size: 14px;
        }

        .invoice-info p i {
            width: 18px;
            color: #806044;
            text-align: center;
        }

        .total {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px dashed #d9dfe3;
            color: #263238;
            font-size: 16px;
            font-weight: 800;
        }

        .points {
            margin-top: 7px;
            color: #8a671f;
            font-size: 13px;
            font-weight: 700;
        }

        .btn-view {
            display: block;
            width: 100%;
            margin-top: 17px;
            padding: 10px;
            border: 1px solid #dfe4e8;
            border-radius: 8px;
            background: #f8f9fa;
            color: #2c3e50;
            text-align: center;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            transition: .2s;
        }

        .btn-view:hover {
            background: #2c3e50;
            color: white;
            border-color: #2c3e50;
        }

        .empty-state {
            grid-column: 1 / -1;
            padding: 55px 20px;
            background: white;
            border-radius: 12px;
            text-align: center;
            color: #77828c;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .04);
        }

        .empty-state i {
            display: block;
            margin-bottom: 13px;
            color: #aab2b9;
            font-size: 42px;
        }

        .empty-state strong {
            display: block;
            margin-bottom: 7px;
            color: #45515c;
            font-size: 17px;
        }

        @media (max-width: 900px) {
            .sidebar {
                width: 210px;
            }

            .main-content {
                width: calc(100% - 210px);
                margin-left: 210px;
                padding: 20px;
            }

            .page-header {
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
            QUẢN LÝ CAFE
        </div>

        <ul class="menu">

            <li onclick="location.href=
                '${pageContext.request.contextPath}/views/homepage.jsp'">

                <i class="fa-solid fa-house"></i>
                <span>Trang chủ</span>
            </li>

            <li onclick="location.href=
                '${pageContext.request.contextPath}/nhanvien'">

                <i class="fa-solid fa-user"></i>
                <span>Nhân viên</span>
            </li>

            <li class="active"
                onclick="location.href=
                '${pageContext.request.contextPath}/hoadon?action=list'">

                <i class="fa-solid fa-file-invoice-dollar"></i>
                <span>Hóa đơn</span>
            </li>

            <li onclick="location.href=
                '${pageContext.request.contextPath}/menu'">

                <i class="fa-solid fa-mug-saucer"></i>
                <span>Menu</span>
            </li>

            <li onclick="location.href=
                '${pageContext.request.contextPath}/ban'">

                <i class="fa-solid fa-chair"></i>
                <span>Bàn</span>
            </li>

            <li onclick="location.href=
                '${pageContext.request.contextPath}/KhoServlet'">

                <i class="fa-solid fa-box"></i>
                <span>Kho</span>
            </li>

            <li onclick="location.href=
                '${pageContext.request.contextPath}/khachhang'">

                <i class="fa-solid fa-users"></i>
                <span>Khách hàng</span>
            </li>

            <li onclick="location.href=
                '${pageContext.request.contextPath}/ThongKeServlet'">

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

    <main class="main-content">

        <div class="page-header">

            <div>
                <h1>Quản lý hóa đơn</h1>

                <p>
                    Theo dõi hóa đơn đang phục vụ và
                    hóa đơn đã thanh toán
                </p>
            </div>

            <a class="btn-add"
               href="${pageContext.request.contextPath}/hoadon?action=new">

                <i class="fa-solid fa-plus"></i>
                Lập hóa đơn mới
            </a>

        </div>

        <c:if test="${not empty errorMessage}">
            <div class="message error">
                <i class="fa-solid fa-circle-exclamation"></i>
                ${errorMessage}
            </div>
        </c:if>

        <c:if test="${param.success == 'paid'}">
            <div class="message success">
                <i class="fa-solid fa-circle-check"></i>
                Thanh toán hóa đơn thành công.
            </div>
        </c:if>

        <div class="toolbar">

            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>

                <input type="text"
                       id="invoiceSearch"
                       placeholder="Tìm theo mã hóa đơn, bàn hoặc nhân viên...">
            </div>

            <button type="button"
                    class="filter-btn active"
                    data-status="all">
                Tất cả
            </button>

            <button type="button"
                    class="filter-btn"
                    data-status="Đang phục vụ">
                Đang phục vụ
            </button>

            <button type="button"
                    class="filter-btn"
                    data-status="Đã thanh toán">
                Đã thanh toán
            </button>

        </div>

        <div class="invoice-grid"
             id="invoiceGrid">

            <c:choose>

                <c:when test="${not empty listHoaDon}">

                    <c:forEach var="hd"
                               items="${listHoaDon}">

                        <fmt:formatNumber
                            var="maHDFormatted"
                            value="${hd.maHD}"
                            pattern="000000"/>

                        <div class="invoice-card
                                    ${hd.trangThai eq 'Đã thanh toán'
                                        ? 'paid'
                                        : ''}"

                             data-status="${hd.trangThai}"

                             data-search="HD${maHDFormatted}
                                          ${hd.maBan}
                                          ${hd.maNV}
                                          ${hd.maKH}">

                            <div class="invoice-top">

                                <span class="invoice-code">
                                    HD${maHDFormatted}
                                </span>

                                <span class="status
                                             ${hd.trangThai eq
                                               'Đã thanh toán'
                                                ? 'paid'
                                                : ''}">

                                    ${empty hd.trangThai
                                        ? 'Đang phục vụ'
                                        : hd.trangThai}
                                </span>

                            </div>

                            <div class="invoice-info">

                                <p>
                                    <i class="fa-solid fa-chair"></i>

                                    Bàn:
                                    <strong>
                                        ${empty hd.maBan
                                            ? '—'
                                            : hd.maBan}
                                    </strong>
                                </p>

                                <p>
                                    <i class="fa-solid fa-user-tie"></i>

                                    Nhân viên:
                                    <strong>
                                        ${empty hd.maNV
                                            ? '—'
                                            : hd.maNV}
                                    </strong>
                                </p>

                                <p>
                                    <i class="fa-solid fa-user-group"></i>

                                    Khách:
                                    <strong>
                                        ${empty hd.maKH
                                            ? 'Khách lẻ'
                                            : hd.maKH}
                                    </strong>
                                </p>

                                <p>
                                    <i class="fa-regular fa-calendar"></i>

                                    ${empty hd.ngayTao
                                        ? 'Chưa có ngày tạo'
                                        : hd.ngayTao}
                                </p>

                                <div class="total">
                                    Tổng tiền:

                                    <fmt:formatNumber
                                        value="${empty hd.tongTien
                                            ? 0
                                            : hd.tongTien}"
                                        pattern="#,##0"/>
                                    đ
                                </div>

                                <c:if test="${hd.diemCong > 0}">
                                    <div class="points">
                                        <i class="fa-solid fa-star"></i>
                                        Đã cộng ${hd.diemCong} điểm
                                    </div>
                                </c:if>

                            </div>

                            <a class="btn-view"
                               href="${pageContext.request.contextPath}/hoadon?action=edit&maHD=${hd.maHD}">

                                <i class="fa-solid fa-eye"></i>
                                Xem hóa đơn
                            </a>

                        </div>

                    </c:forEach>

                </c:when>

                <c:otherwise>
                    <div class="empty-state">

                        <i class="fa-regular fa-file-lines"></i>

                        <strong>
                            Chưa có hóa đơn nào
                        </strong>

                        <span>
                            Nhận bàn hoặc lập hóa đơn mới để bắt đầu.
                        </span>
                    </div>
                </c:otherwise>

            </c:choose>

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

                const filterButtons =
                        document.querySelectorAll(
                            ".filter-btn"
                        );

                const cards =
                        document.querySelectorAll(
                            ".invoice-card"
                        );

                let selectedStatus = "all";

                function applyFilters() {
                    const keyword =
                            searchInput.value
                                .trim()
                                .toLowerCase();

                    cards.forEach(function (card) {
                        const cardStatus =
                                card.dataset.status || "";

                        const searchData =
                                card.dataset.search
                                    .toLowerCase();

                        const statusMatched =
                                selectedStatus === "all"
                                || cardStatus
                                    === selectedStatus;

                        const keywordMatched =
                                keyword === ""
                                || searchData
                                    .includes(keyword);

                        card.style.display =
                                statusMatched
                                && keywordMatched
                                ? "flex"
                                : "none";
                    });
                }

                searchInput.addEventListener(
                    "input",
                    applyFilters
                );

                filterButtons.forEach(
                    function (button) {

                        button.addEventListener(
                            "click",
                            function () {

                                filterButtons
                                    .forEach(
                                        function (item) {
                                            item.classList
                                                .remove(
                                                    "active"
                                                );
                                        }
                                    );

                                button.classList.add(
                                    "active"
                                );

                                selectedStatus =
                                        button.dataset.status;

                                applyFilters();
                            }
                        );
                    }
                );
            }
        );
    </script>

</body>
</html>