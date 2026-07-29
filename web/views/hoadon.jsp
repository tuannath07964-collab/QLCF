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

    <title>Quản lý hóa đơn</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/app.css">
</head>

<body>

    <jsp:include page="/views/components/sidebar.jsp">
        <jsp:param name="active"
                   value="invoice"/>
    </jsp:include>

    <main class="app-main">

        <jsp:include page="/views/components/topbar.jsp">
            <jsp:param name="title"
                       value="Hóa đơn"/>

            <jsp:param name="subtitle"
                       value="Theo dõi đơn đang phục vụ, đã thanh toán và đã hủy"/>
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
                    Hóa đơn đã được hủy.
                </div>

            </c:if>

            <c:if test="${not empty param.error
                          or not empty errorMessage}">

                <div class="alert alert-danger">

                    <i class="fa-solid fa-circle-exclamation"></i>

                    ${not empty errorMessage
                        ? errorMessage
                        : param.error}
                </div>

            </c:if>

            <div class="page-header">

                <div>
                    <h2>Danh sách hóa đơn</h2>

                    <p>
                        Mở hóa đơn để thêm món, thanh toán hoặc hủy đơn.
                    </p>
                </div>

                <div class="page-actions">

                    <a class="btn btn-blue"
                       href="${pageContext.request.contextPath}/hoadon?action=takeaway">

                        <i class="fa-solid fa-bag-shopping"></i>
                        Bán cho khách mang về
                    </a>

                </div>

            </div>

            <div class="toolbar">

                <div class="toolbar-left">

                    <div class="search-box">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="text"
                               id="invoiceSearch"
                               placeholder="Tìm hóa đơn, bàn, khách hàng..."
                               autocomplete="off">
                    </div>

                </div>

                <div class="toolbar-right">

                    <button type="button"
                            class="filter-button active"
                            data-status="all">

                        Tất cả
                    </button>

                    <button type="button"
                            class="filter-button"
                            data-status="Đang phục vụ">

                        Đang phục vụ
                    </button>

                    <button type="button"
                            class="filter-button"
                            data-status="Đã thanh toán">

                        Đã thanh toán
                    </button>

                    <button type="button"
                            class="filter-button"
                            data-status="Đã hủy">

                        Đã hủy
                    </button>

                </div>

            </div>

            <c:choose>

                <c:when test="${not empty listHoaDon}">

                    <section class="invoice-list-grid">

                        <c:forEach var="hd"
                                   items="${listHoaDon}">

                            <fmt:formatNumber
                                var="maHDFormatted"
                                value="${hd.maHD}"
                                pattern="000000"/>

                            <c:set var="cardClass"
                                   value=""/>

                            <c:set var="statusClass"
                                   value="badge-blue"/>

                            <c:if test="${hd.trangThai == 'Đã thanh toán'}">

                                <c:set var="cardClass"
                                       value="paid"/>

                                <c:set var="statusClass"
                                       value="badge-success"/>
                            </c:if>

                            <c:if test="${hd.trangThai == 'Đã hủy'}">

                                <c:set var="cardClass"
                                       value="cancelled"/>

                                <c:set var="statusClass"
                                       value="badge-danger"/>
                            </c:if>

                            <article class="invoice-card ${cardClass}"
                                     data-status="${hd.trangThai}"
                                     data-search="HD${maHDFormatted}
                                                  ${hd.maHD}
                                                  ${hd.maBan}
                                                  ${hd.maNV}
                                                  ${hd.maKH}
                                                  ${hd.tenKhachHang}
                                                  ${hd.hinhThuc}">

                                <div class="invoice-card-header">

                                    <span class="invoice-code">
                                        HD${maHDFormatted}
                                    </span>

                                    <span class="badge ${statusClass}">

                                        ${empty hd.trangThai
                                            ? 'Đang phục vụ'
                                            : hd.trangThai}
                                    </span>

                                </div>

                                <div class="invoice-card-body">

                                    <div class="invoice-line">

                                        <i class="fa-solid fa-bag-shopping"></i>

                                        Hình thức:

                                        <strong>
                                            ${empty hd.hinhThuc
                                                ? 'Tại bàn'
                                                : hd.hinhThuc}
                                        </strong>
                                    </div>

                                    <div class="invoice-line">

                                        <i class="fa-solid fa-chair"></i>

                                        Bàn:

                                        <strong>
                                            ${empty hd.maBan
                                                ? 'Không dùng bàn'
                                                : hd.maBan}
                                        </strong>
                                    </div>

                                    <div class="invoice-line">

                                        <i class="fa-solid fa-user-tie"></i>

                                        Nhân viên:

                                        <strong>
                                            ${empty hd.maNV ? '—' : hd.maNV}
                                        </strong>
                                    </div>

                                    <div class="invoice-line">

                                        <i class="fa-solid fa-user-group"></i>

                                        Khách:

                                        <strong>
                                            ${empty hd.tenKhachHang
                                                ? 'Khách lẻ'
                                                : hd.tenKhachHang}
                                        </strong>
                                    </div>

                                    <div class="invoice-line">

                                        <i class="fa-regular fa-calendar"></i>

                                        ${empty hd.ngayTao
                                            ? 'Chưa có ngày tạo'
                                            : hd.ngayTao}
                                    </div>

                                    <div class="invoice-total">

                                        <fmt:formatNumber
                                            value="${empty hd.tongTien
                                                ? 0
                                                : hd.tongTien}"
                                            pattern="#,##0"/>

                                        đ
                                    </div>

                                    <c:if test="${hd.trangThai == 'Đã hủy'
                                                  and not empty hd.lyDoHuy}">

                                        <div class="invoice-cancel-reason">

                                            <strong>Lý do hủy:</strong>
                                            ${hd.lyDoHuy}
                                        </div>

                                    </c:if>

                                </div>

                                <div class="invoice-card-footer">

                                    <a class="btn btn-outline"
                                       href="${pageContext.request.contextPath}/hoadon?action=edit&maHD=${hd.maHD}"
                                       style="width:100%;">

                                        <i class="fa-solid fa-eye"></i>
                                        Xem hóa đơn
                                    </a>

                                </div>

                            </article>

                        </c:forEach>

                    </section>

                    <div class="empty-state hidden"
                         id="noInvoiceResult">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <strong>
                            Không tìm thấy hóa đơn phù hợp
                        </strong>
                    </div>

                </c:when>

                <c:otherwise>

                    <section class="card">

                        <div class="empty-state">

                            <i class="fa-regular fa-file-lines"></i>

                            <strong>
                                Chưa có hóa đơn
                            </strong>

                            <span>
                                Nhận bàn hoặc tạo đơn mang về để bắt đầu.
                            </span>
                        </div>

                    </section>

                </c:otherwise>

            </c:choose>

        </div>

    </main>

    <script>
        const invoiceSearch =
                document.getElementById("invoiceSearch");

        const invoiceCards =
                document.querySelectorAll(".invoice-card");

        const filterButtons =
                document.querySelectorAll(".filter-button");

        const noInvoiceResult =
                document.getElementById("noInvoiceResult");

        let selectedInvoiceStatus = "all";

        function normalizeInvoiceText(value) {
            return (value || "")
                    .toLowerCase()
                    .normalize("NFD")
                    .replace(
                            /[\u0300-\u036f]/g,
                            ""
                    );
        }

        function filterInvoices() {
            const keyword =
                    normalizeInvoiceText(
                            invoiceSearch
                                ? invoiceSearch.value
                                : ""
                    );

            let visibleCount = 0;

            invoiceCards.forEach(card => {
                const matchedKeyword =
                        normalizeInvoiceText(
                                card.dataset.search
                        ).includes(keyword);

                const matchedStatus =
                        selectedInvoiceStatus === "all"
                        || card.dataset.status
                            === selectedInvoiceStatus;

                const visible =
                        matchedKeyword
                        && matchedStatus;

                card.style.display =
                        visible ? "" : "none";

                if (visible) {
                    visibleCount++;
                }
            });

            if (noInvoiceResult) {
                noInvoiceResult.classList.toggle(
                        "hidden",
                        visibleCount > 0
                );
            }
        }

        if (invoiceSearch) {
            invoiceSearch.addEventListener(
                    "input",
                    filterInvoices
            );
        }

        filterButtons.forEach(button => {
            button.addEventListener(
                    "click",
                    function () {
                        filterButtons.forEach(item => {
                            item.classList.remove("active");
                        });

                        this.classList.add("active");

                        selectedInvoiceStatus =
                                this.dataset.status;

                        filterInvoices();
                    }
            );
        });
    </script>

</body>
</html>