// 1. Logic ẩn hiện Sidebar
document.getElementById('toggleBtn').addEventListener('click', function() {
    const sidebar = document.querySelector('.sidebar');
    sidebar.classList.toggle('collapsed'); // Thêm class này để sidebar co lại
});

// 2. Logic giữ màu khi click menu (Active class)
const menuItems = document.querySelectorAll('.menu li');
menuItems.forEach(item => {
    item.addEventListener('click', function() {
        menuItems.forEach(i => i.classList.remove('active'));
        this.classList.add('active');
    });
});