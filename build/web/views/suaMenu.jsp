<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Sửa Món</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

</head>

<body>

<div class="container mt-5">

    <div class="card">

        <div class="card-header bg-warning">

            <h3>SỬA THÔNG TIN MÓN</h3>

        </div>

        <div class="card-body">

            <form action="menu" method="post">

                <input type="hidden"
                       name="action"
                       value="update">

                <input type="hidden"
                       name="maMon"
                       value="${menu.maMon}">

                <div class="mb-3">

                    <label class="form-label">
                        Tên món
                    </label>

                    <input type="text"
                           name="tenMon"
                           class="form-control"
                           value="${menu.tenMon}"
                           required>

                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Loại
                    </label>

                    <input type="text"
                           name="loai"
                           class="form-control"
                           value="${menu.loai}"
                           required>

                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Giá
                    </label>

                    <input type="number"
                           name="gia"
                           class="form-control"
                           value="${menu.gia}"
                           required>

                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Trạng thái
                    </label>

                    <select name="trangThai" class="form-select">

                        <option value="Còn bán"
                            ${menu.trangThai == 'Còn bán' ? 'selected' : ''}>
                            Còn bán
                        </option>

                        <option value="Hết"
                            ${menu.trangThai == 'Hết' ? 'selected' : ''}>
                            Hết
                        </option>

                    </select>

                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Hình ảnh
                    </label>

                    <input type="text"
                           name="hinhAnh"
                           class="form-control"
                           value="${menu.hinhAnh}">

                </div>

                <button type="submit"
                        class="btn btn-primary">

                    Cập nhật

                </button>

                <a href="menu"
                   class="btn btn-secondary">

                    Quay lại

                </a>

            </form>

        </div>

    </div>

</div>

</body>
</html>
