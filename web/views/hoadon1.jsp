<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.HoaDon"%>
<%
    HoaDon hd = (HoaDon) request.getAttribute("hoadon");
    boolean isEdit = (hd != null);
%>
<div class="card" style="box-shadow:none; border:none; padding:10px;">
    <h3><i class="fa-solid fa-receipt"></i> <%= isEdit ? "THÊM HÓA ĐƠN" : "THÔNG TIN HÓA ĐƠN MỚI" %></h3>
    <form action="hoadon" method="post">
        <input type="hidden" name="action" value="<%= isEdit ? "update" : "insert" %>">

        <div style="margin-bottom:10px;">
            <label>Mã hóa đơn</label><br>
            <input type="text" name="maHD" value="<%= hd != null ? hd.getMaHD() : "" %>" readonly style="width:100%; padding:8px;">
        </div>

        <div style="margin-bottom:10px;">
            <label>Mã bàn</label><br>
            <input type="text" name="maBan" value="<%= isEdit ? hd.getMaBan() : "" %>" required style="width:100%; padding:8px;">
        </div>

        <div style="margin-bottom:10px;">
            <label>Mã nhân viên</label><br>
            <input type="text" name="maNV" value="<%= isEdit ? hd.getMaNV() : (session.getAttribute("maNV") != null ? session.getAttribute("maNV") : "") %>" required style="width:100%; padding:8px;">
        </div>

        <div style="margin-bottom:10px;">
            <label>Ngày tạo</label><br>
            <input type="text" name="ngayTao" value="<%= hd != null ? hd.getNgayTao() : "" %>" readonly style="width:100%; padding:8px;">
        </div>

        <div style="margin-bottom:10px;">
            <label>Tổng tiền (VNĐ)</label><br>
            <input type="number" name="tongTien" value="<%= isEdit ? String.format("%.0f", hd.getTongTien()) : "0" %>" min="0" required style="width:100%; padding:8px;">
        </div>

        <div style="margin-bottom:10px;">
            <label>Trạng thái</label><br>
            <select name="trangThai" style="width:100%; padding:8px;">
                <option value="Chưa thanh toán" <%= isEdit && "Chưa thanh toán".equals(hd.getTrangThai()) ? "selected" : "" %>>Chưa thanh toán</option>
                <option value="Đã thanh toán" <%= isEdit && "Đã thanh toán".equals(hd.getTrangThai()) ? "selected" : "" %>>Đã thanh toán</option>
                <option value="Đã hủy" <%= isEdit && "Đã hủy".equals(hd.getTrangThai()) ? "selected" : "" %>>Đã hủy</option>
            </select>
        </div>

        <div class="button-group" style="margin-top: 15px; display: flex; gap: 10px;">
            <button class="btn-save" type="submit" style="padding:8px 15px;"><i class="fa-solid fa-floppy-disk"></i> <%= isEdit ? "Cập nhật" : "Tạo mới" %></button>
            <button type="button" class="btn-back" onclick="closeHoaDonModal()" style="padding:8px 15px;"><i class="fa-solid fa-arrow-left"></i> Hủy</button>
        </div>
    </form>
</div>