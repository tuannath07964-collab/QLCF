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

        <title>Chi tiết hóa đơn</title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/app.css?v=50">

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/css/store.css?v=50">
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

                    <section class="invoice-editor-layout">

                        <article class="card product-picker-panel">

                            <div class="card-header">

                                <div>
                                    <h3>Chọn sản phẩm</h3>
                                    <p>Nhấn vào sản phẩm để thêm vào hóa đơn</p>
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

                                <div class="form-group">

                                    <label class="form-label">
                                        Khách hàng đã lưu
                                    </label>

                                    <select class="form-control"
                                            id="customerSelect"
                                            name="maKH"
                                            ${hoaDon.daKetThuc
                                              ? 'disabled'
                                              : ''}>

                                        <option value="">
                                            Khách lẻ
                                        </option>

                                        <c:forEach var="khachHang"
                                                   items="${khachHangList}">

                                            <option value="${khachHang.maKH}"
                                                    ${hoaDon.maKH
                                                      == khachHang.maKH
                                                      ? 'selected'
                                                      : ''}>

                                                ${khachHang.maKH}
                                                -
                                                ${khachHang.hoTen}
                                            </option>

                                        </c:forEach>

                                    </select>

                                    <c:if test="${hoaDon.daKetThuc
                                                  and not empty hoaDon.maKH}">

                                          <input type="hidden"
                                                 name="maKH"
                                                 value="${hoaDon.maKH}">
                                    </c:if>

                                </div>

                                <c:if test="${not hoaDon.daKetThuc}">

                                    <div class="form-group">

                                        <label class="form-label">
                                            Tên khách hàng mới
                                        </label>

                                        <input class="form-control"
                                               type="text"
                                               id="newCustomerName"
                                               name="tenKhachHang"
                                               value="${empty hoaDon.maKH
                                                        ? hoaDon.tenKhachHang
                                                        : ''}"
                                               maxlength="100"
                                               placeholder="Để trống nếu là khách lẻ">
                                    </div>

                                    <label class="checkbox-item invoice-customer-save">

                                        <input type="checkbox"
                                               id="saveCustomerCheckbox"
                                               name="luuKhachMoi">

                                        Lưu khách hàng mới để tích điểm
                                    </label>

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
                                        <strong id="subTotalValue">0đ</strong>
                                    </div>

                                    <div>
                                        <span>VAT 8%</span>
                                        <strong id="vatValue">0đ</strong>
                                    </div>

                                    <div class="grand-total-row">
                                        <span>Tổng thanh toán</span>
                                        <strong id="grandTotalValue">0đ</strong>
                                    </div>

                                </div>

                                <c:if test="${not hoaDon.daKetThuc}">

                                    <div class="payment-default-notice">

                                        <i class="fa-solid fa-money-bill-wave"></i>

                                        <div>
                                            <strong>Thanh toán tại quầy</strong>

                                            <span>
                                                Hệ thống sẽ ghi nhận hóa đơn đã thanh toán.
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

        <script src="${pageContext.request.contextPath}/js/hoadon.js?v=50"></script>

    </body>
</html>