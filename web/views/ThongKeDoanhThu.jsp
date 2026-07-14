<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Kiểm tra đăng nhập --%>
<%
    String maNV = (String) session.getAttribute("maNV");
    String tenNV = (String) session.getAttribute("tenNV");

    if(maNV == null){
        response.sendRedirect(request.getContextPath()+"/LoginServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
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

            /*================ Sidebar (Cố định chuẩn 260px) =================*/
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
                z-index: 101;
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
                overflow-y: auto;
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
                border-left: 4px solid #ffffff;
                padding-left: 20px;
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

            .logout-btn a {
                display: flex;
                align-items: center;
                gap: 14px;
                color: #cfc9c3;
                text-decoration: none;
                font-size: 16px;
                transition: color 0.2s;
            }

            .logout-btn a:hover {
                color: #ffffff;
            }

            /*================ Main Content Layout (Sửa triệt để lỗi nuốt click) =================*/
            .main {
                flex: 1;
                margin-left: 260px; /* Đẩy toàn bộ khối nội dung sang phải để CHỪA CHỖ cho Sidebar */
                margin-top: 65px;   /* Đẩy toàn bộ khối nội dung xuống dưới để CHỪA CHỖ cho Topbar */
                position: relative; /* Tạo ngữ cảnh hiển thị riêng biệt */
                z-index: 1;         /* Nằm dưới Sidebar và Topbar */
                min-height: calc(100vh - 65px);
                display: flex;
                flex-direction: column;
            }

            /*================ Vùng chứa các ô thống kê và bảng =================*/
            .content {
                padding: 35px;
                position: relative;
                z-index: 2; /* Đảm bảo các ô chức năng và bảng nổi lên trên, bấm được bình thường */
            }
            /*================ Topbar (Đã sửa lỗi đè màn hình) =================*/
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
                left: 260px; /* Chừa khoảng trống đúng bằng chiều rộng Sidebar */
                width: calc(100% - 260px); /* Khống chế chiều rộng tuyệt đối không cho tràn ra ngoài */
                z-index: 99; /* Để z-index của topbar nhỏ hơn sidebar */
                pointer-events: auto; /* Chỉ nhận tương tác trong vùng hiển thị thực tế */
            }

            /*================ Sidebar (Đảm bảo luôn nổi lên trên cùng) =================*/
            .sidebar {
                width: 260px;
                background: #4a372c;
                color: #e0dcd8;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                position: fixed;
                height: 100vh;
                left: 0;
                top: 0;
                z-index: 101; /* z-index lớn hơn topbar để sidebar luôn nổi lên trên, dễ click */
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

            .notification {
                position: relative;
                font-size: 20px;
                color: #555;
                cursor: pointer;
            }

            .notification .badge {
                position: absolute;
                top: -5px;
                right: -8px;
                background: #e74c3c;
                color: white;
                font-size: 11px;
                padding: 2px 6px;
                border-radius: 50%;
                font-weight: 600;
            }

            /*================ Content Area =================*/
            .content {
                padding: 35px;
                margin-top: 65px; /* Tránh đè lên topbar */
            }

            .title-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
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

            .back-btn {
                text-decoration: none;
                background: #4a372c;
                color: white;
                padding: 10px 18px;
                border-radius: 8px;
                font-size: 14px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: background 0.2s;
            }

            .back-btn:hover {
                background: #362820;
            }

            /*================ Summary Cards (Pastel Circle) =================*/
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

            .icon-wrapper {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
            }

            /* Pastel Colors */
            .bg-blue {
                background-color: #e8f0fe;
                color: #1a73e8;
            }
            .bg-green {
                background-color: #e6f4ea;
                color: #137333;
            }
            .bg-orange {
                background-color: #fce8e6;
                color: #c5221f;
            }
            .bg-purple {
                background-color: #f3e5f5;
                color: #8e24aa;
            }

            .stat-info h3 {
                font-size: 15px;
                font-weight: 600;
                color: #666666;
                margin-bottom: 6px;
            }

            .stat-info p {
                font-size: 24px;
                font-weight: 700;
                color: #4a372c;
            }

            /*================ Filter Card & Form =================*/
            .card {
                background: #ffffff;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
                margin-bottom: 25px;
            }

            .filter-form {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                align-items: center;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .filter-group label {
                font-size: 13px;
                font-weight: 600;
                color: #666;
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
                height: 40px;
            }

            .filter-form input[type="date"]:focus,
            .filter-form select:focus {
                border-color: #4a372c;
            }

            .btn-submit {
                background: #4a372c;
                color: #ffffff;
                border: none;
                padding: 0 20px;
                height: 40px;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-top: 21px; /* Cân bằng với labels của các filter-group */
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

            .empty {
                text-align: center;
                padding: 30px;
                color: #999;
                font-style: italic;
            }

            /*================ Table Footer =================*/
            .table-footer {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-top: 20px;
                border-top: 1px solid #eae8e4;
                margin-top: 15px;
            }

            .table-info {
                color: #666;
                font-size: 14px;
            }

            .pagination {
                display: flex;
                gap: 6px;
            }

            .page-btn {
                border: 1px solid #dddcd8;
                background: #fff;
                width: 34px;
                height: 34px;
                border-radius: 6px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                color: #555;
                transition: all 0.2s;
            }

            .page-btn:hover {
                border-color: #4a372c;
                color: #4a372c;
            }

            .active-page {
                background: #4a372c;
                color: white;
                border-color: #4a372c;
            }

            .active-page:hover {
                color: white;
            }

            /*================ Responsive =================*/
            @media(max-width: 1200px){
                .summary-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media(max-width: 768px){
                .sidebar {
                    display: none;
                }
                .main {
                    margin-left: 0;
                }
                .topbar {
                    left: 0;
                }
                .summary-grid {
                    grid-template-columns: 1fr;
                }
                .filter-form {
                    flex-direction: column;
                    align-items: stretch;
                }
                .btn-submit {
                    margin-top: 10px;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrapper">

            <!-- ==========================================
                    LEFT SIDEBAR
            =========================================== -->
            <div class="sidebar">
                <div class="menu">
                    <div class="logo">
                        <i class="fa-solid fa-mug-hot"></i>
                        <span>Quản lý quán cafe</span>
                    </div>

                    <a href="${pageContext.request.contextPath}/views/homepage.jsp">
                        <i class="fa-solid fa-house"></i> Trang chủ
                    </a>

                    <a href="#">
                        <i class="fa-solid fa-user"></i> Nhân viên
                    </a>

                    <a href="#">
                        <i class="fa-solid fa-file-invoice-dollar"></i> Hóa đơn
                    </a>

                    <a href="#">
                        <i class="fa-solid fa-mug-hot"></i> Menu
                    </a>

                    <a href="#">
                        <i class="fa-solid fa-chair"></i> Bàn
                    </a>

                    <a href="${pageContext.request.contextPath}/KhoServlet">
                        <i class="fa-solid fa-box"></i> Kho
                    </a>

                    <a href="#">
                        <i class="fa-solid fa-users"></i> Khách hàng
                    </a>

                    <a href="${pageContext.request.contextPath}/ThongKeServlet" class="active">
                        <i class="fa-solid fa-chart-simple"></i> Thống kê doanh thu
                    </a>

                    <a href="#">
                        <i class="fa-solid fa-gear"></i> Cài đặt
                    </a>
                </div>

                <div class="logout-btn">
                    <a href="${pageContext.request.contextPath}/LogoutServlet">
                        <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                    </a>
                </div>
            </div>

            <!-- ==========================================
                    MAIN CONTENT
            =========================================== -->
            <div class="main">

                <!-- TOPBAR -->
                <header class="topbar">
                    <div class="user-info">
                        <i class="fa-solid fa-circle-user"></i>
                        <span><%= maNV %> - <%= tenNV %></span>
                    </div>
                    <div class="notification" style="margin-left: 25px;">
                        <i class="fa-regular fa-bell"></i>
                        <span class="badge">3</span>
                    </div>
                </header>

                <!-- CONTENT -->
                <div class="content">

                    <!-- PAGE TITLE -->
                    <div class="title-section">
                        <div>
                            <h1 class="title">Thống kê doanh thu</h1>
                            <p class="sub">Theo dõi báo cáo, kiểm soát dòng tiền của quán</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp" class="back-btn">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại Trang chủ
                        </a>
                    </div>

                    <!-- ==========================================
                            SUMMARY CARDS (Pastel Circle)
                    =========================================== -->
                    <div class="summary-grid">

                        <!-- Card 1: Tổng hóa đơn -->
                        <div class="stat-box">
                            <div class="icon-wrapper bg-blue">
                                <i class="fa-solid fa-file-invoice-dollar"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Tổng số đơn</h3>
                                <p>${fn:length(dsHoaDon)}</p>
                            </div>
                        </div>

                        <!-- Card 2: Tổng doanh thu (Sử dụng biến từ Servlet tính sẵn hoặc tính bằng loop) -->
                        <c:set var="tongDoanhThu" value="0" />
                        <c:forEach var="hd" items="${dsHoaDon}">
                            <c:set var="tongDoanhThu" value="${tongDoanhThu + hd.tongTien}" />
                        </c:forEach>

                        <div class="stat-box">
                            <div class="icon-wrapper bg-green">
                                <i class="fa-solid fa-money-bill-trend-up"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Tổng doanh thu</h3>
                                <p>
                                    <fmt:formatNumber value="${tongDoanhThu}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </p>
                            </div>
                        </div>

                        <!-- Card 3: Đơn hàng hoàn thành -->
                        <c:set var="hoanThanh" value="0"/>
                        <c:forEach var="hd" items="${dsHoaDon}">
                            <c:if test="${hd.trangThai == 'Đã thanh toán' || hd.trangThai == 'Hoàn thành'}">
                                <c:set var="hoanThanh" value="${hoanThanh + 1}"/>
                            </c:if>
                        </c:forEach>
                        <div class="stat-box">
                            <div class="icon-wrapper bg-purple">
                                <i class="fa-solid fa-circle-check"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Đã hoàn thành</h3>
                                <p>${hoanThanh} đơn</p>
                            </div>
                        </div>

                        <!-- Card 4: Đơn chờ xử lý / Hủy bỏ -->
                        <c:set var="choXuLy" value="0"/>
                        <c:forEach var="hd" items="${dsHoaDon}">
                            <c:if test="${hd.trangThai == 'Chờ thanh toán' || hd.trangThai == 'Chờ xử lý'}">
                                <c:set var="choXuLy" value="${choXuLy + 1}"/>
                            </c:if>
                        </c:forEach>
                        <div class="stat-box">
                            <div class="icon-wrapper bg-orange">
                                <i class="fa-solid fa-clock"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Chờ xử lý</h3>
                                <p>${choXuLy} đơn</p>
                            </div>
                        </div>

                    </div>

                    <!-- ==========================================
                            FILTER FORM CARD
                    =========================================== -->
                    <div class="card">
                        <form action="${pageContext.request.contextPath}/ThongKeServlet" method="GET" class="filter-form">

                            <div class="filter-group">
                                <label for="tuNgay">Từ ngày</label>
                                <input type="date" id="tuNgay" name="tuNgay" value="${param.tuNgay}">
                            </div>

                            <div class="filter-group">
                                <label for="denNgay">Đến ngày</label>
                                <input type="date" id="denNgay" name="denNgay" value="${param.denNgay}">
                            </div>

                            <div class="filter-group">
                                <label for="phuongThuc">Phương thức thanh toán</label>
                                <select id="phuongThuc" name="phuongThuc">
                                    <option value="">Tất cả</option>
                                    <option value="TienMat" ${param.phuongThuc == 'TienMat' ? 'selected' : ''}>Tiền mặt</option>
                                    <option value="ChuyenKhoan" ${param.phuongThuc == 'ChuyenKhoan' ? 'selected' : ''}>Chuyển khoản</option>
                                </select>
                            </div>

                            <button type="submit" class="btn-submit">
                                <i class="fa-solid fa-filter"></i> Lọc dữ liệu
                            </button>
                        </form>
                    </div>

                    <!-- ==========================================
                            DATA TABLE
                    =========================================== -->
                    <div class="card" style="padding-top: 15px;">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Mã hóa đơn</th>
                                        <th>Ngày tạo</th>
                                        <th>Thu ngân (Nhân viên)</th>
                                        <th>Phương thức</th>
                                        <th>Trạng thái</th>
                                        <th style="text-align: right;">Tổng tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <%-- Trường hợp có dữ liệu --%>
                                        <c:when test="${not empty dsHoaDon}">
                                            <c:forEach var="hd" items="${dsHoaDon}">
                                                <tr>
                                                    <td class="txt-bold">${hd.maHD}</td>
                                                    <td>
                                                        <fmt:formatDate value="${hd.ngayTao}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                    <td>${hd.tenNV}</td>
                                                    <td>${hd.phuongThucTT}</td>
                                                    <td>
                                                        <span class="txt-bold" style="color: ${hd.trangThai == 'Đã thanh toán' || hd.trangThai == 'Hoàn thành' ? '#137333' : '#e67e22'}">
                                                            ${hd.trangThai}
                                                        </span>
                                                    </td>
                                                    <td class="txt-profit" style="text-align: right;">
                                                        <fmt:formatNumber value="${hd.tongTien}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>

                                        <%-- Trường hợp danh sách trống --%>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="empty">Không tìm thấy dữ liệu hóa đơn nào phù hợp.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Footer/Pagination -->
                        <div class="table-footer">
                            <div class="table-info">
                                Hiển thị ${fn:length(dsHoaDon)} hóa đơn
                            </div>
                            <div class="pagination">
                                <button class="page-btn">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </button>
                                <button class="page-btn active-page">1</button>
                                <button class="page-btn">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </button>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </body>
</html>