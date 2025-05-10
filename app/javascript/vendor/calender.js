import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";

document.addEventListener("turbo:load", () => {
  const calendarEl = document.getElementById("calendar");
  if (calendarEl) {
    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth",
      events: JSON.parse(calendarEl.dataset.events || "[]"),
      eventClick: function (info) {
        window.location.href = `/events/${info.event.id}`;
      }
    });
    calendar.render();
  }
});