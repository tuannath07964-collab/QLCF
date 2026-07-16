// Logic active menu đồng bộ
const menuItems = document.querySelectorAll('.menu li');
menuItems.forEach(item => {
    item.addEventListener('click', function() {
        menuItems.forEach(i => i.classList.remove('active'));
        this.classList.add('active');
    });
});

// Logic toggle sidebar
document.getElementById('toggleBtn')?.addEventListener('click', function() {
    document.querySelector('.sidebar').classList.toggle('collapsed');
});