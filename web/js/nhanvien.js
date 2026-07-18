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