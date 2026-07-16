document.addEventListener("DOMContentLoaded", function() {
    const toggleIcon = document.getElementById('toggleIcon');
    const passwordField = document.getElementById('passwordField');

    if (toggleIcon && passwordField) {
        toggleIcon.addEventListener('click', function() {
            // Đổi type của input
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);
            
            // Đổi icon mắt
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    }
});