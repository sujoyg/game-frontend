var gamestate = {};

function render(state) {
  gamestate = state;
  $("form.game input[name='guess']").val("");
  $(".game .card--image img").attr("src", state["image"]);

  // Update scores
  $(".score--unit__correct .score--number").text(state["score"]);
  $(".score--unit__total .score--number").text(state["rounds"]);
  $(".score--unit__rounds .score--number").text(state["remaining"]);

  if (state["hit"]) {
    $(".game .status__correct").show();
    $(".game .status__incorrect").hide();
  } else {
    $(".game .status__correct").hide();
    $(".game .status__incorrect").show();
  }

  if (state["remaining"] == 0) {
    $("#button_next").hide();
    $("#button_finish").show();
  }

  if (state["state"] == "flipped" || state["state"] == "over") {
    // Update user information
    $(".game .name").text(state["name"]);
    $(".game .guess").text(state["guess"]);
    $(".game a.email").text(state["email"]);
    $(".game a.email").attr("href", "mailto:" + state["email"]);

    if (state["state"] == "over") {
      $(".game .status").hide();
    }

    $(".game .card--image img").attr("src", "");

    $(".game .flipper").addClass("flipped");
  } else {
    $(".game .flipper").removeClass("flipped");
  }
}


$(function () {
  var $form = $("form.game");
  $.getJSON($form.data("state")).done(function (state) {
    render(state);
  });

  $("[name='guess']").autocomplete({
    source: "/game/autocomplete",
    minLength: 2,

    // optional (if other layers overlap autocomplete list)
    open: function (event, ui) {
      $(".ui-autocomplete").css("z-index", 1000);
    }
  });

  $("#button_next").click(function (e) {
    e.preventDefault();
    $.getJSON($("form.game").data("next")).done(function (state) {
      render(state);
    });
  });

  $("#button_skip").click(function (e) {
    e.preventDefault();
    $.getJSON($("form.game").data("next")).done(function (state) {
      render(state);
      if (state["remaining"] == 0) {

      }
    });
  });

  $("#button_finish").click(function (e) {
    e.preventDefault();
    location.href = $(".game").data("finish");
  });

  $("form.game").submit(function (e) {
    e.preventDefault();
    if (gamestate["state"] == "flipped" && gamestate["remaining"] > 0) {
      $("#button_next").click();
    } else if (gamestate["remaining"] == 0 || gamestate["state"] == "over") {
      $("#button_finish").click();
    } else {
      var $form = $(e.target);
      var data = $form.serialize();
      $.post($form.attr("action"), data).done(function (state) {
        render(state);
      });
    }
  });
});
