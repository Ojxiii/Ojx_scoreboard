window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "open":
      Open(event.data);
      break;
    case "close":
      Close();
      break;
    case "setup":
      Setup(event.data);
      break;
  }
});

const Open = (data) => {
  $(".scoreboard-bg-block").stop(true, true).fadeIn(150); 
  $("#total-players").html("<p>" + data.players + " of " + data.maxPlayers + "</p>");

  $.each(data.requiredCops, (i, category) => {
    var beam = $(".scoreboard-info").find('[data-type="' + i + '"]');
    
    if (category.busy) {
      $(beam).css("background", "radial-gradient(circle, var(--shit) 0%, transparent 100%)");
    } else if (data.currentCops >= category.minimumPolice) {
      $(beam).css("background", "radial-gradient(circle, var(--shit2) 0%, transparent 100%)");
    } else {
      $(beam).css("background", "radial-gradient(circle, var(--shit3) 0%, transparent 100%)");
    }
  });
  
};

const Close = () => {
  $(".scoreboard-bg-block").stop(true, true).fadeOut(150); 
  $.post(`https://${GetParentResourceName()}/exit`);
};

document.onkeyup = function (data) {
  if (data.key === "Escape") {
    Close();
  }
};

const Setup = (data) => {
  let scoreboardHtml = "";
  scoreboardHtml += `<div class="scoreboard-miniheader">Crime status <i class="fas fa-masks-theater"></i></div>`;
  $.each(data.items, (index, value) => {
    scoreboardHtml += `
      <div class="scoreboard-info-beam" data-type=${index}>
      <div class="scoreboard-icon">
      <i class="fas fa-masks-theater"></i>
      </div>
        <div class="scoreboard-title">
            <p>${value}</p>
        </div>
        <div class="info-beam-status"></div>
      </div>
    `;
  });
  scoreboardHtml += `
    <div class="scoreboard-miniheader">Other status <i class="fas fa-masks-theater"></i></div>
    <div class="scoreboard-info-beam">
    <div class="scoreboard-icon">
      <i class="fas fa-users"></i>
    </div>
      <div class="scoreboard-title">
        <p>Online players</p>
      </div>
      <div class="status" id="total-players"></div>
    </div>
  `;
  $(".scoreboard-info").html(scoreboardHtml);
};
