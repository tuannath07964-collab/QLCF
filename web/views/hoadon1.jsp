<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<c:set var="customerModeValue"
       value="${requestScope.customerModeDaChon ne null
                ? requestScope.customerModeDaChon
                : (not empty hoaDon.maKH ? 'saved' : 'guest')}"/>

<c:set var="selectedCustomerCode"
       value="${requestScope.maKHDaChon ne null
                ? requestScope.maKHDaChon
                : hoaDon.maKH}"/>

<c:set var="guestCustomerName"
       value="${requestScope.tenKhachHangDaNhap ne null
                ? requestScope.tenKhachHangDaNhap
                : (empty hoaDon.maKH
                   and hoaDon.tenKhachHang != 'Khách lẻ'
                   ? hoaDon.tenKhachHang
                   : '')}"/>

<c:set var="guestCustomerPhone"
       value="${requestScope.sdtKhachHangDaNhap ne null
                ? requestScope.sdtKhachHangDaNhap
                : (empty hoaDon.maKH
                   ? hoaDon.sdtKhachHang
                   : '')}"/>

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
              href="${pageContext.request.contextPath}/css/app.css?v=80">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=80">

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
                           value="Chọn sản phẩm và thực hiện thanh toán"/>

            </jsp:include>

            <div class="app-content">

                <c:if test="${param.success == 'save'}">

                    <div class="alert alert-success">

                        <i class="fa-solid fa-circle-check"></i>

                        Lưu hóa đơn thành công.

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

                        <a class="section-link"
                           href="${pageContext.request.contextPath}/hoadon">

                            <i class="fa-solid fa-arrow-left"></i>

                            Quay lại danh sách

                        </a>

                        <h2 class="invoice-detail-title">

                            ${hoaDon.maHienThi}

                        </h2>

                        <p>

                            Tạo bởi:

                            <c:out value="${hoaDon.tenTaiKhoan}"/>

                            ·

                            ${hoaDon.ngayTao}

                        </p>

                    </div>

                    <span class="badge invoice-detail-status
                          ${hoaDon.trangThai == 'Đã thanh toán'
                            ? 'badge-success'
                            : hoaDon.trangThai == 'Đã hủy'
                            ? 'badge-danger'
                            : 'badge-warning'}">

                        ${hoaDon.trangThai}

                    </span>

                </div>

                <form id="invoiceForm"
                      action="${pageContext.request.contextPath}/hoadon"
                      method="post">

                    <input type="hidden"
                           name="maHD"
                           value="${hoaDon.maHD}">

                    <input type="hidden"
                           id="usedVoucherValue"
                           value="${empty voucherDaDung
                                    ? 0
                                    : voucherDaDung.menhGia}">

                    <section class="invoice-editor-layout">

                        <article class="card product-picker-panel">

                            <div class="card-header">

                                <div>

                                    <h3>Chọn sản phẩm</h3>

                                    <p>
                                        Nhấn vào sản phẩm để thêm vào hóa đơn
                                    </p>

                                </div>

                                <div class="search-box product-picker-search">

                                    <i class="fa-solid fa-magnifying-glass"></i>

                                    <input type="text"
                                           id="productPickerSearch"
                                           placeholder="Tìm sản phẩm..."
                                           autocomplete="off"
                                           ${hoaDon.daKetThuc
                                             ? 'disabled'
                                             : ''}>

                                </div>

                            </div>

                            <div class="card-body">

                                <div class="product-picker-grid">

                                    <c:forEach var="sanPham"
                                               items="${sanPhamList}">

                                        <button class="product-pick
                                                ${sanPham.coTheBan
                                                  ? ''
                                                  : 'disabled'}"
                                                type="button"
                                                data-code="${sanPham.maSanPham}"
                                                data-name="${sanPham.tenSanPham}"
                                                data-price="${sanPham.giaBan}"
                                                data-search="${sanPham.maSanPham}
                                                             ${sanPham.tenSanPham}
                                                             ${sanPham.tenDanhMuc}"
                                                ${not sanPham.coTheBan
                                                  or hoaDon.daKetThuc
                                                  ? 'disabled'
                                                  : ''}>

                                            <span class="product-pick-icon">

                                                <i class="fa-solid fa-mug-saucer"></i>

                                            </span>

                                            <span class="product-pick-content">

                                                <small>
                                                    <c:out value="${sanPham.tenDanhMuc}"/>
                                                </small>

                                                <strong>
                                                    <c:out value="${sanPham.tenSanPham}"/>
                                                </strong>

                                                <span>

                                                    <fmt:formatNumber
                                                        value="${sanPham.giaBan}"
                                                        pattern="#,##0"/>

                                                    đ

                                                </span>

                                                <em>

                                                    ${sanPham.coTheBan
                                                      ? sanPham.soLuongCoTheBan
                                                      : 0}

                                                    phần

                                                </em>

                                            </span>

                                        </button>

                                    </c:forEach>

                                </div>

                            </div>

                        </article>

                        <article class="card invoice-cart-panel">

                            <div class="card-header">

                                <div>

                                    <h3>Thông tin hóa đơn</h3>

                                    <p>${hoaDon.maHienThi}</p>

                                </div>

                            </div>

                            <div class="card-body">

                                <c:if test="${not hoaDon.daKetThuc}">

                                    <div class="form-group">

                                        <label class="form-label">
                                            Loại khách hàng
                                        </label>

                                        <div class="customer-mode-options">

                                            <label class="customer-mode-item">

                                                <input type="radio"
                                                       name="customerMode"
                                                       value="saved"
                                                       ${customerModeValue == 'saved'
                                                         ? 'checked'
                                                         : ''}>

                                                <span>

                                                    <i class="fa-solid fa-user-check"></i>

                                                    <span>

                                                        <strong>
                                                            Khách hàng đã lưu
                                                        </strong>

                                                        <small>
                                                            Chọn khách có sẵn và sử dụng voucher
                                                        </small>

                                                    </span>

                                                </span>

                                            </label>

                                            <label class="customer-mode-item">

                                                <input type="radio"
                                                       name="customerMode"
                                                       value="guest"
                                                       ${customerModeValue == 'guest'
                                                         ? 'checked'
                                                         : ''}>

                                                <span>

                                                    <i class="fa-solid fa-user-plus"></i>

                                                    <span>

                                                        <strong>
                                                            Khách lẻ / khách mới
                                                        </strong>

                                                        <small>
                                                            Nhập tên và số điện thoại
                                                        </small>

                                                    </span>

                                                </span>

                                            </label>

                                        </div>

                                    </div>

                                    <div id="savedCustomerSection"
                                         class="${customerModeValue == 'saved'
                                                  ? ''
                                                  : 'hidden'}">

                                        <div class="form-group">

                                            <label class="form-label">
                                                Chọn khách hàng đã lưu
                                            </label>

                                            <select class="form-control"
                                                    id="customerSelect"
                                                    name="maKH">

                                                <option value="">
                                                    -- Chọn khách hàng --
                                                </option>

                                                <c:forEach var="khachHang"
                                                           items="${khachHangList}">

                                                    <option value="${khachHang.maKH}"
                                                            data-phone="${khachHang.sdt}"
                                                            ${customerModeValue == 'saved'
                                                              and selectedCustomerCode == khachHang.maKH
                                                              ? 'selected'
                                                              : ''}>

                                                        ${khachHang.maKH}
                                                        -
                                                        ${khachHang.hoTen}
                                                        -
                                                        ${empty khachHang.sdt
                                                          ? 'Chưa có SĐT'
                                                          : khachHang.sdt}

                                                        (${khachHang.diemTichLuy} điểm)

                                                    </option>

                                                </c:forEach>

                                            </select>

                                        </div>

                                    </div>

                                    <div id="guestCustomerSection"
                                         class="${customerModeValue == 'guest'
                                                  ? ''
                                                  : 'hidden'}">

                                        <div class="form-group">

                                            <label class="form-label">
                                                Tên khách lẻ hoặc khách hàng mới
                                            </label>

                                            <input class="form-control"
                                                   type="text"
                                                   id="newCustomerName"
                                                   name="tenKhachHang"
                                                   value="${guestCustomerName}"
                                                   maxlength="100"
                                                   placeholder="Có thể để trống nếu là khách lẻ">

                                        </div>

                                        <div class="form-group">

                                            <label class="form-label">
                                                Số điện thoại
                                            </label>

                                            <input class="form-control"
                                                   type="tel"
                                                   id="newCustomerPhone"
                                                   name="sdtKhachHang"
                                                   value="${guestCustomerPhone}"
                                                   maxlength="11"
                                                   inputmode="numeric"
                                                   pattern="0[0-9]{8,10}"
                                                   placeholder="Ví dụ: 0988123456">

                                        </div>

                                        <label class="checkbox-item invoice-customer-save">

                                            <input type="checkbox"
                                                   id="saveCustomerCheckbox"
                                                   name="luuKhachMoi"
                                                   ${luuKhachMoiDaChon
                                                     ? 'checked'
                                                     : ''}>

                                            Lưu thành khách hàng mới để tích điểm

                                        </label>

                                    </div>

                                    <div id="voucherSection"
                                         class="form-group invoice-voucher-box
                                                ${customerModeValue == 'saved'
                                                  ? ''
                                                  : 'hidden'}">

                                        <label class="form-label">
                                            Voucher của khách hàng
                                        </label>

                                        <select class="form-control"
                                                id="voucherSelect"
                                                name="maVoucher">

                                            <option value=""
                                                    data-value="0"
                                                    data-code="">

                                                Không sử dụng voucher

                                            </option>

                                            <c:forEach var="voucher"
                                                       items="${voucherList}">

                                                <option value="${voucher.maVoucher}"
                                                        data-customer="${voucher.maKH}"
                                                        data-value="${voucher.menhGia}"
                                                        data-code="${voucher.maCode}"
                                                        ${maVoucherDaChon == voucher.maVoucher
                                                          ? 'selected'
                                                          : ''}>

                                                    ${voucher.maCode}
                                                    -
                                                    Giảm

                                                    <fmt:formatNumber
                                                        value="${voucher.menhGia}"
                                                        pattern="#,##0"/>

                                                    đ
                                                    -
                                                    Hạn ${voucher.ngayHetHanHienThi}

                                                </option>

                                            </c:forEach>

                                        </select>

                                        <small id="voucherHelpText"
                                               class="form-help-text">

                                            Chọn khách hàng để xem voucher.

                                        </small>

                                        <div class="selected-voucher-preview hidden"
                                             id="selectedVoucherPreview">

                                            <i class="fa-solid fa-ticket"></i>

                                            <div>

                                                <span>Mã voucher đã chọn</span>

                                                <strong id="selectedVoucherCode">
                                                    —
                                                </strong>

                                            </div>

                                        </div>

                                    </div>

                                </c:if>

                                <c:if test="${hoaDon.daKetThuc}">

                                    <div class="form-group">

                                        <label class="form-label">
                                            Khách hàng
                                        </label>

                                        <input class="form-control"
                                               type="text"
                                               value="${hoaDon.tenKhachHang}"
                                               readonly>

                                    </div>

                                    <c:if test="${not empty hoaDon.sdtKhachHang}">

                                        <div class="form-group">

                                            <label class="form-label">
                                                Số điện thoại
                                            </label>

                                            <input class="form-control"
                                                   type="text"
                                                   value="${hoaDon.sdtKhachHang}"
                                                   readonly>

                                        </div>

                                    </c:if>

                                    <c:if test="${not empty hoaDon.maKH}">

                                        <div class="customer-saved-notice">

                                            <i class="fa-solid fa-user-check"></i>

                                            Khách hàng đã được lưu:
                                            ${hoaDon.maKH}

                                        </div>

                                    </c:if>

                                    <c:if test="${not empty voucherDaDung}">

                                        <div class="used-voucher-box">

                                            <i class="fa-solid fa-ticket"></i>

                                            <div>

                                                <span>Voucher đã sử dụng</span>

                                                <strong>

                                                    ${voucherDaDung.maCode}
                                                    -
                                                    Giảm

                                                    <fmt:formatNumber
                                                        value="${voucherDaDung.menhGia}"
                                                        pattern="#,##0"/>

                                                    đ

                                                </strong>

                                            </div>

                                        </div>

                                    </c:if>

                                </c:if>

                                <div class="invoice-cart-table-wrapper">

                                    <table class="invoice-cart-table">

                                        <thead>

                                            <tr>

                                                <th>Sản phẩm</th>
                                                <th>SL</th>
                                                <th>Thành tiền</th>
                                                <th></th>

                                            </tr>

                                        </thead>

                                        <tbody id="cartTableBody">

                                            <c:forEach var="chiTiet"
                                                       items="${chiTietList}">

                                                <tr class="cart-row"
                                                    data-code="${chiTiet.maSanPham}"
                                                    data-name="${chiTiet.tenSanPham}"
                                                    data-price="${chiTiet.donGia}">

                                                    <td>

                                                        <strong>
                                                            <c:out value="${chiTiet.tenSanPham}"/>
                                                        </strong>

                                                        <small>

                                                            <fmt:formatNumber
                                                                value="${chiTiet.donGia}"
                                                                pattern="#,##0"/>

                                                            đ

                                                        </small>

                                                        <input type="hidden"
                                                               name="maSanPham"
                                                               value="${chiTiet.maSanPham}">

                                                    </td>

                                                    <td>

                                                        <input class="cart-quantity"
                                                               type="number"
                                                               name="soLuong"
                                                               value="${chiTiet.soLuong}"
                                                               min="1"
                                                               step="1"
                                                               ${hoaDon.daKetThuc
                                                                 ? 'readonly'
                                                                 : ''}>

                                                    </td>

                                                    <td class="cart-line-total">
                                                        0đ
                                                    </td>

                                                    <td>

                                                        <button class="cart-remove"
                                                                type="button"
                                                                ${hoaDon.daKetThuc
                                                                  ? 'disabled'
                                                                  : ''}>

                                                            <i class="fa-solid fa-xmark"></i>

                                                        </button>

                                                    </td>

                                                </tr>

                                            </c:forEach>

                                        </tbody>

                                    </table>

                                    <div class="empty-cart
                                         ${empty chiTietList
                                           ? ''
                                           : 'hidden'}"
                                         id="emptyCart">

                                        <i class="fa-solid fa-basket-shopping"></i>

                                        <span>Chưa có sản phẩm</span>

                                    </div>

                                </div>

                                <div class="invoice-total-box">

                                    <div>

                                        <span>Tạm tính</span>

                                        <strong id="subTotalValue">
                                            0đ
                                        </strong>

                                    </div>

                                    <div>

                                        <span>VAT 8%</span>

                                        <strong id="vatValue">
                                            0đ
                                        </strong>

                                    </div>

                                    <div class="voucher-discount-row">

                                        <span>Voucher</span>

                                        <strong id="voucherDiscountValue">
                                            -0đ
                                        </strong>

                                    </div>

                                    <div class="grand-total-row">

                                        <span>Tổng thanh toán</span>

                                        <strong id="grandTotalValue">
                                            0đ
                                        </strong>

                                    </div>

                                </div>

                                <c:if test="${not hoaDon.daKetThuc}">

                                    <div class="payment-default-notice">

                                        <i class="fa-solid fa-money-bill-wave"></i>

                                        <div>

                                            <strong>Thanh toán tại quầy</strong>

                                            <span>
                                                Hệ thống ghi nhận thanh toán bằng tiền mặt.
                                            </span>

                                        </div>

                                    </div>

                                    <div class="invoice-form-actions">

                                        <button class="btn btn-primary"
                                                type="submit"
                                                name="action"
                                                value="save">

                                            <i class="fa-solid fa-floppy-disk"></i>

                                            Lưu hóa đơn

                                        </button>

                                        <button class="btn btn-success"
                                                type="submit"
                                                name="action"
                                                value="pay">

                                            <i class="fa-solid fa-money-check-dollar"></i>

                                            Thanh toán

                                        </button>

                                        <button class="btn btn-danger"
                                                type="button"
                                                id="cancelInvoiceButton">

                                            <i class="fa-solid fa-ban"></i>

                                            Hủy hóa đơn

                                        </button>

                                    </div>

                                </c:if>

                                <c:if test="${hoaDon.daKetThuc}">

                                    <div class="readonly-notice">

                                        <i class="fa-solid fa-lock"></i>

                                        Hóa đơn đã kết thúc.
                                        Không thể thay đổi dữ liệu.

                                    </div>

                                    <c:if test="${hoaDon.trangThai == 'Đã hủy'}">

                                        <div class="invoice-cancel-reason">

                                            <strong>Lý do hủy:</strong>

                                            <c:out value="${hoaDon.lyDoHuy}"/>

                                        </div>

                                    </c:if>

                                </c:if>

                            </div>

                        </article>

                    </section>

                </form>

            </div>

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
                   value="${hoaDon.maHD}">

            <input type="hidden"
                   name="lyDoHuy"
                   id="cancelReasonInput">

        </form>

        <script src="${pageContext.request.contextPath}/js/hoadon.js?v=80"></script>

    </body>

</html>