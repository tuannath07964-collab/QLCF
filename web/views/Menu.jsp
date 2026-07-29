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

        <title>Quản lý menu</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css">
    </head>

    <body>

        <jsp:include page="/views/components/sidebar.jsp">
            <jsp:param name="active"
                       value="menu"/>
        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">
                <jsp:param name="title"
                           value="Menu"/>

                <jsp:param name="subtitle"
                           value="Quản lý món, giá bán và trạng thái phục vụ"/>
            </jsp:include>

            <div class="app-content">

                <div class="page-header">

                    <div>
                        <h2>Danh sách món</h2>

                        <p>
                            Trạng thái món được xác định theo kho nguyên liệu.
                        </p>
                    </div>

                    <div class="page-actions">

                        <button type="button"
                                class="btn btn-primary"
                                onclick="openMenuModal(
                                                '${pageContext.request.contextPath}/menu?action=loadForm',
                                                'Thêm món mới'
                                                )">

                            <i class="fa-solid fa-plus"></i>
                            Thêm món
                        </button>

                    </div>

                </div>

                <form class="toolbar-left menu-search-form"
                      action="${pageContext.request.contextPath}/menu"
                      method="get">

                    <input type="hidden"
                           name="action"
                           value="search">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               name="keyword"
                               value="${param.keyword}"
                               placeholder="Nhập tên hoặc mã món..."
                               autocomplete="off">
                    </div>

                    <button type="submit"
                            class="btn btn-outline">

                        <i class="fa-solid fa-magnifying-glass"></i>
                        Tìm kiếm
                    </button>

                </form>

                <div class="filter-tabs">

                    <a class="filter-tab ${empty selectedLoai
                                           or selectedLoai == 'all'
                                           ? 'active'
                                           : ''}"
                       href="${pageContext.request.contextPath}/menu?action=list&loaiMon=all">

                        Tất cả
                    </a>

                    <a class="filter-tab ${selectedLoai == 'coffee'
                                           ? 'active'
                                           : ''}"
                       href="${pageContext.request.contextPath}/menu?action=list&loaiMon=coffee">

                        Cà phê
                    </a>

                    <a class="filter-tab ${selectedLoai == 'tea'
                                           ? 'active'
                                           : ''}"
                       href="${pageContext.request.contextPath}/menu?action=list&loaiMon=tea">

                        Trà
                    </a>

                    <a class="filter-tab ${selectedLoai == 'juice'
                                           ? 'active'
                                           : ''}"
                       href="${pageContext.request.contextPath}/menu?action=list&loaiMon=juice">

                        Sinh tố / Nước ép
                    </a>

                    <a class="filter-tab ${selectedLoai == 'snack'
                                           ? 'active'
                                           : ''}"
                       href="${pageContext.request.contextPath}/menu?action=list&loaiMon=snack">

                        Bánh / Ăn vặt
                    </a>

                </div>

                <c:choose>

                    <c:when test="${not empty listMenu}">

                        <section class="menu-card-grid">

                            <c:forEach var="m"
                                       items="${listMenu}">

                                <article class="menu-card">

                                    <div class="menu-card-image">

                                        <i class="fa-solid fa-mug-saucer"></i>

                                        <span class="badge ${m.trangThai
                                                             ? 'badge-success'
                                                             : 'badge-danger'}">

                                            ${m.trangThai
                                              ? 'Còn hàng'
                                              : 'Hết hàng'}
                                        </span>

                                    </div>

                                    <div class="menu-card-body">

                                        <span class="menu-card-category">
                                            ${m.loaiMon}
                                        </span>

                                        <span class="menu-card-name">
                                            ${m.tenMon}
                                        </span>

                                        <span class="menu-card-code">
                                            Mã món: ${m.maMon}
                                        </span>

                                        <div class="menu-card-stock">

                                            <c:choose>

                                                <c:when test="${m.trangThai}">

                                                    Có thể pha khoảng
                                                    <strong>
                                                        ${m.soPhanCoThePha}
                                                    </strong>
                                                    phần.
                                                </c:when>

                                                <c:otherwise>
                                                    Không đủ nguyên liệu để pha món.
                                                </c:otherwise>

                                            </c:choose>

                                        </div>

                                        <div class="menu-card-price">

                                            <fmt:formatNumber
                                                value="${m.gia}"
                                                pattern="#,##0"/>

                                            đ
                                        </div>

                                    </div>

                                    <div class="menu-card-footer">

                                        <button type="button"
                                                onclick="openMenuModal(
                                                                '${pageContext.request.contextPath}/menu?action=detail&maMon=${m.maMon}',
                                                                                'Chi tiết món'
                                                                                )">

                                            <i class="fa-solid fa-eye"></i>
                                            Xem
                                        </button>

                                        <button type="button"
                                                onclick="openMenuModal(
                                                                '${pageContext.request.contextPath}/menu?action=loadForm&maMon=${m.maMon}',
                                                                                'Cập nhật món'
                                                                                )">

                                            <i class="fa-solid fa-pen"></i>
                                            Sửa
                                        </button>

                                        <a href="${pageContext.request.contextPath}/menu?action=delete&maMon=${m.maMon}"
                                           onclick="return confirm('Xác nhận xóa món ${m.tenMon}?')">

                                            <i class="fa-solid fa-trash-can"></i>
                                            Xóa
                                        </a>

                                    </div>

                                </article>

                            </c:forEach>

                        </section>

                    </c:when>

                    <c:otherwise>

                        <section class="card">

                            <div class="empty-state">

                                <i class="fa-solid fa-mug-saucer"></i>

                                <strong>
                                    Không tìm thấy món
                                </strong>

                                <span>
                                    Thêm món mới hoặc thay đổi bộ lọc.
                                </span>
                            </div>

                        </section>

                    </c:otherwise>

                </c:choose>

            </div>

        </main>

        <div class="modal-overlay"
             id="menuModal">

            <div class="modal-dialog">

                <div class="modal-header">

                    <h3 id="menuModalTitle">
                        Thông tin món
                    </h3>

                    <button type="button"
                            class="modal-close"
                            onclick="closeMenuModal()">

                        <i class="fa-solid fa-xmark"></i>
                    </button>

                </div>

                <div class="modal-body"
                     id="menuModalBody"></div>

            </div>

        </div>

        <script>
            const menuModal =
                    document.getElementById("menuModal");

            function openMenuModal(url, title) {
                document.getElementById("menuModalTitle")
                        .textContent = title;

                document.getElementById("menuModalBody")
                        .innerHTML =
                        '<div class="loading-state">Đang tải...</div>';

                menuModal.classList.add("show");

                fetch(url)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("Không tải được dữ liệu.");
                            }

                            return response.text();
                        })
                        .then(html => {
                            document.getElementById("menuModalBody")
                                    .innerHTML = html;
                        })
                        .catch(error => {
                            document.getElementById("menuModalBody")
                                    .innerHTML =
                                    '<div class="alert alert-danger">'
                                    + error.message
                                    + '</div>';
                        });
            }

            function closeMenuModal() {
                menuModal.classList.remove("show");
            }

            menuModal.addEventListener(
                    "click",
                    function (event) {
                        if (event.target === menuModal) {
                            closeMenuModal();
                        }
                    }
            );
        </script>

    </body>
</html>