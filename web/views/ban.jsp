<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Bàn</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Roboto', sans-serif; }
        body { display:flex; min-height:100vh; background:#f4f6f8; }

        /* ===== SIDEBAR (đồng bộ với Hóa đơn / Menu) ===== */
        .sidebar { width:280px; background:#2c3e50; color:#fff; display:flex; flex-direction:column; min-height:100vh; }
        .sidebar-logo { display:flex; align-items:center; gap:12px; padding:22px 24px; background:#1c2833; font-family:'Playfair Display', serif; font-weight:700; font-size:19px; letter-spacing:0.5px; }
        .sidebar-nav { flex:1; padding-top:10px; }
        .sidebar-nav a { display:flex; align-items:center; gap:14px; padding:16px 26px; color:#dfe6ec; text-decoration:none; font-size:15.5px; transition:background .2s; }
        .sidebar-nav a:hover { background:#33495f; }
        .sidebar-nav a.active { background:#2e9bee; color:#fff; font-weight:500; }
        .logout { display:flex; align-items:center; justify-content:center; gap:10px; padding:20px; background:#e0503a; color:#fff; text-decoration:none; font-size:15.5px; font-weight:500; }
        .logout:hover { background:#c74631; }

        /* ===== MAIN ===== */
        .main { flex:1; display:flex; flex-direction:column; }
        .topbar { display:flex; justify-content:space-between; align-items:center; padding:20px 40px; background:#fff; border-bottom:1px solid #e6e9ec; }
        .topbar h1 { font-family:'Playfair Display', serif; font-weight:700; font-size:30px; color:#1c2833; }
        .user-info { display:flex; align-items:center; gap:14px; font-family:'Playfair Display', serif; font-weight:600; color:#1c2833; font-size:16px; }
        .bell { position:relative; font-size:19px; color:#5c6773; cursor:pointer; }
        .bell .dot { position:absolute; top:-3px; right:-3px; width:8px; height:8px; background:#e0503a; border-radius:50%; }

        .content { padding:32px 40px; }

        /* ===== KHU VỰC (tabs) ===== */
        .zone-tabs { display:flex; gap:10px; margin-bottom:18px; flex-wrap:wrap; }
        .zone-tabs a { padding:9px 18px; border-radius:20px; font-size:14px; font-weight:500; text-decoration:none; color:#5c6773; background:#fff; border:1px solid #e2e6ea; }
        .zone-tabs a:hover { border-color:#2e9bee; color:#2e9bee; }
        .zone-tabs a.active { background:#2c3e50; border-color:#2c3e50; color:#fff; }

        /* ===== CHÚ THÍCH TRẠNG THÁI ===== */
        .legend { display:flex; gap:22px; margin-bottom:26px; flex-wrap:wrap; font-size:13.5px; color:#5c6773; }
        .legend span { display:inline-flex; align-items:center; gap:7px; }
        .dot-legend { width:11px; height:11px; border-radius:50%; display:inline-block; }
        .dot-trong { background:#27ae60; }
        .dot-phucvu { background:#e0503a; }
        .dot-dat { background:#e6a23c; }
        .dot-don { background:#8a94a0; }

        /* ===== LƯỚI BÀN ===== */
        .ban-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(215px, 1fr)); gap:20px; }

        .ban-card {
            position:relative; background:#fff; border-radius:10px; overflow:hidden;
            box-shadow:0 1px 4px rgba(0,0,0,0.07); border-top:5px solid #27ae60;
            display:flex; flex-direction:column; transition:transform .15s, box-shadow .15s;
        }
        .ban-card:hover { transform:translateY(-3px); box-shadow:0 6px 16px rgba(0,0,0,0.1); }
        .ban-card.trong { border-top-color:#27ae60; }
        .ban-card.phucvu { border-top-color:#e0503a; }
        .ban-card.dat { border-top-color:#e6a23c; }
        .ban-card.don { border-top-color:#8a94a0; }

        .ban-body { padding:18px 20px 16px; display:flex; flex-direction:column; gap:8px; flex:1; }
        .ban-ten { font-family:'Playfair Display', serif; font-weight:700; font-size:20px; color:#1c2833; }
        .ban-meta { font-size:13px; color:#8a94a0; display:flex; align-items:center; gap:6px; }

        .ban-status {
            display:inline-flex; align-items:center; gap:6px; align-self:flex-start;
            padding:4px 12px; border-radius:12px; font-size:12.5px; font-weight:600; margin-top:2px;
        }
        .status-trong { background:#e3f9ec; color:#1f9d55; }
        .status-phucvu { background:#fdeceb; color:#e0503a; }
        .status-dat { background:#fdf3e2; color:#c1861a; }
        .status-don { background:#eef0f2; color:#6b7480; }

        .ban-info-order { font-size:12.5px; color:#5c6773; margin-top:2px; }

        .ban-footer { padding:12px 20px; border-top:1px solid #eef0f2; }
        .btn-action {
            display:block; width:100%; text-align:center; padding:9px 0; border-radius:6px;
            font-size:13.5px; font-weight:600; text-decoration:none; border:none; cursor:pointer;
        }
        .btn-trong { background:#eaf3fc; color:#2e9bee; }
        .btn-trong:hover { background:#d6ecfd; }
        .btn-phucvu { background:#fdeceb; color:#e0503a; }
        .btn-phucvu:hover { background:#fadbd8; }
        .btn-dat { background:#fdf3e2; color:#c1861a; }
        .btn-dat:hover { background:#fbe8c8; }
        .btn-don { background:#eef0f2; color:#6b7480; }
        .btn-don:hover { background:#e2e6ea; }

        .empty-state { text-align:center; padding:60px 20px; color:#8a94a0; background:#fff; border-radius:10px; font-style:italic; }
    </style>
</head>
<body>

    <!-- ===== SIDEBAR ===== -->
    <div class="sidebar">
        <div class="sidebar-logo">☕ QUẢN LÝ CAFE</div>
        <div class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/trangchu">🏠 Trang chủ</a>
            <a href="${pageContext.request.contextPath}/nhanvien">👤 Nhân viên</a>
            <a href="${pageContext.request.contextPath}/hoadon">🧾 Hóa đơn</a>
            <a href="${pageContext.request.contextPath}/menu">☕ Menu</a>
            <a href="${pageContext.request.contextPath}/ban" class="active">🪑 Bàn</a>
            <a href="${pageContext.request.contextPath}/kho">📦 Kho</a>
            <a href="${pageContext.request.contextPath}/khachhang">👥 Khách hàng</a>
            <a href="${pageContext.request.contextPath}/thongke">📊 Thống kê</a>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout">⏻ Đăng xuất</a>
    </div>

    <!-- ===== MAIN ===== -->
    <div class="main">
        <div class="topbar">
            <h1>Quản lý bàn</h1>
            <div class="user-info">
                👤 ${sessionScope.taiKhoan.maNV} - ${sessionScope.taiKhoan.hoTen}
                <span class="bell">🔔<span class="dot"></span></span>
            </div>
        </div>

        <div class="content">

            <!-- Khu vực -->
            <div class="zone-tabs">
                <a href="?khu=" class="${empty param.khu ? 'active' : ''}">Tất cả</a>
                <a href="?khu=1" class="${param.khu == '1' ? 'active' : ''}">Tầng 1</a>
                <a href="?khu=2" class="${param.khu == '2' ? 'active' : ''}">Tầng 2</a>
                <a href="?khu=sanvuon" class="${param.khu == 'sanvuon' ? 'active' : ''}">Sân vườn</a>
            </div>

            <!-- Chú thích trạng thái -->
            <div class="legend">
                <span><i class="dot-legend dot-trong"></i> Trống</span>
                <span><i class="dot-legend dot-phucvu"></i> Đang phục vụ</span>
                <span><i class="dot-legend dot-dat"></i> Đã đặt trước</span>
                <span><i class="dot-legend dot-don"></i> Đang dọn dẹp</span>
            </div>

            <c:choose>
                <c:when test="${not empty danhSachBan}">
                    <div class="ban-grid">
                        <c:forEach var="ban" items="${danhSachBan}">
                            <%-- trangThai: 0=Trống, 1=Đang phục vụ, 2=Đã đặt trước, 3=Đang dọn --%>
                            <c:set var="cssClass" value="trong" />
                            <c:set var="statusClass" value="status-trong" />
                            <c:set var="statusText" value="Trống" />
                            <c:set var="btnClass" value="btn-trong" />
                            <c:set var="btnText" value="Nhận bàn" />
                            <c:if test="${ban.trangThai == 1}">
                                <c:set var="cssClass" value="phucvu" />
                                <c:set var="statusClass" value="status-phucvu" />
                                <c:set var="statusText" value="Đang phục vụ" />
                                <c:set var="btnClass" value="btn-phucvu" />
                                <c:set var="btnText" value="Xem hóa đơn" />
                            </c:if>
                            <c:if test="${ban.trangThai == 2}">
                                <c:set var="cssClass" value="dat" />
                                <c:set var="statusClass" value="status-dat" />
                                <c:set var="statusText" value="Đã đặt trước" />
                                <c:set var="btnClass" value="btn-dat" />
                                <c:set var="btnText" value="Chi tiết đặt bàn" />
                            </c:if>
                            <c:if test="${ban.trangThai == 3}">
                                <c:set var="cssClass" value="don" />
                                <c:set var="statusClass" value="status-don" />
                                <c:set var="statusText" value="Đang dọn dẹp" />
                                <c:set var="btnClass" value="btn-don" />
                                <c:set var="btnText" value="Hoàn tất dọn" />
                            </c:if>

                            <div class="ban-card ${cssClass}">
                                <div class="ban-body">
                                    <span class="ban-ten">Bàn ${ban.tenBan}</span>
                                    <span class="ban-meta">👥 ${ban.soCho} chỗ ngồi &nbsp;·&nbsp; ${ban.khuVuc}</span>
                                    <span class="ban-status ${statusClass}">${statusText}</span>
                                    <c:if test="${ban.trangThai == 1}">
                                        <span class="ban-info-order">Đơn hiện tại: ${ban.maDonHang}</span>
                                    </c:if>
                                </div>
                                <div class="ban-footer">
                                    <a class="btn-action ${btnClass}" href="${pageContext.request.contextPath}/ban/chitiet?id=${ban.maBan}">${btnText}</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- DỮ LIỆU MẪU: chỉ hiển thị khi chưa có Servlet truyền danhSachBan.
                         Khi có Servlet thật, xóa khối ban-grid mẫu bên dưới. --%>
                    <div class="ban-grid">
                        <div class="ban-card">
                            <div class="ban-body">
                                <span class="ban-ten">Bàn 01</span>
                                <span class="ban-meta">👥 4 chỗ ngồi · Tầng 1</span>
                                <span class="ban-status status-trong">Trống</span>
                            </div>
                            <div class="ban-footer">
                                <a class="btn-action btn-trong" href="${pageContext.request.contextPath}/ban/chitiet?id=1">Nhận bàn</a>
                            </div>
                        </div>

                        <div class="ban-card phucvu">
                            <div class="ban-body">
                                <span class="ban-ten">Bàn 02</span>
                                <span class="ban-meta">👥 2 chỗ ngồi · Tầng 1</span>
                                <span class="ban-status status-phucvu">Đang phục vụ</span>
                                <span class="ban-info-order">Đơn hiện tại: HD014</span>
                            </div>
                            <div class="ban-footer">
                                <a class="btn-action btn-phucvu" href="${pageContext.request.contextPath}/ban/chitiet?id=2">Xem hóa đơn</a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>

</body>
</html>
