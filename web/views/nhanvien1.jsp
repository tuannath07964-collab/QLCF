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

<form action="${pageContext.request.contextPath}/nhanvien"
      method="post">

    <input type="hidden"
           name="action"
           value="${isEdit ? 'edit' : 'add'}">

    <c:if test="${isEdit}">

        <input type="hidden"
               name="maNV"
               value="${nv.maNV}">

    </c:if>

    <div class="form-grid">

        <div class="form-group">

            <label class="form-label">
                Mã nhân viên
            </label>

            <input class="form-control"
                   type="text"
                   value="${isEdit ? nv.maNV : 'Hệ thống tự sinh khi lưu'}"
                   readonly>
        </div>

        <div class="form-group">

            <label class="form-label"
                   for="hoTen">

                Họ và tên
            </label>

            <input class="form-control"
                   type="text"
                   id="hoTen"
                   name="hoTen"
                   value="${nv.hoTen}"
                   maxlength="100"
                   required>
        </div>

        <div class="form-group">

            <label class="form-label">
                Giới tính
            </label>

            <select class="form-control"
                    name="gioiTinh">

                <option value="">
                    Chưa cập nhật
                </option>

                <option value="Nam"
                        ${nv.gioiTinh == 'Nam'
                            ? 'selected'
                            : ''}>

                    Nam
                </option>

                <option value="Nữ"
                        ${nv.gioiTinh == 'Nữ'
                            ? 'selected'
                            : ''}>

                    Nữ
                </option>

                <option value="Khác"
                        ${nv.gioiTinh == 'Khác'
                            ? 'selected'
                            : ''}>

                    Khác
                </option>

            </select>
        </div>

        <div class="form-group">

            <label class="form-label"
                   for="ngaySinh">

                Ngày sinh
            </label>

            <input class="form-control"
                   type="date"
                   id="ngaySinh"
                   name="ngaySinh"
                   value="${nv.ngaySinh}">
        </div>

        <div class="form-group">

            <label class="form-label"
                   for="sdt">

                Số điện thoại
            </label>

            <input class="form-control"
                   type="tel"
                   id="sdt"
                   name="sdt"
                   value="${nv.sdt}"
                   maxlength="15"
                   required>
        </div>

        <div class="form-group">

            <label class="form-label">
                Chức vụ
            </label>

            <select class="form-control"
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
        </div>

        <div class="form-group">

            <label class="form-label">
                Trạng thái
            </label>

            <select class="form-control"
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
        </div>

        <div class="form-group">

            <label class="form-label"
                   for="luongCoBan">

                Lương cơ bản
            </label>

            <input class="form-control"
                   type="number"
                   id="luongCoBan"
                   name="luongCoBan"
                   value="${empty nv.luongCoBan ? 0 : nv.luongCoBan}"
                   min="0"
                   step="1000"
                   required>
        </div>

        <div class="form-group full">

            <label class="form-label"
                   for="passwordInput">

                ${isEdit ? 'Mật khẩu mới' : 'Mật khẩu đăng nhập'}
            </label>

            <div style="position: relative;">

                <input class="form-control"
                       type="password"
                       id="passwordInput"
                       name="matKhau"
                       placeholder="${isEdit
                                    ? 'Để trống nếu giữ mật khẩu cũ'
                                    : 'Mặc định 123456 nếu để trống'}"
                       style="padding-right: 44px;">

                <button type="button"
                        class="btn btn-icon btn-outline"
                        onclick="toggleModalPassword()"
                        style="
                        position:absolute;
                        right:2px;
                        top:2px;
                        border:0;">

                    <i class="fa-solid fa-eye"
                       id="passwordToggleIcon"></i>
                </button>

            </div>

            <span class="form-hint">

                ${isEdit
                    ? 'Chỉ quản lý được phép đổi mật khẩu nhân viên.'
                    : 'Để trống sẽ sử dụng mật khẩu mặc định 123456.'}
            </span>
        </div>

    </div>

    <div class="form-actions">

        <button type="button"
                class="btn btn-outline"
                onclick="closeModal()">

            Hủy
        </button>

        <button type="submit"
                class="btn btn-primary">

            <i class="fa-solid fa-floppy-disk"></i>

            ${isEdit ? 'Lưu thay đổi' : 'Thêm nhân viên'}
        </button>

    </div>

</form>