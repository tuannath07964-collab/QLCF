<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Kiểm tra quyền đăng nhập trực tiếp bằng mã Java ngắn gọn (hoặc có thể xử lý ở Filter/Servlet) --%>
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý kho</title>
        <!-- FontAwesome 6.5.2 đồng bộ với trang thống kê -->
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

            /*================ Sidebar (Cố định, chuẩn đồng bộ) =================*/
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
                padding-left: 20px; /* Bù trừ border */
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

            /*================ Main Content Layout =================*/
            .main {
                flex: 1;
                margin-left: 260px; /* Đẩy nội dung tránh sidebar fixed */
                display: flex;
                flex-direction: column;
            }

            /*================ Topbar (Chuẩn đồng bộ) =================*/
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
                gap: 25px;
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

            /*================ Summary Cards (Vòng tròn Pastel giống hệt Thống kê) =================*/
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

            /* Các màu pastel đồng bộ */
            .bg-blue { background-color: #e8f0fe; color: #1a73e8; }
            .bg-green { background-color: #e6f4ea; color: #137333; }
            .bg-orange { background-color: #fef3e6; color: #e67e22; }
            .bg-red { background-color: #fce8e6; color: #c5221f; }

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

            .stat-info span {
                font-size: 13px;
                color: #999;
            }

            /*================ Toolbar (Tìm kiếm & nút thêm) =================*/
            .toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                gap: 15px;
            }

            .search-box {
                background: white;
                width: 350px;
                padding: 10px 16px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 10px;
                border: 1px solid #eae8e4;
                box-shadow: 0 2px 8px rgba(0,0,0,.02);
            }

            .search-box input {
                border: none;
                outline: none;
                width: 100%;
                font-size: 14px;
            }

            .add-btn {
                border: none;
                background: #4a372c;
                color: white;
                padding: 11px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: .2s;
            }

            .add-btn:hover {
                background: #362820;
            }

            /*================ Data Table =================*/
            .card-table {
                background: #ffffff;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
            }

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

            /* Các nút chức năng trong bảng */
            .action {
                display: flex;
                gap: 8px;
            }

            .edit-btn, .delete-btn {
                border: none;
                width: 34px;
                height: 34px;
                border-radius: 6px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 13px;
                transition: opacity 0.2s;
            }

            .edit-btn { background: #3498db; }
            .delete-btn { background: #e74c3c; }

            .edit-btn:hover, .delete-btn:hover {
                opacity: 0.85;
            }

            .empty {
                text-align: center;
                padding: 30px;
                color: #999;
                font-style: italic;
            }

            /*================ Footer Table (Phân trang) =================*/
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
            @media(max-width: 1200px) {
                .summary-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media(max-width: 768px) {
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
                .toolbar {
                    flex-direction: column;
                    align-items: stretch;
                }
                .search-box {
                    width: 100%;
                }
            }
        </style>
    </head>
    
    <body>
        <div class="wrapper">

            <!-- ==========================================
                    LEFT SIDEBAR (Đồng bộ chuẩn 260px fixed)
            =========================================== -->
            <aside class="sidebar">
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
                    
                    <a href="${pageContext.request.contextPath}/KhoServlet" class="active">
                        <i class="fa-solid fa-box"></i> Kho
                    </a>
                    
                    <a href="#">
                        <i class="fa-solid fa-users"></i> Khách hàng
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/ThongKeServlet">
    <i class="fa-solid fa-chart-simple"></i>
    <span>Thống kê doanh thu</span>
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
            </aside>

            <!-- ==========================================
                    MAIN CONTENT AREA
            =========================================== -->
            <main class="main">

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

                    <!-- PAGE HEADER -->
                    <section class="title-section">
                        <div>
                            <h1 class="title">Quản lý kho</h1>
                            <p class="sub">Quản lý nguyên liệu và theo dõi lượng nhập xuất tồn kho</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/views/homepage.jsp" class="back-btn">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại Trang chủ
                        </a>
                    </section>

                    <!-- LOGIC TÍNH TOÁN BẰNG JSTL (Thay thế code Java Scriptlet) -->
                    <c:set var="tongSoLuong" value="0" />
                    <c:set var="sapHetHang" value="0" />
                    <c:set var="hetHang" value="0" />

                    <c:forEach var="nl" items="${dsKho}">
                        <c:set var="tongSoLuong" value="${tongSoLuong + nl.soLuong}" />
                        
                        <c:if test="${nl.soLuong <= 10 && nl.soLuong > 0}">
                            <c:set var="sapHetHang" value="${sapHetHang + 1}" />
                        </c:if>
                        
                        <c:if test="${nl.soLuong == 0}">
                            <c:set var="hetHang" value="${hetHang + 1}" />
                        </c:if>
                    </c:forEach>

                    <!-- ==========================================
                            DASHBOARD CARDS (Style Pastel tròn đồng bộ)
                    =========================================== -->
                    <div class="summary-grid">
                        
                        <!-- Card 1: Tổng loại nguyên liệu -->
                        <div class="stat-box">
                            <div class="icon-wrapper bg-blue">
                                <i class="fa-solid fa-box"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Tổng nguyên liệu</h3>
                                <p>${fn:length(dsKho)}</p>
                                <span>Loại nguyên liệu</span>
                            </div>
                        </div>

                        <!-- Card 2: Tổng số lượng tồn kho -->
                        <div class="stat-box">
                            <div class="icon-wrapper bg-green">
                                <i class="fa-solid fa-basket-shopping"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Tổng số lượng</h3>
                                <p>${tongSoLuong}</p>
                                <span>Đơn vị lẻ</span>
                            </div>
                        </div>

                        <!-- Card 3: Sắp hết hàng -->
                        <div class="stat-box">
                            <div class="icon-wrapper bg-orange">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Sắp hết hàng</h3>
                                <p>${sapHetHang}</p>
                                <span>Số lượng ≤ 10</span>
                            </div>
                        </div>

                        <!-- Card 4: Đã hết hàng -->
                        <div class="stat-box">
                            <div class="icon-wrapper bg-red">
                                <i class="fa-solid fa-circle-xmark"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Hết hàng</h3>
                                <p>${hetHang}</p>
                                <span>Số lượng = 0</span>
                            </div>
                        </div>

                    </div>

                    <!-- ==========================================
                            TOOLBAR (Tìm kiếm & Nút thêm)
                    =========================================== -->
                    <div class="toolbar">
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" placeholder="Tìm kiếm nguyên liệu...">
                        </div>
                        <button class="add-btn">
                            <i class="fa-solid fa-plus"></i> Thêm nguyên liệu
                        </button>
                    </div>

                    <!-- ==========================================
                            BẢNG DỮ LIỆU
                    =========================================== -->
                    <div class="card-table">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Mã nguyên liệu</th>
                                        <th>Tên nguyên liệu</th>
                                        <th>Số lượng</th>
                                        <th>Đơn vị</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty dsKho}">
                                            <c:forEach var="nl" items="${dsKho}">
                                                <tr>
                                                    <td class="txt-bold">${nl.maNL}</td>
                                                    <td>${nl.tenNL}</td>
                                                    <td>
                                                        <span class="${nl.soLuong == 0 ? 'txt-profit' : ''}" style="${nl.soLuong == 0 ? 'color: #c5221f; font-weight: 600;' : ''}">
                                                            ${nl.soLuong}
                                                        </span>
                                                    </td>
                                                    <td>${nl.donVi}</td>
                                                    <td>
                                                        <div class="action">
                                                            <button class="edit-btn" title="Sửa">
                                                                <i class="fa-solid fa-pen"></i>
                                                            </button>
                                                            <button class="delete-btn" title="Xóa">
                                                                <i class="fa-regular fa-trash-can"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="empty">Không có nguyên liệu nào trong kho.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Phân trang dữ liệu -->
                        <div class="table-footer">
                            <div class="table-info">
                                Hiển thị 1 đến ${fn:length(dsKho)} của ${fn:length(dsKho)} nguyên liệu
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
            </main>
        </div>
    </body>
</html>