if (document.querySelector('meta[name="current-user"]')) {
  setInterval(() => {
    fetch("/keepalive", { credentials: "include" });
  }, 5 * 60 * 1000);
}