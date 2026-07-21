<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý Menu</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
    </head>
    <body>
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
                <li class="active" onclick="location.href = '${pageContext.request.contextPath}/menu'"><i class="fa-solid fa-mug-saucer"></i> <span>Menu</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ban'"><i class="fa-solid fa-chair"></i> <span>Bàn</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'"><i class="fa-solid fa-box"></i> <span>Kho</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'"><i class="fa-solid fa-users"></i> <span>Khách hàng</span></li>
                <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'"><i class="fa-solid fa-chart-column"></i> <span>Thống kê</span></li>
            </ul>
            <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span></a>
        </aside>

        <div class="main">
            <div class="header">
                <h2>Quản lý Menu</h2>
                <div class="user-profile">
                    <i class="fa-solid fa-user"></i> 
                    <span>${sessionScope.maNV} - ${sessionScope.tenNV}</span>
                </div>
            </div>

            <div class="content">
                <div class="card">
                    <div class="top">
                        <form class="search-form" action="${pageContext.request.contextPath}/menu" method="get">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" placeholder="Nhập tên hoặc mã món..." value="${param.keyword}">
                            <button type="submit"><i class="fa-solid fa-search"></i></button>
                        </form>
                        <button type="button" class="btn-add" onclick="openModal('${pageContext.request.contextPath}/views/Menu2.jsp', 'Thêm món mới')">
                            <i class="fa-solid fa-plus"></i> Thêm món
                        </button>
                    </div>

                    <!-- Category Tabs (Phân loại danh mục) -->
                    <div class="filter-buttons">
                        <a href="${pageContext.request.contextPath}/menu?action=list&loaiMon=all" 
                           class="btn-filter ${empty selectedLoai || selectedLoai == 'all' ? 'active' : ''}">Tất cả</a>

                        <a href="${pageContext.request.contextPath}/menu?action=list&loaiMon=coffee" 
                           class="btn-filter ${selectedLoai == 'coffee' ? 'active' : ''}">Cà phê</a>

                        <a href="${pageContext.request.contextPath}/menu?action=list&loaiMon=tea" 
                           class="btn-filter ${selectedLoai == 'tea' ? 'active' : ''}">Trà</a>

                        <a href="${pageContext.request.contextPath}/menu?action=list&loaiMon=juice" 
                           class="btn-filter ${selectedLoai == 'juice' ? 'active' : ''}">Sinh tố / Nước ép</a>

                        <a href="${pageContext.request.contextPath}/menu?action=list&loaiMon=snack" 
                           class="btn-filter ${selectedLoai == 'snack' ? 'active' : ''}">Bánh / Ăn vặt</a>
                    </div>

                    <!-- Lưới hiển thị danh sách món (Menu Grid) -->
                    <div class="menu-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 22px;">
                        <c:forEach var="m" items="${listMenu}">
                            <div class="mon-card" style="background:#fff; border-radius:10px; overflow:hidden; box-shadow:0 1px 4px rgba(0,0,0,0.07); display:flex; flex-direction:column;">
                                <div class="mon-anh-wrap" style="position:relative; width:100%; height:150px; background:#e8dcc8; display:flex; align-items:center; justify-content:center; font-size:46px;">
                                    <c:choose>
                                        <c:when test="${m.trangThai}">
                                            <span class="mon-badge badge-con" style="position:absolute; top:10px; right:10px; padding:4px 10px; border-radius:12px; font-size:11.5px; font-weight:600; background:#e3f9ec; color:#1f9d55;">Còn hàng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="mon-badge badge-het" style="position:absolute; top:10px; right:10px; padding:4px 10px; border-radius:12px; font-size:11.5px; font-weight:600; background:#fdeceb; color:#e0503a;">Hết hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <i class="fa-solid fa-mug-saucer"></i>
                                </div>
                                <div class="mon-info" style="padding:14px 16px 16px; display:flex; flex-direction:column; gap:6px; flex:1;">
                                    <span class="mon-loai" style="font-size:12px; color:#8a94a0; text-transform:uppercase;">${m.loaiMon}</span>
                                    <span class="mon-ten" style="font-weight:700; font-size:17px; color:#1c2833;">${m.tenMon}</span>
                                    <span class="mon-ma" style="font-size:12px; color:#b0b7bd;">Mã: ${m.maMon}</span>
                                    <span class="mon-gia" style="margin-top:auto; font-size:16px; font-weight:700; color:#c0392b; padding-top:8px;">${m.gia} đ</span>
                                </div>
                                <div class="mon-actions" style="display:flex; border-top:1px solid #eef0f2;">
                                    <!-- Nút Sửa thông tin món -->
                                    <a href="javascript:void(0)" onclick="openModal('${pageContext.request.contextPath}/menu?action=loadForm&maMon=${m.maMon}', 'Sửa thông tin món')" class="btn-sua" style="flex:1; text-align:center; padding:10px 0; font-size:13px; color:#2e9bee; border-right:1px solid #eef0f2; text-decoration:none;">
                                        <i class="fa-solid fa-pen"></i> Sửa
                                    </a>
                                    <!-- Nút Xóa món -->
                                    <a href="${pageContext.request.contextPath}/menu?action=delete&maMon=${m.maMon}" class="btn-xoa" style="flex:1; text-align:center; padding:10px 0; font-size:13px; color:#e0503a; text-decoration:none;" onclick="return confirm('Bạn có chắc chắn muốn xóa món này không?');">
                                        <i class="fa-solid fa-trash-can"></i> Xóa
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Khung Modal dùng chung cho cả Thêm/Sửa Menu -->
        <div id="myModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
            <div style="background:white; padding:25px; border-radius:12px; width:500px; box-shadow:0 4px 15px rgba(0,0,0,0.2); position:relative; max-height: 90vh; overflow-y: auto;">
                <span class="close-btn" onclick="closeModal()" style="position:absolute; right:20px; top:10px; font-size:28px; cursor:pointer; font-weight:bold; color:#333;">&times;</span>
                <h3 id="modalTitle" style="margin-top:0;">Tiêu đề</h3>
                <hr style="margin: 15px 0;">
                <div id="modalBody"></div>
            </div>
        </div>

        <script>
            var contextPath = "${pageContext.request.contextPath}";

            // Hàm dùng chung để load nội dung vào Modal (Thêm/Sửa)
            function openModal(url, title) {
                document.getElementById('modalTitle').innerText = title;
                fetch(url)
                        .then(response => response.text())
                        .then(html => {
                            document.getElementById('modalBody').innerHTML = html;
                            document.getElementById('myModal').style.display = 'flex';
                        })
                        .catch(error => console.error("Lỗi khi load dữ liệu:", error));
            }

            function closeModal() {
                document.getElementById('myModal').style.display = 'none';
                document.getElementById('modalBody').innerHTML = "";
            }

            window.onclick = function (event) {
                var modal = document.getElementById("myModal");
                if (event.target == modal) {
                    closeModal();
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/menu.js"></script>
    </body>
</html>