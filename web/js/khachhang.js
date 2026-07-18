function openModal(url, title) {
    document.getElementById('modalTitle').innerText = title;
    
    fetch(url)
        .then(res => res.text())
        .then(html => {
            document.getElementById('modalBody').innerHTML = html;
            // Chỉ cần set display là flex
            document.getElementById('myModal').style.display = 'flex';
        });
}

function closeModal() {
    document.getElementById('myModal').style.display = 'none';
}