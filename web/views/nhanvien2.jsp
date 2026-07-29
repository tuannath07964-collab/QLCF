<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<div class="alert alert-warning">

    <i class="fa-solid fa-circle-info"></i>

    Nhân viên chỉ đăng nhập được khi có ít nhất một ca
    và đang nằm trong khoảng giờ làm.
</div>

<form action="${pageContext.request.contextPath}/nhanvien"
      method="post">

    <input type="hidden"
           name="action"
           value="updateCa">

    <input type="hidden"
           name="maNV"
           value="${nv.maNV}">

    <div class="form-grid">

        <div class="form-group full">

            <label class="form-label">
                Nhân viên
            </label>

            <input class="form-control"
                   type="text"
                   value="${nv.maNV} - ${nv.hoTen}"
                   readonly>
        </div>

        <div class="form-group full">

            <label class="form-label">
                Chọn ca làm
            </label>

            <div class="checkbox-row">

                <label class="checkbox-item">

                    <input type="checkbox"
                           name="caSang"
                           ${nv.caSang ? 'checked' : ''}>

                    Ca sáng
                </label>

                <label class="checkbox-item">

                    <input type="checkbox"
                           name="caChieu"
                           ${nv.caChieu ? 'checked' : ''}>

                    Ca chiều
                </label>

                <label class="checkbox-item">

                    <input type="checkbox"
                           name="caToi"
                           ${nv.caToi ? 'checked' : ''}>

                    Ca tối
                </label>

            </div>
        </div>

        <div class="form-group">

            <label class="form-label"
                   for="gioBatDau">

                Giờ bắt đầu
            </label>

            <input class="form-control"
                   type="time"
                   id="gioBatDau"
                   name="gioBatDau"
                   value="${nv.gioBatDau}"
                   required>
        </div>

        <div class="form-group">

            <label class="form-label"
                   for="gioKetThuc">

                Giờ kết thúc
            </label>

            <input class="form-control"
                   type="time"
                   id="gioKetThuc"
                   name="gioKetThuc"
                   value="${nv.gioKetThuc}"
                   required>
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

            <i class="fa-regular fa-clock"></i>
            Lưu ca làm
        </button>

    </div>

</form>