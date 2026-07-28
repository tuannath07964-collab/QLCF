<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="fn"
           uri="jakarta.tags.functions" %>

<style>
    .shift-form {
        width: 100%;
        font-family: sans-serif;
    }

    .shift-employee {
        margin: 0 0 18px;
        padding: 11px 13px;
        border-radius: 7px;
        background: #f3f4f6;
        color: #374151;
    }

    .shift-options {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        margin: 12px 0 18px;
    }

    .shift-options label {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        cursor: pointer;
    }

    .time-field {
        margin-bottom: 13px;
    }

    .time-field label {
        display: block;
        margin-bottom: 6px;
        font-weight: 700;
    }

    .time-field input {
        width: 100%;
        padding: 9px;
        box-sizing: border-box;
        border: 1px solid #ccc;
        border-radius: 6px;
    }

    .shift-warning {
        padding: 10px;
        margin-bottom: 14px;
        border-radius: 7px;
        background: #fff3cd;
        color: #664d03;
        font-size: 13px;
        line-height: 1.5;
    }

    .shift-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }

    .shift-actions button {
        border: 0;
        padding: 10px 18px;
        border-radius: 6px;
        cursor: pointer;
    }

    .btn-save-shift {
        background: #198754;
        color: white;
    }

    .btn-cancel-shift {
        background: #6c757d;
        color: white;
    }
</style>

<form class="shift-form"
      action="${pageContext.request.contextPath}/nhanvien"
      method="post"
      onsubmit="return validateShiftForm(this)">

    <input type="hidden"
           name="action"
           value="updateCa">

    <input type="hidden"
           name="maNV"
           value="${nv.maNV}">

    <div class="shift-employee">

        <b>
            ${nv.maNV}
            -
            ${nv.hoTen}
        </b>

        <div style="
             margin-top:5px;
             font-size:13px;
             color:#6b7280;">

            Trạng thái:
            ${empty nv.trangThai
                ? 'Đang làm'
                : nv.trangThai}
        </div>

    </div>

    <div>

        <label style="font-weight:700;">
            Chọn ca làm
        </label>

        <div class="shift-options">

            <label>
                <input type="checkbox"
                       name="caSang"
                       value="true"
                       ${nv.caSang
                            ? 'checked'
                            : ''}>

                Ca sáng
            </label>

            <label>
                <input type="checkbox"
                       name="caChieu"
                       value="true"
                       ${nv.caChieu
                            ? 'checked'
                            : ''}>

                Ca chiều
            </label>

            <label>
                <input type="checkbox"
                       name="caToi"
                       value="true"
                       ${nv.caToi
                            ? 'checked'
                            : ''}>

                Ca tối
            </label>

        </div>

    </div>

    <div class="time-field">

        <label for="gioBatDau">
            Giờ bắt đầu
        </label>

        <input type="time"
               id="gioBatDau"
               name="gioBatDau"
               value="${not empty nv.gioBatDau
                   ? fn:substring(nv.gioBatDau, 0, 5)
                   : ''}"
               required>

    </div>

    <div class="time-field">

        <label for="gioKetThuc">
            Giờ kết thúc
        </label>

        <input type="time"
               id="gioKetThuc"
               name="gioKetThuc"
               value="${not empty nv.gioKetThuc
                   ? fn:substring(nv.gioKetThuc, 0, 5)
                   : ''}"
               required>

    </div>

    <div class="shift-warning">

        <i class="fa-solid fa-triangle-exclamation"></i>

        Nhân viên chưa được phân ca sẽ không đăng nhập được.

        <br>

        Nhân viên chỉ đăng nhập được trong khoảng giờ bắt đầu
        và giờ kết thúc đã thiết lập.

        <br>

        Ca qua nửa đêm vẫn được hỗ trợ, ví dụ:
        <b>22:00 - 06:00</b>.
    </div>

    <div class="shift-actions">

        <button type="button"
                class="btn-cancel-shift"
                onclick="closeModal()">

            Hủy
        </button>

        <button type="submit"
                class="btn-save-shift">

            <i class="fa-solid fa-check"></i>
            Lưu phân ca
        </button>

    </div>

</form>

<script>
    function validateShiftForm(form) {
        const caSang =
                form.querySelector(
                        'input[name="caSang"]'
                );

        const caChieu =
                form.querySelector(
                        'input[name="caChieu"]'
                );

        const caToi =
                form.querySelector(
                        'input[name="caToi"]'
                );

        const gioBatDau =
                form.querySelector(
                        'input[name="gioBatDau"]'
                );

        const gioKetThuc =
                form.querySelector(
                        'input[name="gioKetThuc"]'
                );

        if (
            !caSang.checked
            && !caChieu.checked
            && !caToi.checked
        ) {
            alert(
                    "Phải chọn ít nhất một ca làm."
            );

            return false;
        }

        if (
            !gioBatDau.value
            || !gioKetThuc.value
        ) {
            alert(
                    "Phải nhập giờ bắt đầu và giờ kết thúc."
            );

            return false;
        }

        if (
            gioBatDau.value
            === gioKetThuc.value
        ) {
            alert(
                    "Giờ bắt đầu và giờ kết thúc không được giống nhau."
            );

            return false;
        }

        return true;
    }
</script>