<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Thêm nhân viên</title>

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

    background:#2ecc71;

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

THÊM NHÂN VIÊN

</h2>

<form
action="${pageContext.request.contextPath}/NhanVienServlet?action=add"
method="post">

<div class="row">

<label>Mã nhân viên</label>

<input
type="text"
name="maNV"
required>

</div>

<div class="row">

<label>Họ tên</label>

<input
type="text"
name="hoTen"
required>

</div>

<div class="row">

<label>Giới tính</label>

<select
name="gioiTinh">

<option>Nam</option>

<option>Nữ</option>

</select>

</div>

<div class="row">

<label>Ngày sinh</label>

<input
type="date"
name="ngaySinh"
required>

</div>

<div class="row">

<label>Số điện thoại</label>

<input
type="text"
name="sdt">

</div>
<div class="row">

<label>Địa chỉ</label>

<input
type="text"
name="diaChi">

</div>

<div class="row">

<label>Chức vụ</label>

<input
type="text"
name="chucVu"
required>

</div>

<div class="row">

<label>Lương</label>

<input
type="number"
name="luong"
required>

</div>

<div class="row">

<label>Trạng thái</label>

<select
name="trangThai">

<option value="Đang làm">Đang làm</option>

<option value="Đã nghỉ">Đã nghỉ</option>

</select>

</div>

<div class="btn">

<button
type="submit"
class="save">

Lưu

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