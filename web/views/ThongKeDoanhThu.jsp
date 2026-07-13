<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thống kê doanh thu</title>
        <!-- FontAwesome 6.5.2 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background: #f4f3f0;
                color: #333;
            }

            /* Layout */
            .wrapper {
                display: flex;
                min-height: 100vh;
            }

            /*================ Sidebar (Chuẩn theo ảnh) =================*/
            .sidebar {
                width: 260px;
                background: #4a372c; /* Màu nâu đậm đặc trưng */
                color: #e0dcd8;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                position: fixed;
                height: 100vh;
                left: 0;
                top: 0;
            }

            .logo {
                height: 80px;
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 0 24px;
                font-size: 20px;
                font-weight: bold;
                color: #ffffff;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .logo i {
                font-size: 24px;
            }

            .menu {
                display: flex;
                flex-direction: column;
                flex: 1;
                padding-top: 10px;
            }

            .menu a {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 14px 24px;
                color: #cfc9c3;
                text-decoration: none;
                font-size: 16px;
                transition: all 0.2s ease;
            }

            .menu a:hover {
                background: rgba(255, 255, 255, 0.05);
                color: #ffffff;
            }

            .menu a.active {
                background: rgba(255, 255, 255, 0.1);
                color: #ffffff;
                font-weight: 500;
            }

            .menu i {
                width: 20px;
                font-size: 18px;
                text-align: center;
            }

            .logout-btn {
                border-top: 1px solid rgba(255, 255, 255, 0.05);
                padding: 18px 24px;
            }

            /*================ Main Content Layout =================*/
            .main {
                flex: 1;
                margin-left: 260px; /* Đẩy nội dung tránh sidebar fixed */
                display: flex;
                flex-direction: column;
            }

            /*================ Topbar (Chuẩn theo ảnh) =================*/
            .topbar {
                height: 65px;
                background: #ffffff;
                border-bottom: 1px solid #e8e6e2;
                display: flex;
                justify-content: flex-end;
                align-items: center;
                padding: 0 35px;
                position: fixed;
                top: 0;
                right: 0;
                left: 260px;
                z-index: 100;
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: bold;
                color: #222222;
                font-size: 15px;
                cursor: pointer;
            }

            .user-info i {
                font-size: 22px;
                color: #4a372c;
            }

            /*================ Content Area =================*/
            .content {
                padding: 35px;
                margin-top: 65px; /* Tránh đè lên topbar */
            }

            .title-section {
                margin-bottom: 30px;
            }

            .title {
                font-size: 28px;
                font-weight: 700;
                color: #222222;
            }

            .sub {
                color: #777777;
                margin-top: 4px;
                font-size: 15px;
            }

            /*================ Summary Cards (Chuẩn vòng tròn Pastel) =================*/
            .summary-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-box {
                background: #ffffff;
                border-radius: 12px;
                padding: 24px;
                text-decoration: none;
                color: #333333;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
                display: flex;
                flex-direction: column;
                gap: 15px;
                transition: transform 0.2s, box-shadow 0.2s;
            }

            .stat-box:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
            }

            /* Bọc icon hình tròn màu pastel theo ảnh */
            .icon-wrapper {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
            }

            /* Các mã màu pastel tương ứng từng loại dữ liệu */
            .bg-blue { background-color: #e8f0fe; color: #1a73e8; }
            .bg-green { background-color: #e6f4ea; color: #137333; }
            .bg-orange { background-color: #fce8e6; color: #c5221f; }
            .bg-purple { background-color: #f3e5f5; color: #8e24aa; }

            .stat-info h3 {
                font-size: 16px;
                font-weight: 600;
                color: #222222;
                margin-bottom: 6px;
            }

            .stat-info p {
                font-size: 22px;
                font-weight: 700;
                color: #4a372c;
            }

            /*================ Filter Card & Form =================*/
            .card {
                background: #ffffff;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            }

            .filter-form {
                display: flex;
                gap: 12px;
                margin-bottom: 25px;
                flex-wrap: wrap;
                align-items: center;
            }

            .filter-form input[type="date"],
            .filter-form select {
                padding: 10px 14px;
                border: 1px solid #dddcd8;
                border-radius: 6px;
                font-size: 14px;
                color: #333;
                background-color: #ffffff;
                outline: none;
                transition: border-color 0.2s;
            }

            .filter-form input[type="date"]:focus,
            .filter-form select:focus {
                border-color: #4a372c;
            }

            .btn-submit {
                background: #4a372c;
                color: #ffffff;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: background 0.2s;
            }

            .btn-submit:hover {
                background: #362820;
            }

            /*================ Data Table =================*/
            .table-responsive {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }

            th {
                background: #f8f7f5;
                color: #555555;
                font-weight: 600;
                padding: 14px 16px;
                font-size: 14px;
                border-bottom: 2px solid #eae8e4;
            }

            td {
                padding: 14px 16px;
                border-bottom: 1px solid #eae8e4;
                font-size: 14px;
                color: #444444;
            }

            tr:hover td {
                background: #fcfbfa;
            }

            .txt-bold {
                font-weight: 600;
            }

            .txt-profit {
                color: #137333;
                font-weight: 600;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            
            <!-- Left Sidebar -->
            <div class="sidebar">
                <div class="menu">
                    <div class="logo">
                        <i class="fa-solid fa-mug-hot"></i>
                        <span>Quản lý quán cafe</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/TrangChuServlet"><i class="fa-solid fa-house"></i> Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/NhanVienServlet"><i class="fa-solid fa-user"></i> Nhân viên</a>
                    <a href="${pageContext.request.contextPath}/HoaDonServlet"><i class="fa-solid fa-file-invoice"></i> Hóa đơn</a>
                    <a href="${pageContext.request.contextPath}/MenuServlet"><i class="fa-solid fa-mug-saucer"></i> Menu</a>
                    <a href="${pageContext.request.contextPath}/BanServlet"><i class="fa-solid fa-chair"></i> Bàn</a>
                    <a href="${pageContext.request.contextPath}/KhoServlet"><i class="fa-solid fa-box"></i> Kho</a>
                    <a href="${pageContext.request.contextPath}/KhachHangServlet"><i class="fa-solid fa-users"></i> Khách hàng</a>
                    <a href="${pageContext.request.contextPath}/ThongKeServlet" class="active"><i class="fa-solid fa-chart-line"></i> Thống kê</a>
                    <a href="${pageContext.request.contextPath}/CaiDatServlet"><i class="fa-solid fa-gear"></i> Cài đặt</a>
                </div>
                <div class="logout-btn">
                    <a href="${pageContext.request.contextPath}/DangXuatServlet" style="color: #cfc9c3; text-decoration: none; display: flex; align-items: center; gap: 14px;">
                        <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                    </a>
                </div>
            </div>

            <!-- Right Main Pane -->
            <div class="main">
                
                <!-- Topbar Header (Đã dọn lỗi lặp thẻ và tối ưu hiển thị) -->
                <div class="topbar">
                    <div class="user-info">
                        <i class="fa-solid fa-circle-user"></i>
                        <span>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <c:out value="${not empty sessionScope.user.maNV ? sessionScope.user.maNV : sessionScope.user.username}" /> - <c:out value="${sessionScope.user.hoTen}" />
                                </c:when>
                                <c:otherwise>
                                    Khách ghé thăm
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Main Content Area -->
                <div class="content">
                    <div class="title-section">
                        <div class="title">Thống kê doanh thu</div>
                        <div class="sub">Xem báo cáo doanh thu theo ngày, tháng, năm.</div>
                    </div>

                    <!-- Summary Grid Layout (Pastel Circles) -->
                    <div class="summary-grid">
                        <div class="stat-box">
                            <div class="icon-wrapper bg-blue">
                                <i class="fa-solid fa-calendar-day"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Doanh thu hôm nay</h3>
                                <p><fmt:formatNumber value="${doanhThuNgay}" pattern="#,##0"/>đ</p>
                            </div>
                        </div>

                        <div class="stat-box">
                            <div class="icon-wrapper bg-green">
                                <i class="fa-solid fa-calendar-days"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Doanh thu tháng</h3>
                                <p><fmt:formatNumber value="${doanhThuThang}" pattern="#,##0"/>đ</p>
                            </div>
                        </div>

                        <div class="stat-box">
                            <div class="icon-wrapper bg-orange">
                                <i class="fa-solid fa-chart-bar"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Doanh thu năm</h3>
                                <p><fmt:formatNumber value="${doanhThuNam}" pattern="#,##0"/>đ</p>
                            </div>
                        </div>

                        <div class="stat-box">
                            <div class="icon-wrapper bg-purple">
                                <i class="fa-solid fa-file-receipt"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Số hóa đơn</h3>
                                <p>${tongHoaDon != null ? tongHoaDon : 0}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Form and Table -->
                    <div class="card">
                        <form action="${pageContext.request.contextPath}/ThongKeServlet" method="get" class="filter-form">
                            <input type="date" name="fromDate" value="${param.fromDate}">
                            <input type="date" name="toDate" value="${param.toDate}">
                            <select name="type">
                                <option value="day" ${empty param.type || param.type eq 'day' ? 'selected' : ''}>Theo ngày</option>
                                <option value="month" ${param.type eq 'month' ? 'selected' : ''}>Theo tháng</option>
                                <option value="year" ${param.type eq 'year' ? 'selected' : ''}>Theo năm</option>
                            </select>

                            <button class="btn-submit" type="submit">
                                <i class="fa fa-search"></i> Thống kê
                            </button>
                        </form>

                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>
                                            <c:choose>
                                                <c:when test="${param.type eq 'month'}">Tháng</c:when>
                                                <c:when test="${param.type eq 'year'}">Năm</c:when>
                                                <c:otherwise>Ngày</c:otherwise>
                                            </c:choose>
                                        </th>
                                        <th>Số hóa đơn</th>
                                        <th>Khách hàng</th>
                                        <th>Doanh thu</th>
                                        <th>Lợi nhuận</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty listThongKe}">
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: #888; padding: 30px;">Không có dữ liệu thống kê.</td>
                                        </tr>
                                    </c:if>
                                    <c:forEach items="${listThongKe}" var="tk">
                                        <tr>
                                            <td class="txt-bold">
                                                <c:choose>
                                                    <c:when test="${param.type eq 'month'}">
                                                        <fmt:formatDate value="${tk.ngay}" pattern="MM/yyyy"/>
                                                    </c:when>
                                                    <c:when test="${param.type eq 'year'}">
                                                        <fmt:formatDate value="${tk.ngay}" pattern="yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatDate value="${tk.ngay}" pattern="dd/MM/yyyy"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${tk.soHoaDon}</td>
                                            <td>${tk.soKhach}</td>
                                            <td class="txt-bold"><fmt:formatNumber value="${tk.doanhThu}" pattern="#,##0"/> đ</td>
                                            <td class="txt-profit"><fmt:formatNumber value="${tk.loiNhuan}" pattern="#,##0"/> đ</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </body>
</html>