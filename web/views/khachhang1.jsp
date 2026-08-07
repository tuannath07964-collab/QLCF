<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<c:set var="isEdit"
       value="${mode == 'edit'}"/>

<c:if test="${not empty errorMessage}">

    <div class="alert alert-danger">

        <i class="fa-solid fa-circle-exclamation"></i>
        ${errorMessage}
    </div>

</c:if>

<form action="${pageContext.request.contextPath}/khachhang"
      method="post">

    <input type="hidden"
           name="action"
           value="${isEdit ? 'edit' : 'add'}">

    <div class="form-grid">

        <div class="form-group">

            <label class="form-label">
                Mã khách hàng
            </label>

            <c:choose>

                <c:when test="${isEdit}">

                    <input type="hidden"
                           name="maKH"
                           value="${kh.maKH}">

                    <input class="form-control"
                           type="text"
                           value="${kh.maKH}"
                           readonly>
                </c:when>

                <c:otherwise>

                    <input class="form-control"
                           type="text"
                           name="maKH"
                           maxlength="20"
                           placeholder="Ví dụ: KH001"
                           required>
                </c:otherwise>

            </c:choose>

        </div>

        <div class="form-group">

            <label class="form-label">
                Họ và tên
            </label>

            <input class="form-control"
                   type="text"
                   name="hoTen"
                   value="${kh.hoTen}"
                   maxlength="100"
                   required>
        </div>

        <div class="form-group full">

            <label class="form-label">
                Số điện thoại
            </label>

            <input class="form-control"
                   type="tel"
                   name="sdt"
                   value="${kh.sdt}"
                   maxlength="15"
                   required>
        </div>

    </div>

    <div class="form-actions">

        <button type="button"
                class="btn btn-outline"
                onclick="closeCustomerModal()">

            Hủy
        </button>

        <button type="submit"
                class="btn btn-primary">

            <i class="fa-solid fa-floppy-disk"></i>

            ${isEdit ? 'Lưu thay đổi' : 'Thêm khách hàng'}
        </button>

    </div>

</form>