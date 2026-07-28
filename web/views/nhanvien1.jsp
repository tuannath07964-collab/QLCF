<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<style>
    .form-container {
        width: 100%;
        max-width: 430px;
        margin: 0 auto;
        font-family: sans-serif;
    }

    .form-container label {
        display: block;
        margin-top: 10px;
        font-weight: 700;
    }

    .form-container input,
    .form-container select {
        width: 100%;
        padding: 10px;
        margin: 5px 0 13px;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-sizing: border-box;
    }

    .form-container input:focus,
    .form-container select:focus {
        outline: none;
        border-color: #806044;
        box-shadow: 0 0 0 3px rgba(128, 96, 68, .1);
    }

    .radio-group {
        margin: 8px 0 13px;
    }

    .radio-group input {
        width: auto;
        margin-right: 4px;
    }

    .btn-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 18px;
    }

    .btn-group button {
        padding: 10px 18px;
        border: 0;
        border-radius: 6px;
        cursor: pointer;
    }

    .btn-submit {
        background: #198754;
        color: #fff;
    }

    .btn-cancel {
        background: #6c757d;
        color: #fff;
    }

    .password-wrapper {
        position: relative;
    }

    .password-wrapper input {
        padding-right: 42px;
    }

    .password-wrapper i {
        position: absolute;
        right: 12px;
        top: 17px;
        cursor: pointer;
        color: #555;
    }

    .form-note {
        display: block;
        margin-top: -7px;
        color: #777;
        font-size: 12px;
        line-height: 1.4;
    }
</style>

<div class="form-container">

    <form action="${pageContext.request.contextPath}/nhanvien"
          method="post">

        <input type="hidden"
               name="action"
               value="${mode == 'edit'
                        ? 'edit'
                        : 'add'}">

        <label>Mã nhân viên</label>

        <c:choose>

            <c:when test="${mode == 'edit'}">

                <input type="text"
                       name="maNV"
                       value="${nv.maNV}"
                       readonly>

            </c:when>

            <c:otherwise>

                <input type="text"
                       value="Tự động tạo khi lưu"
                       readonly>

            </c:otherwise>

        </c:choose>

        <label for="hoTen">
            Họ tên
        </label>

        <input type="text"
               id="hoTen"
               name="hoTen"
               value="${nv.hoTen}"
               maxlength="100"
               required>

        <label>Giới tính</label>

        <div class="radio-group">

            <label style="
                   display:inline;
                   font-weight:400;">

                <input type="radio"
                       name="gioiTinh"
                       value="Nam"
                       ${nv.gioiTinh == 'Nam'
                         or mode != 'edit'
                            ? 'checked'
                            : ''}>

                Nam
            </label>

            <label style="
                   display:inline;
                   font-weight:400;
                   margin-left:14px;">

                <input type="radio"
                       name="gioiTinh"
                       value="Nữ"
                       ${nv.gioiTinh == 'Nữ'
                            ? 'checked'
                            : ''}>

                Nữ
            </label>

        </div>

        <label for="ngaySinh">
            Ngày sinh
        </label>

        <input type="date"
               id="ngaySinh"
               name="ngaySinh"
               value="${nv.ngaySinh}">

        <label for="sdt">
            Số điện thoại
        </label>

        <input type="tel"
               id="sdt"
               name="sdt"
               value="${nv.sdt}"
               maxlength="15"
               pattern="[0-9]{9,15}"
               title="Số điện thoại gồm từ 9 đến 15 chữ số"
               required>

        <label for="chucVu">
            Vai trò
        </label>

        <select id="chucVu"
                name="chucVu"
                required>

            <option value="Nhân viên"
                    ${nv.chucVu != 'Quản lý'
                        ? 'selected'
                        : ''}>

                Nhân viên
            </option>

            <option value="Quản lý"
                    ${nv.chucVu == 'Quản lý'
                        ? 'selected'
                        : ''}>

                Quản lý
            </option>

        </select>

        <label for="trangThai">
            Trạng thái
        </label>

        <select id="trangThai"
                name="trangThai"
                required>

            <option value="Đang làm"
                    ${empty nv.trangThai
                      or nv.trangThai == 'Đang làm'
                        ? 'selected'
                        : ''}>

                Đang làm
            </option>

            <option value="Tạm nghỉ"
                    ${nv.trangThai == 'Tạm nghỉ'
                        ? 'selected'
                        : ''}>

                Tạm nghỉ
            </option>

            <option value="Nghỉ làm"
                    ${nv.trangThai == 'Nghỉ làm'
                        ? 'selected'
                        : ''}>

                Nghỉ làm
            </option>

        </select>

        <label for="luongCoBan">
            Lương cơ bản
        </label>

        <input type="number"
               id="luongCoBan"
               name="luongCoBan"
               value="${empty nv.luongCoBan
                        ? 0
                        : nv.luongCoBan}"
               min="0"
               step="1000"
               required>

        <label for="passwordInput">
            Mật khẩu
        </label>

        <div class="password-wrapper">

            <input type="password"
                   id="passwordInput"
                   name="matKhau"
                   maxlength="100"
                   placeholder="${mode == 'edit'
                       ? 'Để trống nếu không đổi'
                       : 'Mặc định: 123456'}">

            <i class="fa-solid fa-eye"
               id="togglePassword"
               onclick="togglePasswordVisibility()"></i>

        </div>

        <small class="form-note">

            <c:choose>

                <c:when test="${mode == 'edit'}">
                    Để trống nếu muốn giữ nguyên mật khẩu.
                </c:when>

                <c:otherwise>
                    Nếu để trống, mật khẩu mặc định là
                    <b>123456</b>.
                </c:otherwise>

            </c:choose>

            Chỉ tài khoản Quản lý mới được thay đổi mật khẩu.
        </small>

        <div class="btn-group">

            <button type="button"
                    class="btn-cancel"
                    onclick="closeModal()">

                Hủy
            </button>

            <button type="submit"
                    class="btn-submit">

                ${mode == 'edit'
                    ? 'Cập nhật'
                    : 'Lưu nhân viên'}
            </button>

        </div>

    </form>

</div>