<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fn"
           uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Quản lý bàn</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/nhanvien.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/ban.css">

        <style>
            .table-message {
                margin-bottom: 14px;
                padding: 11px 14px;
                border-radius: 8px;
                font-weight: 700;
            }

            .table-message.success {
                border: 1px solid #badbcc;
                background: #d1e7dd;
                color: #0f5132;
            }

            .table-message.error {
                border: 1px solid #f5c2c7;
                background: #f8d7da;
                color: #842029;
            }

            .table-toolbar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 15px;
                margin-bottom: 18px;
            }

            .fixed-table-notice {
                padding: 10px 14px;
                border-radius: 7px;
                background: #eaf5ff;
                color: #176b9e;
                font-weight: 600;
            }

            .ban-info-order {
                display: block;
                margin-top: 8px;
                color: #b45309;
                font-size: 13px;
                font-weight: 700;
            }

            @media (max-width: 850px) {
                .table-toolbar {
                    align-items: flex-start;
                    flex-direction: column;
                }
            }
        </style>
    </head>

    <body>

        <!-- ==================== SIDEBAR ==================== -->
        <aside class="sidebar">

            <div class="logo">

                <i class="fa-solid fa-mug-hot"></i>

                <span class="logo-text">
                    QUẢN LÝ QUÁN CAFE
                </span>

                <button id="toggleBtn"
                        type="button">

                    <i class="fa-solid fa-bars"></i>
                </button>

            </div>

            <ul class="menu">

                <li onclick="location.href = '${pageContext.request.contextPath}/views/homepage.jsp'">

                    <i class="fa-solid fa-house"></i>
                    <span>Trang chủ</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/nhanvien'">

                    <i class="fa-solid fa-user"></i>
                    <span>Nhân viên</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/hoadon'">

                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    <span>Hóa đơn</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/menu'">

                    <i class="fa-solid fa-mug-saucer"></i>
                    <span>Menu</span>
                </li>

                <li class="active"
                    onclick="location.href = '${pageContext.request.contextPath}/ban'">

                    <i class="fa-solid fa-chair"></i>
                    <span>Bàn</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/KhoServlet'">

                    <i class="fa-solid fa-box"></i>
                    <span>Kho</span>
                </li>

                <li onclick="location.href = '${pageContext.request.contextPath}/khachhang'">

                    <i class="fa-solid fa-users"></i>
                    <span>Khách hàng</span>
                </li>

                <c:if test="${sessionScope.chucVu == 'Quản lý'}">

                    <li onclick="location.href = '${pageContext.request.contextPath}/ThongKeServlet'">

                        <i class="fa-solid fa-chart-column"></i>
                        <span>Thống kê</span>
                    </li>

                </c:if>

            </ul>

            <a class="logout"
               href="${pageContext.request.contextPath}/LogoutServlet">

                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Đăng xuất</span>
            </a>

        </aside>

        <!-- ==================== MAIN ==================== -->
        <div class="main">

            <div class="header">

                <h2>
                    Quản lý bàn
                </h2>

                <div class="user-profile">

                    <i class="fa-solid fa-user"></i>

                    <span>
                        ${sessionScope.maNV}
                        -
                        ${sessionScope.tenNV}
                    </span>

                </div>

            </div>

            <div class="content">

                <!-- THANH TOÁN XONG MỚI HIỆN ĐÃ TRẢ BÀN -->
                <c:if test="${param.success == 'paid'}">

                    <div class="table-message success">

                        <i class="fa-solid fa-circle-check"></i>

                        Thanh toán thành công.
                        Bàn đã được trả về trạng thái Trống.
                    </div>

                </c:if>

                <c:if test="${param.success == 'cancel'}">

                    <div class="table-message success">

                        <i class="fa-solid fa-circle-check"></i>

                        Đã hủy hóa đơn.
                        Bàn đã được trả về trạng thái Trống.
                    </div>

                </c:if>

                <c:if test="${not empty param.error}">

                    <div class="table-message error">

                        <i class="fa-solid fa-circle-exclamation"></i>
                        ${param.error}
                    </div>

                </c:if>

                <div style="
                     margin-bottom:15px;
                     padding:10px;
                     background:#fff3cd;
                     color:#664d03;
                     border-radius:6px;">

                    Số bàn servlet gửi sang:
                    <b>${fn:length(danhSachBan)}</b>
                </div>

                <div class="table-toolbar">

                    <!-- LỌC KHU VỰC -->
                    <div class="zone-tabs"
                         style="margin-bottom:0;">

                        <a href="${pageContext.request.contextPath}/ban"
                           class="${empty param.khu
                                    ? 'active'
                                    : ''}">

                            Tất cả
                        </a>

                        <a href="${pageContext.request.contextPath}/ban?khu=Tầng%201"
                           class="${param.khu == 'Tầng 1'
                                    ? 'active'
                                    : ''}">

                            Tầng 1
                        </a>

                        <a href="${pageContext.request.contextPath}/ban?khu=Tầng%202"
                           class="${param.khu == 'Tầng 2'
                                    ? 'active'
                                    : ''}">

                            Tầng 2
                        </a>

                        <a href="${pageContext.request.contextPath}/ban?khu=Sân%20vườn"
                           class="${param.khu == 'Sân vườn'
                                    ? 'active'
                                    : ''}">

                            Sân vườn
                        </a>

                    </div>

                </div>

                <!-- CHÚ THÍCH -->
                <div class="legend">

                    <span>
                        <i class="dot-legend dot-trong"></i>
                        Trống
                    </span>

                    <span>
                        <i class="dot-legend dot-phucvu"></i>
                        Đang phục vụ
                    </span>

                </div>

                <!-- DANH SÁCH BÀN -->
                <div class="ban-grid">

                    <c:choose>

                        <c:when test="${not empty danhSachBan}">

                            <c:forEach var="ban"
                                       items="${danhSachBan}">

                                <c:choose>

                                    <c:when test="${ban.trangThai == 1}">

                                        <c:set var="cssClass"
                                               value="phucvu"/>

                                        <c:set var="statusText"
                                               value="Đang phục vụ"/>

                                        <c:set var="btnClass"
                                               value="btn-phucvu"/>

                                        <c:set var="btnText"
                                               value="Thanh toán / Trả bàn"/>

                                        <c:set var="btnLink"
                                               value="${pageContext.request.contextPath}/ban/traban?id=${ban.maBan}"/>

                                    </c:when>

                                    <c:otherwise>

                                        <c:set var="cssClass"
                                               value="trong"/>

                                        <c:set var="statusText"
                                               value="Trống"/>

                                        <c:set var="btnClass"
                                               value="btn-trong"/>

                                        <c:set var="btnText"
                                               value="Nhận bàn"/>

                                        <c:set var="btnLink"
                                               value="${pageContext.request.contextPath}/ban/nhanban?id=${ban.maBan}"/>

                                    </c:otherwise>

                                </c:choose>

                                <div class="ban-card ${cssClass}">

                                    <div class="ban-body">

                                        <span class="ban-ten">
                                            ${ban.tenBan}
                                        </span>

                                        <span class="ban-meta">

                                            <i class="fa-solid fa-user-group"></i>

                                            ${ban.soCho} chỗ ngồi
                                            ·
                                            ${ban.khuVuc}
                                        </span>

                                        <span class="ban-status status-${cssClass}">
                                            ${statusText}
                                        </span>

                                        <c:if test="${ban.trangThai == 1}">

                                            <span class="ban-info-order">

                                                <i class="fa-solid fa-file-invoice"></i>

                                                Đơn:
                                                ${empty ban.maDonHang
                                                  ? 'Đang tạo'
                                                  : ban.maDonHang}
                                            </span>

                                        </c:if>

                                    </div>

                                    <div class="ban-footer">

                                        <a class="btn-action ${btnClass}"
                                           href="${btnLink}">

                                            ${btnText}
                                        </a>

                                    </div>

                                </div>

                            </c:forEach>

                        </c:when>

                        <c:otherwise>

                            <div style="
                                 grid-column:1/-1;
                                 padding:30px;
                                 border-radius:10px;
                                 background:#fff3cd;
                                 color:#664d03;
                                 text-align:center;">

                                Servlet chưa gửi được dữ liệu bàn sang JSP.
                            </div>

                        </c:otherwise>

                    </c:choose>

                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/js/nhanvien.js"></script>

    </body>
</html>