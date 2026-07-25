<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
        <!-- File CSS tách riêng -->
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/kho.css?v=${System.currentTimeMillis()}">
    </head>

    <body>
        <div class="wrapper">

            <!-- ==========================================
                    LEFT SIDEBAR
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

                    <!-- LOGIC TÍNH TOÁN BẰNG JSTL -->
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
                            DASHBOARD CARDS
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
                            TOOLBAR
                    =========================================== -->
                    <div class="toolbar">
                        <div class="search-box">
                            <i class="fa-solid fa-magnifying-glass"></i>
                            <input type="text" placeholder="Tìm kiếm nguyên liệu...">
                        </div>
                        <a href="${pageContext.request.contextPath}/KhoServlet?action=loadForm" class="add-btn" style="text-decoration: none;">
                            <i class="fa-solid fa-plus"></i> Thêm nguyên liệu
                        </a>
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
                                                        <span style="${nl.soLuong == 0 ? 'color: #c5221f; font-weight: 600;' : ''}">
                                                            ${nl.soLuong}
                                                        </span>
                                                    </td>
                                                    <td>${nl.donVi}</td>
                                                    <td>
                                                        <div class="action">
                                                            <a href="${pageContext.request.contextPath}/KhoServlet?action=loadForm&maNL=${nl.maNL}" class="edit-btn" title="Sửa">
                                                                <i class="fa-solid fa-pen"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/KhoServlet?action=delete&maNL=${nl.maNL}" class="delete-btn" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa nguyên liệu này không?');">
                                                                <i class="fa-regular fa-trash-can"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" style="text-align: center; padding: 20px;">Không có nguyên liệu nào trong kho.</td>
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

        <!-- ==========================================
                POP-UP (MODAL) THÊM / SỬA NGUYÊN LIỆU
        =========================================== -->
        <div id="khoModal" class="modal-overlay" style="display: ${not empty showModal ? 'flex' : 'none'};">
            <div class="modal-content">
                <h2 style="margin-bottom: 20px; color: #2c3e50;">
                    ${mode == 'edit' ? 'Cập nhật thông tin nguyên liệu' : 'Thêm nguyên liệu mới'}
                </h2>

                <form action="${pageContext.request.contextPath}/KhoServlet" method="post">
                    <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-weight: 600; margin-bottom: 5px;">Mã nguyên liệu:</label>
                        <input type="text" name="maNL" value="${nl.maNL}" ${mode == 'edit' ? 'readonly style="background:#e9ecef;"' : ''} required 
                               style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-weight: 600; margin-bottom: 5px;">Tên nguyên liệu:</label>
                        <input type="text" name="tenNL" value="${nl.tenNL}" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-weight: 600; margin-bottom: 5px;">Số lượng:</label>
                        <input type="number" name="soLuong" value="${nl.soLuong}" required min="0" 
                               style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
                    </div>

                    <div style="margin-bottom: 25px;">
                        <label style="display: block; font-weight: 600; margin-bottom: 5px;">Đơn vị tính:</label>
                        <input type="text" name="donVi" value="${nl.donVi}" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dcdde1; border-radius: 6px;">
                    </div>

                    <div style="display: flex; gap: 10px;">
                        <button type="submit" style="background: #27ae60; color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                            Lưu thông tin
                        </button>
                        <a href="${pageContext.request.contextPath}/KhoServlet" style="background: #95a5a6; color: white; text-decoration: none; padding: 10px 20px; border-radius: 6px; display: inline-block; font-weight: 600; text-align: center;">
                            Hủy bỏ
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <style>
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }
            .modal-content {
                background: white;
                padding: 30px;
                border-radius: 12px;
                width: 100%;
                max-width: 500px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                animation: fadeIn 0.3s ease;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </body>
</html>