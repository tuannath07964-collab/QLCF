<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<form action="${pageContext.request.contextPath}/khachhang"
      method="post"
      class="p-3">

    <input type="hidden"
           name="action"
           value="${mode == 'edit'
               ? 'edit'
               : 'add'}">

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">
            ${errorMessage}
        </div>
    </c:if>

    <div class="mb-3">
        <label class="form-label fw-bold">
            Mã khách hàng:
        </label>

        <input type="text"
               name="maKH"
               value="${kh.maKH}"
               ${mode == 'edit'
                    ? 'readonly'
                    : ''}
               class="form-control"
               required>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">
            Tên khách hàng:
        </label>

        <input type="text"
               name="hoTen"
               value="${kh.hoTen}"
               class="form-control"
               required>
    </div>

    <div class="mb-3">
        <label class="form-label fw-bold">
            Số điện thoại:
        </label>

        <input type="text"
               name="sdt"
               value="${kh.sdt}"
               class="form-control"
               required>
    </div>

    <c:if test="${mode == 'edit'}">
        <div class="mb-3">
            <label class="form-label fw-bold">
                Điểm tích lũy:
            </label>

            <input type="text"
                   value="${kh.diemTichLuy} điểm"
                   class="form-control"
                   readonly>

            <small class="text-muted">
                Điểm được hệ thống tự cộng khi
                thanh toán, không sửa thủ công.
            </small>
        </div>
    </c:if>

    <div class="d-flex justify-content-end gap-2">
        <button type="button"
                onclick="closeModal()"
                class="btn btn-secondary">
            Hủy
        </button>

        <button type="submit"
                class="btn btn-primary">
            ${mode == 'edit'
                ? 'Cập nhật'
                : 'Thêm mới'}
        </button>
    </div>
</form>