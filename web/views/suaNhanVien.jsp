<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.NhanVienDAO"%>
<%@page import="model.NhanVien"%>

<%
    String ma = request.getParameter("maNV");

    NhanVienDAO dao = new NhanVienDAO();

    NhanVien nv = dao.getNhanVienById(ma);
%>

<!DOCTYPE html>

<html lang="vi">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Sửa nhân viên</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{

    background:#f5f5f5;

}

.container{

    width:700px;

    margin:40px auto;

    background:white;

    border-radius:10px;

    padding:30px;

    box-shadow:0 2px 10px rgba(0,0,0,.2);

}

h2{

    text-align:center;

    margin-bottom:25px;

    color:#4b3a2f;

}

.row{

    margin-bottom:15px;

}

label{

    display:block;

    margin-bottom:5px;

    font-weight:bold;

}

input,select{

    width:100%;

    padding:10px;

    border:1px solid #ccc;

    border-radius:6px;

}

.btn{

    margin-top:20px;

    display:flex;

    justify-content:center;

    gap:20px;

}

.save{

    background:#3498db;

    color:white;

    border:none;

    padding:12px 30px;

    border-radius:6px;

    cursor:pointer;

}

.cancel{

    background:#e74c3c;

    color:white;

    text-decoration:none;

    padding:12px 30px;

    border-radius:6px;

}

</style>

</head>

<body>

<div class="container">

<h2>

SỬA NHÂN VIÊN

</h2>

<form
action="${pageContext.request.contextPath}/NhanVienServlet?action=edit"
method="post">

<div class="row">

<label>Mã nhân viên</label>

<input
type="text"
name="maNV"
value="<%= nv.getMaNV() %>"
readonly>

</div>

<div class="row">

<label>Họ tên</label>

<input
type="text"
name="hoTen"
value="<%= nv.getHoTen() %>"
required>

</div>

<div class="row">

<label>Giới tính</label>

<select
name="gioiTinh">

<option
<%= nv.getGioiTinh().equals("Nam") ? "selected" : "" %>>
Nam
</option>

<option
<%= nv.getGioiTinh().equals("Nữ") ? "selected" : "" %>>
Nữ
</option>

</select>

</div>

<div class="row">

<label>Ngày sinh</label>

<input
type="date"
name="ngaySinh"
value="<%= nv.getNgaySinh() %>"
required>

</div>

<div class="row">

<label>Số điện thoại</label>

<input
type="text"
name="sdt"
value="<%= nv.getSdt() %>">

</div>
<div class="row">

<label>Địa chỉ</label>

<input
type="text"
name="diaChi"
value="<%= nv.getDiaChi() %>">

</div>

<div class="row">

<label>Chức vụ</label>

<input
type="text"
name="chucVu"
value="<%= nv.getChucVu() %>"
required>

</div>

<div class="row">

<label>Lương</label>

<input
type="number"
name="luong"
value="<%= nv.getLuong() %>"
required>

</div>

<div class="row">

<label>Trạng thái</label>

<select
name="trangThai">

<option value="Đang làm"
<%= nv.getTrangThai().equals("Đang làm") ? "selected" : "" %>>
Đang làm
</option>

<option value="Đã nghỉ"
<%= nv.getTrangThai().equals("Đã nghỉ") ? "selected" : "" %>>
Đã nghỉ
</option>

</select>

</div>

<div class="btn">

<button
type="submit"
class="save">

Cập nhật

</button>

<a
class="cancel"
href="${pageContext.request.contextPath}/NhanVienServlet">

Quay lại

</a>

</div>

</form>

</div>

</body>

</html>