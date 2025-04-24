document.addEventListener('turbo:load', function () {
  setTimeout(() => {
    const alerts = document.querySelectorAll(".alert");
    alerts.forEach(alert => {
      let bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
      bsAlert.close();
    });
  }, 3000);
  // Initialize treeview
  $('[data-widget="tree"]').tree('destroy');
  $('[data-widget="tree"]').tree('init');
  $('[data-widget="tree"]').each(function () {
    $(this).tree()
  });
});