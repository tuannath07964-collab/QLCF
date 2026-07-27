<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    .form-container {
        width: 100%;
        max-width: 400px;
        margin: 0 auto;
        font-family: sans-serif;
    }
    label {
        display: block;
        margin-top: 10px;
        font-weight: bold;
    }
    input[type="text"], input[type="date"], input[type="number"], input[type="password"], select {
        width: 100%;
        padding: 10px;
        margin: 5px 0 15px 0;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    .radio-group {
        margin-bottom: 15px;
    }
    .btn-group {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
    }
    .btn-group button {
        padding: 10px 20px;
        cursor: pointer;
        border: none;
        border-radius: 4px;
    }
    .btn-submit {
        background: #28a745;
        color: white;
    }
    .btn-cancel {
        background: #6c757d;
        color: white;
    }
</style>

<div class="form-container">
    <form action="${pageContext.request.contextPath}/nhanvien" method="post">
        <input type="hidden" name="action" value="${mode == 'edit' ? 'edit' : 'add'}">

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

        <label>Họ tên</label> 
        <input type="text" name="hoTen" value="${nv.hoTen}" required>

        <div class="form-group" style="position: relative;">
            <label>Mật khẩu</label>

            <div style="position:relative;">
                <input type="password"
                       id="passwordInput"
                       name="matKhau"
                       placeholder="${mode == 'edit'
                                      ? 'Để trống nếu không đổi'
                                      : 'Mặc định: 123456'}"
                       style="
                       width:100%;
                       padding:10px 40px 10px 10px;
                       box-sizing:border-box;">

                <i class="fa-solid fa-eye"
                   id="togglePassword"
                   onclick="togglePasswordVisibility()"
                   style="
                   position:absolute;
                   right:12px;
                   top:15px;
                   cursor:pointer;">
                </i>
            </div>
        </div>

        <label>Giới tính</label>
        <div class="radio-group">
            <input type="radio" name="gioiTinh" value="Nam" ${nv.gioiTinh == 'Nam' || mode != 'edit' ? 'checked' : ''}> Nam
            <input type="radio" name="gioiTinh" value="Nữ" ${nv.gioiTinh == 'Nữ' ? 'checked' : ''}> Nữ
        </div>

        <label>Ngày sinh</label> 
        <input type="date" name="ngaySinh" value="${nv.ngaySinh}" required>

        <label>SĐT</label> 
        <input type="text" name="sdt" value="${nv.sdt}" required>

        <label>Chức vụ
            <span style="font-weight:normal;color:#777;">
                (không bắt buộc)
            </span>
        </label>

        <select name="chucVu">
            <option value="">-- Không chọn --</option>

            <option value="Quản lý"
                    ${nv.chucVu == 'Quản lý' ? 'selected' : ''}>
                Quản lý
            </option>

            <option value="Thu ngân"
                    ${nv.chucVu == 'Thu ngân' ? 'selected' : ''}>
                Thu ngân
            </option>

            <option value="Phục vụ"
                    ${nv.chucVu == 'Phục vụ' ? 'selected' : ''}>
                Phục vụ
            </option>

            <option value="Pha chế"
                    ${nv.chucVu == 'Pha chế' ? 'selected' : ''}>
                Pha chế
            </option>

            <option value="Kho"
                    ${nv.chucVu == 'Kho' ? 'selected' : ''}>
                Kho
            </option>
        </select>

        <label>Lương cơ bản</label>

        <input type="number"
               name="luongCoBan"
               value="${empty nv.luongCoBan
                        ? 0
                        : nv.luongCoBan}"
               min="0"
               step="1000"
               required>

        <div class="btn-group">
            <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
            <button type="submit" class="btn-submit">${mode == 'edit' ? 'Cập nhật' : 'Lưu nhân viên'}</button>
        </div>
    </form>
</div>