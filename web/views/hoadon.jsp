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

        <title>Hóa đơn bán hàng</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=50">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=50">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/cafe-theme.css?v=2">
    </head>

    <body>

        <jsp:include page="/views/components/sidebar.jsp">
            <jsp:param name="active"
                       value="invoice"/>
        </jsp:include>

        <main class="app-main">

            <jsp:include page="/views/components/topbar.jsp">
                <jsp:param name="title"
                           value="Hóa đơn bán hàng"/>

                <jsp:param name="subtitle"
                           value="Tạo đơn, thanh toán hoặc hủy hóa đơn"/>
            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'paid'}">

                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Thanh toán hóa đơn thành công.
                    </div>

                </c:if>

                <c:if test="${param.success == 'cancel'}">

                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        Hủy hóa đơn thành công.
                    </div>

                </c:if>

                <c:if test="${not empty errorMessage}">

                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <c:out value="${errorMessage}"/>
                    </div>

                </c:if>

                <div class="page-header">

                    <div>
                        <h2>Danh sách hóa đơn</h2>

                        <p>
                            Mỗi hóa đơn là một đơn bán hàng tại quầy,
                            không còn phụ thuộc vào bàn.
                        </p>
                    </div>

                    <div class="page-actions">

                        <a class="btn btn-primary"
                           href="${pageContext.request.contextPath}/hoadon?action=create">

                            <i class="fa-solid fa-plus"></i>
                            Tạo hóa đơn
                        </a>

                    </div>

                </div>

                <div class="toolbar invoice-toolbar">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               id="invoiceSearch"
                               placeholder="Tìm mã hóa đơn, khách hàng..."
                               autocomplete="off">
                    </div>

                    <div class="invoice-filter-group">

                        <button class="filter-button active"
                                type="button"
                                data-status="all">

                            Tất cả
                        </button>

                        <button class="filter-button"
                                type="button"
                                data-status="Chờ thanh toán">

                            Chờ thanh toán
                        </button>

                        <button class="filter-button"
                                type="button"
                                data-status="Đã thanh toán">

                            Đã thanh toán
                        </button>

                        <button class="filter-button"
                                type="button"
                                data-status="Đã hủy">

                            Đã hủy
                        </button>

                    </div>

                </div>

                <section class="card">

                    <div class="table-wrapper">

                        <table class="data-table">

                            <thead>
                                <tr>
                                    <th>Mã hóa đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th></th>
                                </tr>
                            </thead>

                            <tbody>

                                <c:choose>

                                    <c:when test="${not empty hoaDonList}">

                                        <c:forEach var="hoaDon"
                                                   items="${hoaDonList}">

                                            <tr class="invoice-row"
                                                data-status="${hoaDon.trangThai}"
                                                data-search="${hoaDon.maHienThi}
                                                ${hoaDon.tenKhachHang}
                                                ${hoaDon.tenTaiKhoan}">

                                                <td>
                                                    <strong>
                                                        ${hoaDon.maHienThi}
                                                    </strong>
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.tenKhachHang}"/>
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.tenTaiKhoan}"/>
                                                </td>

                                                <td>
                                                    <c:out value="${hoaDon.ngayTao}"/>
                                                </td>

                                                <td>
                                                    <strong>
                                                        <fmt:formatNumber
                                                            value="${hoaDon.tongTien}"
                                                            pattern="#,##0"/>

                                                        đ
                                                    </strong>
                                                </td>

                                                <td>

                                                    <span class="badge
                                                          ${hoaDon.trangThai
                                                            == 'Đã thanh toán'
                                                            ? 'badge-success'
                                                            : hoaDon.trangThai
                                                            == 'Đã hủy'
                                                            ? 'badge-danger'
                                                            : 'badge-warning'}">

                                                        ${hoaDon.trangThai}
                                                    </span>

                                                </td>

                                                <td>

                                                    <a class="table-action"
                                                       href="${pageContext.request.contextPath}/hoadon?action=edit&id=${hoaDon.maHD}"
                                                       title="Mở hóa đơn">

                                                        <i class="fa-solid fa-eye"></i>
                                                    </a>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>

                                        <tr>
                                            <td colspan="7">

                                                <div class="empty-state">

                                                    <i class="fa-regular fa-file-lines"></i>

                                                    <strong>
                                                        Chưa có hóa đơn
                                                    </strong>
                                                </div>

                                            </td>
                                        </tr>

                                    </c:otherwise>

                                </c:choose>

                            </tbody>

                        </table>

                    </div>

                    <div class="empty-state hidden"
                         id="invoiceEmptySearch">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <strong>
                            Không tìm thấy hóa đơn phù hợp
                        </strong>
                    </div>

                </section>

            </div>

        </main>

        <script>
            const invoiceSearch =
                    document.getElementById("invoiceSearch");

            const invoiceRows =
                    document.querySelectorAll(".invoice-row");

            const filterButtons =
                    document.querySelectorAll(".filter-button");

            const invoiceEmptySearch =
                    document.getElementById("invoiceEmptySearch");

            let currentStatus =
                    "all";

            function normalizeText(value) {
                return (value || "")
                        .toLowerCase()
                        .normalize("NFD")
                        .replace(/[\u0300-\u036f]/g, "");
            }

            function filterInvoiceRows() {
                const keyword =
                        normalizeText(invoiceSearch.value);

                let visibleCount =
                        0;

                invoiceRows.forEach(function (row) {
                    const matchesKeyword =
                            normalizeText(
                                    row.dataset.search
                                    ).includes(keyword);

                    const matchesStatus =
                            currentStatus === "all"
                            || row.dataset.status === currentStatus;

                    const visible =
                            matchesKeyword && matchesStatus;

                    row.style.display =
                            visible ? "" : "none";

                    if (visible) {
                        visibleCount++;
                    }
                });

                if (invoiceEmptySearch) {
                    invoiceEmptySearch.classList.toggle(
                            "hidden",
                            visibleCount > 0
                            );
                }
            }

            invoiceSearch.addEventListener(
                    "input",
                    filterInvoiceRows
                    );

            filterButtons.forEach(function (button) {
                button.addEventListener(
                        "click",
                        function () {
                            filterButtons.forEach(
                                    function (item) {
                                        item.classList.remove("active");
                                    }
                            );

                            button.classList.add("active");

                            currentStatus =
                                    button.dataset.status;

                            filterInvoiceRows();
                        }
                );
            });
        </script>

    </body>
</html>