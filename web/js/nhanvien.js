function openModal(url, title) {
        document.getElementById('modalTitle').innerText = title;
        fetch(url)
            .then(response => response.text())
            .then(html => {
                document.getElementById('modalBody').innerHTML = html;
                document.getElementById('myModal').style.display = 'flex';
            });
    }

    function closeModal() {
        document.getElementById('myModal').style.display = 'none';
    }

    // Đóng khi click ra ngoài
    window.onclick = function (event) {
        var modal = document.getElementById("myModal");
        if (event.target == modal) {
            closeModal();
        }
    }
function openCaModal(maNV) {
    document.getElementById('myModal').style.display = 'flex';
    document.getElementById('modalTitle').innerText = 'Ca làm nhân viên';
    
    // SỬA Ở ĐÂY: Dùng dấu nháy đơn hoặc kép và cộng chuỗi, không dùng ${}
    document.getElementById('modalBody').innerHTML = 
        '<form action="' + contextPath + '/nhanvien" method="POST">' +
            '<input type="hidden" name="action" value="updateCa">' +
            '<input type="hidden" name="maNV" value="' + maNV + '">' + 
            '<label>Chọn ca làm:</label><br>' +
            '<input type="checkbox" name="caSang"> Sáng ' +
            '<input type="checkbox" name="caChieu"> Chiều ' +
            '<input type="checkbox" name="caToi"> Tối ' +
            '<br><br>' +
            '<label>Giờ bắt đầu:</label> <input type="time" name="gioBatDau"> ' +
            '<label>Giờ kết thúc:</label> <input type="time" name="gioKetThuc">' +
            '<br><br>' +
            '<button type="submit" style="background:green; color:white; padding:10px 20px; border:none; border-radius:5px;">Lưu thay đổi</button>' +
        '</form>';
}