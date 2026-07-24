<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Bàn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <!-- Phải có file nhanvien.css để hiển thị Sidebar và Header -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/nhanvien.css">
    <!-- File ban.css để hiển thị giao diện Thẻ (Card) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ban.css">
</head>
<body>
    <!-- ===== SIDEBAR (Menu bên trái) ===== -->
    <aside class="sidebar">
        <div class="logo">
            <i class="fa-solid fa-mug-hot"></i> 
            <span class="logo-text">QUẢN LÝ QUÁN CAFE</span>
            <button id="toggleBtn" type="button"><i class="fa-solid fa-bars"></i></button>
        </div>
        <ul class="menu">
            <li onclick="location.href = '${pageContext.request.contextPath}/views/homepage.jsp'"><i class="fa-solid fa-house"></i> <span>Trang chủ</span></li>
            <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'"><i class="fa-solid fa-user"></i> <span>Nhân viên</span></li>
            <li onclick="location.href = '${pageContext.request.contextPath}/hoadon'"><i class="fa-solid fa-file-invoice-dollar"></i> <span>Hóa đơn</span></li>
            <li onclick="location.href = '${pageContext.request.contextPath}/menu'"><i class="fa-solid fa-mug-saucer"></i> <span>Menu</span></li>
            <li class="active" onclick="location.href = '${pageContext.request.contextPath}/ban'"><i class="fa-solid fa-chair"></i> <span>Bàn</span></li>
            <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'"><i class="fa-solid fa-box"></i> <span>Kho</span></li>
            <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'"><i class="fa-solid fa-users"></i> <span>Khách hàng</span></li>
            <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> <span>Thống kê</span></li>
        </ul>
        <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span></a>
    </aside>

    <!-- ===== MAIN CONTENT (Nội dung chính) ===== -->
    <div class="main">
        <div class="header">
            <h2>Quản lý bàn</h2>
            <div class="user-profile">
                <i class="fa-solid fa-user"></i> 
                <span>${sessionScope.maNV} - ${sessionScope.tenNV}</span>
            </div>
        </div>

        <div class="content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
                <!-- Tab Lọc Khu Vực -->
                <div class="zone-tabs" style="margin-bottom: 0;">
                    <a href="${pageContext.request.contextPath}/ban" class="${empty param.khu ? 'active' : ''}">Tất cả</a>
                    <a href="${pageContext.request.contextPath}/ban?khu=Tầng 1" class="${param.khu == 'Tầng 1' ? 'active' : ''}">Tầng 1</a>
                    <a href="${pageContext.request.contextPath}/ban?khu=Tầng 2" class="${param.khu == 'Tầng 2' ? 'active' : ''}">Tầng 2</a>
                    <a href="${pageContext.request.contextPath}/ban?khu=Sân vườn" class="${param.khu == 'Sân vườn' ? 'active' : ''}">Sân vườn</a>
                </div>
                
                <!-- Nút Gọi Modal Thêm Bàn -->
                <button type="button" class="btn-add" onclick="openModal('${pageContext.request.contextPath}/views/ban1.jsp', 'Thêm bàn mới')" style="background: #2e9bee; color: white; border: none; padding: 10px 18px; border-radius: 6px; cursor: pointer;">
                    <i class="fa-solid fa-plus"></i> Thêm bàn
                </button>
            </div>

            <!-- Chú thích (Đã bỏ Đặt trước & Đang dọn dẹp) -->
            <div class="legend">
                <span><i class="dot-legend dot-trong"></i> Trống</span>
                <span><i class="dot-legend dot-phucvu"></i> Đang phục vụ</span>
            </div>

            <!-- Hiển thị Danh Sách Bàn -->
            <div class="ban-grid">
                <c:forEach var="ban" items="${danhSachBan}">
                    <!-- Chỉ còn 2 trạng thái: Đang phục vụ (1) và Trống (các số khác) -->
                    <c:choose>
                        <c:when test="${ban.trangThai == 1}">
                            <c:set var="cssClass" value="phucvu" />
                            <c:set var="statusText" value="Đang phục vụ" />
                            <c:set var="btnClass" value="btn-phucvu" />
                            <c:set var="btnText" value="Xem hóa đơn" />
                            
                            <!-- ========================================================================= -->
                            <!-- CHÚ THÍCH: GẮN LINK ĐỂ CHUYỂN SANG TRANG HÓA ĐƠN KHI BÀN ĐANG PHỤC VỤ -->
                            <!-- Sửa đường dẫn 'value=' bên dưới cho khớp với Servlet Hóa đơn của bạn -->
                            <!-- ========================================================================= -->
                            <c:set var="btnLink" value="${pageContext.request.contextPath}/hoadon/chitiet?maHD=${ban.maDonHang}" />
                        </c:when>
                        
                        <c:otherwise> <!-- Mặc định là trạng thái Trống -->
                            <c:set var="cssClass" value="trong" />
                            <c:set var="statusText" value="Trống" />
                            <c:set var="btnClass" value="btn-trong" />
                            <c:set var="btnText" value="Nhận bàn" />
                            
                            <!-- ========================================================================= -->
                            <!-- CHÚ THÍCH: GẮN LINK GỌI SERVLET ĐỂ XỬ LÝ ACTION 'NHẬN BÀN' -->
                            <!-- ========================================================================= -->
                            <c:set var="btnLink" value="${pageContext.request.contextPath}/ban/nhanban?id=${ban.maBan}" />
                        </c:otherwise>
                    </c:choose>

                    <!-- Thẻ Card Bàn -->
                    <div class="ban-card ${cssClass}">
                        <div class="ban-body">
                            <span class="ban-ten">${ban.tenBan}</span>
                            <span class="ban-meta"><i class="fa-solid fa-user-group"></i> ${ban.soCho} chỗ ngồi · ${ban.khuVuc}</span>
                            <span class="ban-status status-${cssClass}">${statusText}</span>
                            <c:if test="${ban.trangThai == 1}">
                                <span class="ban-info-order">Đơn: ${ban.maDonHang}</span>
                            </c:if>
                        </div>
                        <div class="ban-footer">
                            <a class="btn-action ${btnClass}" href="${btnLink}">${btnText}</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Khung Modal -->
    <div id="myModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
        <div style="background:white; padding:25px; border-radius:12px; width:400px; position:relative;">
            <span class="close-btn" onclick="closeModal()" style="position:absolute; right:20px; top:10px; font-size:24px; cursor:pointer;">&times;</span>
            <h3 id="modalTitle" style="margin-top:0;">Tiêu đề</h3>
            <hr>
            <div id="modalBody"></div>
        </div>
    </div>

    <script>
        function openModal(url, title) {
            document.getElementById('modalTitle').innerText = title;
            fetch(url)
                .then(res => res.text())
                .then(html => {
                    document.getElementById('modalBody').innerHTML = html;
                    document.getElementById('myModal').style.display = 'flex';
                });
        }
        function closeModal() {
            document.getElementById('myModal').style.display = 'none';
        }
    </script>
    <script src="${pageContext.request.contextPath}/js/nhanvien.js"></script>
</body>
</html>