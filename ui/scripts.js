window.addEventListener("message", function (event) {
  var item = event.data;
  if (item.message == "showtypes") {
    $("#carry-container").show();
    OpenMenu();
  }

  if (item.message == "hide") {
    $("#carry-container").hide();
    CloseMenu();
  }
});

function CloseMenu() {
  $("body").css("display", "none");
  $("#carry-container").hide();
}

function OpenMenu() {
  $("body").css({
    display: "block",
    "background-color": "rgba(255, 255, 255, 0)",
  });
}

$(".quit").click(function () {
  sendNUI("close");
});

document.addEventListener("keydown", (event) => {
  if (event.keyCode == 27 || event.keyCode === 36 || event.keyCode === 8) {
    CloseMenu();
    sendNUI("close");
  }
});

$("#carry-btn").click(function () {
  CloseMenu();
  sendNUI("selectedtype", "carry1");
});

$("#armsitback-btn").click(function () {
  CloseMenu();
  sendNUI("selectedtype", "carry2");
});

$("#piggyback-btn").click(function () {
  CloseMenu();
  sendNUI("selectedtype", "carry3");
});

function sendNUI(event, data, cb = () => {}) {
  fetch(`https://${GetParentResourceName()}/${event}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(data),
  })
    .then((resp) => resp.json())
    .then((resp) => cb(resp));
}
