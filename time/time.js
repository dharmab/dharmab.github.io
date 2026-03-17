const zones = [
  { id: "tz-sf", tz: "America/Los_Angeles" },
  { id: "tz-slc", tz: "America/Denver" },
  { id: "tz-manistee", tz: "America/Detroit" },
  { id: "tz-east", tz: "America/New_York" },
  { id: "tz-uk", tz: "Europe/London" },
  { id: "tz-nl", tz: "Europe/Amsterdam" },
  { id: "tz-de", tz: "Europe/Berlin" },
];

function update() {
  const now = new Date();
  document.getElementById("local-date").textContent = now.toLocaleDateString([], {
    weekday: "long", month: "long", day: "numeric"
  });
  document.getElementById("local-time").textContent = now.toLocaleTimeString([], {
    hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: false
  });
  for (const z of zones) {
    document.getElementById(z.id).textContent = now.toLocaleTimeString([], {
      hour: "2-digit", minute: "2-digit", hour12: false, timeZone: z.tz
    });
  }
}

update();
setInterval(update, 1000);
