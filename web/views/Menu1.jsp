<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<c:set var="isEdit"
       value="${mode == 'edit'}"/>

<form action="${pageContext.request.contextPath}/menu"
      method="post">

    <input type="hidden"
           name="action"
           value="${isEdit ? 'edit' : 'add'}">

    <div class="form-grid">

        <div class="form-group">

            <label class="form-label">
                Mã món
            </label>

            <c:choose>

                <c:when test="${isEdit}">

                    <input type="hidden"
                           name="maMon"
                           value="${menu.maMon}">

                    <input class="form-control"
                           type="text"
                           value="${menu.maMon}"
                           readonly>
                </c:when>

                <c:otherwise>

                    <input class="form-control"
                           type="text"
                           name="maMon"
                           maxlength="20"
                           placeholder="Ví dụ: M01"
                           required>
                </c:otherwise>

            </c:choose>

        </div>

        <div class="form-group">

            <label class="form-label">
                Tên món
            </label>

            <input class="form-control"
                   type="text"
                   name="tenMon"
                   value="${menu.tenMon}"
                   maxlength="100"
                   required>
        </div>

        <div class="form-group">

            <label class="form-label">
                Loại món
            </label>

            <select class="form-control"
                    name="loaiMon"
                    required>

                <option value="coffee"
                        ${menu.loaiMon == 'coffee'
                            ? 'selected'
                            : ''}>

                    Cà phê
                </option>

                <option value="tea"
                        ${menu.loaiMon == 'tea'
                            ? 'selected'
                            : ''}>

                    Trà
                </option>

                <option value="juice"
                        ${menu.loaiMon == 'juice'
                            ? 'selected'
                            : ''}>

                    Sinh tố / Nước ép
                </option>

                <option value="snack"
                        ${menu.loaiMon == 'snack'
                            ? 'selected'
                            : ''}>

                    Bánh / Ăn vặt
                </option>

            </select>
        </div>

        <div class="form-group">

            <label class="form-label">
                Giá bán
            </label>

            <input class="form-control"
                   type="number"
                   name="gia"
                   value="${menu.gia}"
                   min="0"
                   step="1000"
                   required>
        </div>

        <div class="form-group full">

            <label class="checkbox-item">

                <input type="checkbox"
                       name="trangThai"
                       value="true"
                       ${empty menu or menu.trangThai
                            ? 'checked'
                            : ''}>

                Cho phép bán món này
            </label>

        </div>

    </div>

    <div class="form-actions">

        <button type="button"
                class="btn btn-outline"
                onclick="closeMenuModal()">

            Hủy
        </button>

        <button type="submit"
                class="btn btn-primary">

            <i class="fa-solid fa-floppy-disk"></i>

            ${isEdit ? 'Lưu thay đổi' : 'Thêm món'}
        </button>

    </div>

</form>