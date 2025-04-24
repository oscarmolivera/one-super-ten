document.addEventListener("DOMContentLoaded", function () {
  setTimeout(() => {
    const alerts = document.querySelectorAll(".alert");
    alerts.forEach(alert => {
      let bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
      bsAlert.close();
    });
  }, 3000);
});