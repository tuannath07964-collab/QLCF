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
          href="${pageContext.request.contextPath}/css/app.css">
</head>

<body>

    <jsp:include page="/views/components/sidebar.jsp">
        <jsp:param name="active"
                   value="table"/>
    </jsp:include>

    <main class="app-main">

        <jsp:include page="/views/components/topbar.jsp">
            <jsp:param name="title"
                       value="Bàn"/>

            <jsp:param name="subtitle"
                       value="Theo dõi và phục vụ khách tại bàn"/>
        </jsp:include>

        <div class="app-content">

            <c:if test="${param.success == 'paid'}">

                <div class="alert alert-success">

                    <i class="fa-solid fa-circle-check"></i>

                    Thanh toán thành công.
                    Bàn đã trở về trạng thái trống.
                </div>

            </c:if>

            <c:if test="${param.success == 'cancel'}">

                <div class="alert alert-success">

                    <i class="fa-solid fa-circle-check"></i>

                    Đã hủy hóa đơn và trả bàn thành công.
                </div>

            </c:if>

            <c:if test="${not empty param.error}">

                <div class="alert alert-danger">

                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${param.error}
                </div>

            </c:if>

            <div class="page-header">

                <div>
                    <h2>Sơ đồ bàn</h2>

                    <p>
                        Có ${fn:length(danhSachBan)} bàn được tải từ cơ sở dữ liệu.
                    </p>
                </div>

                <div class="page-actions">

                    <a class="btn btn-blue"
                       href="${pageContext.request.contextPath}/hoadon?action=takeaway">

                        <i class="fa-solid fa-bag-shopping"></i>
                        Bán mang về
                    </a>

                </div>

            </div>

            <div class="toolbar">

                <div class="zone-tabs">

                    <a class="zone-tab ${empty param.khu ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/ban">

                        Tất cả
                    </a>

                    <a class="zone-tab ${param.khu == 'Tầng 1' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/ban?khu=Tầng%201">

                        Tầng 1
                    </a>

                    <a class="zone-tab ${param.khu == 'Tầng 2' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/ban?khu=Tầng%202">

                        Tầng 2
                    </a>

                    <a class="zone-tab ${param.khu == 'Sân vườn' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/ban?khu=Sân%20vườn">

                        Sân vườn
                    </a>

                </div>

            </div>

            <c:choose>

                <c:when test="${not empty danhSachBan}">

                    <section class="table-card-grid">

                        <c:forEach var="ban"
                                   items="${danhSachBan}">

                            <c:choose>

                                <c:when test="${ban.trangThai == 0}">

                                    <c:set var="cardClass"
                                           value=""/>

                                    <c:set var="statusClass"
                                           value="badge-success"/>

                                    <c:set var="statusText"
                                           value="Trống"/>

                                    <c:set var="buttonText"
                                           value="Nhận bàn"/>

                                    <c:set var="buttonClass"
                                           value="btn-success"/>

                                    <c:set var="buttonLink"
                                           value="${pageContext.request.contextPath}/ban/nhanban?id=${ban.maBan}"/>

                                </c:when>

                                <c:when test="${ban.trangThai == 1}">

                                    <c:set var="cardClass"
                                           value="serving"/>

                                    <c:set var="statusClass"
                                           value="badge-danger"/>

                                    <c:set var="statusText"
                                           value="Đang phục vụ"/>

                                    <c:set var="buttonText"
                                           value="Mở hóa đơn"/>

                                    <c:set var="buttonClass"
                                           value="btn-danger"/>

                                    <c:set var="buttonLink"
                                           value="${pageContext.request.contextPath}/ban/traban?id=${ban.maBan}"/>

                                </c:when>

                                <c:when test="${ban.trangThai == 2}">

                                    <c:set var="cardClass"
                                           value="reserved"/>

                                    <c:set var="statusClass"
                                           value="badge-warning"/>

                                    <c:set var="statusText"
                                           value="Đã đặt trước"/>

                                    <c:set var="buttonText"
                                           value="Kiểm tra bàn"/>

                                    <c:set var="buttonClass"
                                           value="btn-outline"/>

                                    <c:set var="buttonLink"
                                           value="${pageContext.request.contextPath}/ban"/>

                                </c:when>

                                <c:otherwise>

                                    <c:set var="cardClass"
                                           value="cleaning"/>

                                    <c:set var="statusClass"
                                           value="badge-blue"/>

                                    <c:set var="statusText"
                                           value="Đang dọn dẹp"/>

                                    <c:set var="buttonText"
                                           value="Kiểm tra bàn"/>

                                    <c:set var="buttonClass"
                                           value="btn-outline"/>

                                    <c:set var="buttonLink"
                                           value="${pageContext.request.contextPath}/ban"/>

                                </c:otherwise>

                            </c:choose>

                            <article class="table-card ${cardClass}">

                                <div class="table-card-body">

                                    <div class="table-card-icon">
                                        <i class="fa-solid fa-chair"></i>
                                    </div>

                                    <span class="table-card-name">
                                        ${ban.tenBan}
                                    </span>

                                    <span class="table-card-meta">

                                        ${ban.khuVuc}
                                        ·
                                        ${ban.soCho} chỗ ngồi
                                    </span>

                                    <div class="table-card-status">

                                        <span class="badge ${statusClass}">
                                            ${statusText}
                                        </span>

                                    </div>

                                    <c:if test="${ban.trangThai == 1
                                                  and not empty ban.maDonHang}">

                                        <p class="form-hint">
                                            Đơn hàng: ${ban.maDonHang}
                                        </p>

                                    </c:if>

                                </div>

                                <div class="table-card-footer">

                                    <a class="btn ${buttonClass}"
                                       href="${buttonLink}"
                                       style="width:100%;">

                                        ${buttonText}
                                        <i class="fa-solid fa-arrow-right"></i>
                                    </a>

                                </div>

                            </article>

                        </c:forEach>

                    </section>

                </c:when>

                <c:otherwise>

                    <section class="card">

                        <div class="empty-state">

                            <i class="fa-solid fa-chair"></i>

                            <strong>
                                Không có bàn trong khu vực này
                            </strong>
                        </div>

                    </section>

                </c:otherwise>

            </c:choose>

        </div>

    </main>

</body>
</html>