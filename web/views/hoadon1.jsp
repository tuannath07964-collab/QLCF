<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<c:set var="daThanhToan"
       value="${hoadon.trangThai == 'Đã thanh toán'}"/>

<c:set var="daHuy"
       value="${hoadon.trangThai == 'Đã hủy'}"/>

<c:set var="daKetThuc"
       value="${daThanhToan or daHuy}"/>

<c:set var="laMangVe"
       value="${hoadon.hinhThuc == 'Mang về'}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Chi tiết hóa đơn</title>

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
                       value="Chi tiết hóa đơn"/>

            <jsp:param name="subtitle"
                       value="Chọn món, lưu đơn hoặc thực hiện thanh toán"/>
        </jsp:include>

        <form class="app-content"
              id="invoiceForm"
              action="${pageContext.request.contextPath}/hoadon"
              method="post">

            <input type="hidden"
                   id="formAction"
                   name="action"
                   value="update">

            <input type="hidden"
                   name="maHD"
                   value="${hoadon.maHD}">

            <input type="hidden"
                   name="maNV"
                   value="${empty hoadon.maNV
                            ? sessionScope.maNV
                            : hoadon.maNV}">

            <input type="hidden"
                   name="ngayTao"
                   value="${hoadon.ngayTao}">

            <input type="hidden"
                   name="trangThai"
                   value="${empty hoadon.trangThai
                            ? 'Đang phục vụ'
                            : hoadon.trangThai}">

            <input type="hidden"
                   name="hinhThuc"
                   value="${empty hoadon.hinhThuc
                            ? 'Tại bàn'
                            : hoadon.hinhThuc}">

            <input type="hidden"
                   name="maBan"
                   value="${hoadon.maBan}">

            <input type="hidden"
                   id="inputTongTien"
                   name="tongTien"
                   value="${empty hoadon.tongTien
                            ? 0
                            : hoadon.tongTien}">

            <input type="hidden"
                   id="inputDanhSachMon"
                   name="danhSachMon">

            <div id="cartFields"></div>

            <textarea id="oldCartData"
                      hidden><c:out value="${hoadon.danhSachMon}"/></textarea>

            <c:if test="${param.success == 'save'}">

                <div class="alert alert-success">

                    <i class="fa-solid fa-circle-check"></i>
                    Lưu hóa đơn thành công.
                </div>

            </c:if>

            <c:if test="${not empty errorMessage}">

                <div class="alert alert-danger">

                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMessage}
                </div>

            </c:if>

            <div class="page-header">

                <div>

                    <a class="section-link"
                       href="${pageContext.request.contextPath}/hoadon">

                        <i class="fa-solid fa-arrow-left"></i>
                        Quay lại danh sách
                    </a>

                    <h2 style="margin-top:8px;">
                        ${empty hoadon.maHD
                            ? 'Hóa đơn mới'
                            : hoadon.maHienThi}
                    </h2>

                    <p>
                        ${laMangVe
                            ? 'Đơn bán cho khách mang về'
                            : 'Đơn phục vụ tại bàn'}
                    </p>

                </div>

                <span class="badge
                      ${daThanhToan
                        ? 'badge-success'
                        : daHuy
                            ? 'badge-danger'
                            : 'badge-blue'}">

                    ${empty hoadon.trangThai
                        ? 'Đang phục vụ'
                        : hoadon.trangThai}
                </span>

            </div>

            <section class="invoice-info-grid">

                <div class="invoice-info-box">

                    <span>Hình thức bán</span>

                    <strong>
                        ${laMangVe ? 'Mang về' : 'Tại bàn'}
                    </strong>
                </div>

                <div class="invoice-info-box">

                    <span>Bàn phục vụ</span>

                    <strong id="metaTable">
                        ${laMangVe
                            ? 'Không dùng bàn'
                            : empty hoadon.maBan
                                ? 'Chưa chọn'
                                : hoadon.maBan}
                    </strong>
                </div>

                <div class="invoice-info-box">

                    <span>Nhân viên lập đơn</span>

                    <strong>
                        ${empty hoadon.maNV
                            ? sessionScope.maNV
                            : hoadon.maNV}
                    </strong>
                </div>

            </section>

            <section class="invoice-editor">

                <div class="catalog-card">

                    <div class="catalog-header">

                        <h3>
                            <i class="fa-solid fa-mug-saucer"></i>
                            Chọn món
                        </h3>
                    </div>

                    <div class="category-tabs">

                        <button type="button"
                                class="tab active"
                                data-cat="all">

                            Tất cả
                        </button>

                        <button type="button"
                                class="tab"
                                data-cat="coffee">

                            Cà phê
                        </button>

                        <button type="button"
                                class="tab"
                                data-cat="tea">

                            Trà
                        </button>

                        <button type="button"
                                class="tab"
                                data-cat="juice">

                            Nước ép
                        </button>

                        <button type="button"
                                class="tab"
                                data-cat="snack">

                            Bánh / Ăn vặt
                        </button>

                    </div>

                    <c:choose>

                        <c:when test="${not empty menuList}">

                            <div class="invoice-menu-grid">

                                <c:forEach var="mon"
                                           items="${menuList}">

                                    <button type="button"
                                            class="menu-item
                                                   ${not mon.trangThai
                                                     or daKetThuc
                                                        ? 'disabled'
                                                        : ''}"
                                            data-category="${mon.loaiMon}"
                                            data-disabled="${not mon.trangThai
                                                             or daKetThuc}"
                                            data-ma-mon="${mon.maMon}"
                                            data-ten-mon="${mon.tenMon}"
                                            data-gia="${mon.gia}"
                                            onclick="handleMenuItemClick(this)">

                                        <span class="menu-item-icon">
                                            <i class="fa-solid fa-mug-saucer"></i>
                                        </span>

                                        <span class="menu-item-info">

                                            <strong>
                                                ${mon.tenMon}
                                            </strong>

                                            <span>

                                                <fmt:formatNumber
                                                    value="${mon.gia}"
                                                    pattern="#,##0"/>

                                                đ
                                            </span>

                                        </span>

                                    </button>

                                </c:forEach>

                            </div>

                        </c:when>

                        <c:otherwise>

                            <div class="empty-state">

                                <i class="fa-solid fa-mug-saucer"></i>

                                <strong>
                                    Không có món để bán
                                </strong>
                            </div>

                        </c:otherwise>

                    </c:choose>

                </div>

                <div class="receipt-card">

                    <div class="receipt-header">

                        <h3>
                            <i class="fa-solid fa-receipt"></i>
                            Hóa đơn
                        </h3>
                    </div>

                    <div class="receipt-body">

                        <div class="receipt-customer">

                            <div class="form-group">

                                <label class="form-label"
                                       for="customerSel">

                                    Khách hàng đã lưu
                                </label>

                                <select class="form-control"
                                        id="customerSel"
                                        name="maKH"
                                        ${daKetThuc ? 'disabled' : ''}>

                                    <option value="">
                                        Khách lẻ
                                    </option>

                                    <c:forEach var="kh"
                                               items="${khachHangList}">

                                        <option value="${kh.maKH}"
                                                ${hoadon.maKH == kh.maKH
                                                    ? 'selected'
                                                    : ''}>

                                            ${kh.maKH}
                                            -
                                            ${kh.hoTen}
                                            (${kh.diemTichLuy} điểm)
                                        </option>

                                    </c:forEach>

                                </select>

                                <c:if test="${daKetThuc
                                              and not empty hoadon.maKH}">

                                    <input type="hidden"
                                           name="maKH"
                                           value="${hoadon.maKH}">
                                </c:if>

                            </div>

                            <c:if test="${not daKetThuc}">

                                <label class="checkbox-item">

                                    <input type="checkbox"
                                           id="saveNewCustomer"
                                           name="luuKhachMoi">

                                    Lưu khách hàng mới khi thanh toán
                                </label>

                                <input class="form-control"
                                       type="text"
                                       id="newCustomerName"
                                       name="tenKhachMoi"
                                       maxlength="100"
                                       placeholder="Nhập họ tên khách hàng"
                                       disabled>

                            </c:if>

                        </div>

                        <div class="receipt-items"
                             id="receiptItems">

                            <div class="empty-hint">
                                Chưa có món nào được chọn
                            </div>
                        </div>

                        <div class="receipt-total-list">

                            <div class="receipt-total-row">

                                <span>Tạm tính</span>
                                <strong id="subTotal">0đ</strong>
                            </div>

                            <div class="receipt-total-row">

                                <span>VAT 8%</span>
                                <strong id="vatAmt">0đ</strong>
                            </div>

                            <div class="receipt-total-row">

                                <span>Điểm dự kiến</span>
                                <strong id="pointPreview">0 điểm</strong>
                            </div>

                            <div class="receipt-total-row total">

                                <span>Tổng thanh toán</span>
                                <strong id="grandTotal">0đ</strong>
                            </div>

                        </div>

                        <c:if test="${not daKetThuc}">

                            <div class="payment-options">

                                <label class="payment-option">

                                    <input type="radio"
                                           name="pay"
                                           value="cash"
                                           checked>

                                    <span>
                                        <i class="fa-solid fa-money-bill-wave"></i>
                                        Tiền mặt
                                    </span>
                                </label>

                                <label class="payment-option">

                                    <input type="radio"
                                           name="pay"
                                           value="other">

                                    <span>
                                        <i class="fa-solid fa-credit-card"></i>
                                        Hình thức khác
                                    </span>
                                </label>

                            </div>

                            <div class="invoice-actions">

                                <button type="submit"
                                        class="btn btn-success"
                                        onclick="return prepareInvoiceSubmit('pay')">

                                    <i class="fa-solid fa-money-check-dollar"></i>
                                    Thanh toán
                                </button>

                                <button type="submit"
                                        class="btn btn-primary"
                                        onclick="return prepareInvoiceSubmit('update')">

                                    <i class="fa-solid fa-floppy-disk"></i>
                                    Lưu hóa đơn
                                </button>

                                <button type="button"
                                        class="btn btn-danger"
                                        onclick="cancelInvoice()">

                                    <i class="fa-solid fa-ban"></i>
                                    Hủy đơn
                                </button>

                            </div>

                        </c:if>

                        <c:if test="${daKetThuc}">

                            <div class="readonly-notice">

                                <i class="fa-solid fa-lock"></i>

                                Hóa đơn đã kết thúc và chỉ có thể xem.
                            </div>

                        </c:if>

                    </div>

                </div>

            </section>

        </form>

    </main>

    <form id="cancelInvoiceForm"
          action="${pageContext.request.contextPath}/hoadon"
          method="post"
          class="hidden">

        <input type="hidden"
               name="action"
               value="cancel">

        <input type="hidden"
               name="maHD"
               value="${hoadon.maHD}">

        <input type="hidden"
               name="lyDoHuy"
               id="cancelReasonInput">

    </form>

    <script src="${pageContext.request.contextPath}/js/hoadon.js"></script>

    <script>
        function handleMenuItemClick(element) {
            if (!element
                    || element.dataset.disabled === "true") {

                return;
            }

            addToReceipt(
                    element.dataset.maMon,
                    element.dataset.tenMon,
                    Number(element.dataset.gia)
            );
        }

        function toggleNewCustomerForm() {
            const checkbox =
                    document.getElementById("saveNewCustomer");

            const nameInput =
                    document.getElementById("newCustomerName");

            const customerSelect =
                    document.getElementById("customerSel");

            if (!checkbox || !nameInput) {
                return;
            }

            nameInput.disabled =
                    !checkbox.checked;

            nameInput.required =
                    checkbox.checked;

            if (checkbox.checked) {
                if (customerSelect) {
                    customerSelect.value = "";
                }

                nameInput.focus();
            } else {
                nameInput.value = "";
            }

            if (typeof renderCart === "function") {
                renderCart();
            }
        }

        function cancelInvoice() {
            const reason =
                    prompt("Nhập lý do hủy hóa đơn:");

            if (reason === null) {
                return;
            }

            if (!reason.trim()) {
                alert("Vui lòng nhập lý do hủy hóa đơn.");
                return;
            }

            if (!confirm("Xác nhận hủy hóa đơn này?")) {
                return;
            }

            document.getElementById("cancelReasonInput")
                    .value = reason.trim();

            document.getElementById("cancelInvoiceForm")
                    .submit();
        }

        document.addEventListener(
                "DOMContentLoaded",
                function () {
                    const checkbox =
                            document.getElementById("saveNewCustomer");

                    if (checkbox) {
                        checkbox.addEventListener(
                                "change",
                                toggleNewCustomerForm
                        );
                    }

                    const customerSelect =
                            document.getElementById("customerSel");

                    if (customerSelect) {
                        customerSelect.addEventListener(
                                "change",
                                function () {
                                    if (this.value && checkbox) {
                                        checkbox.checked = false;
                                        toggleNewCustomerForm();
                                    }
                                }
                        );
                    }
                }
        );
    </script>

</body>
</html>