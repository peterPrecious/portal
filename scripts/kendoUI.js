var $hc = {};
$hc.fnChart = {};
$hc.parm = {};

$(function () {
  // get chart values from URL
  $hc.title = unescape($.getUrlVar("title"));
  $hc.back = unescape($.getUrlVar("back"));
  $hc.sp = unescape($.getUrlVar("sp"));
  $hc.parms = $hc.fnChart.getParms();

  // generate chart
  $hc.seriesData = "";
  $hc.fnChart.launchChart();

  // return (not sure why I did this but it works (location.href = $hc.back did not)
  $(".exit").on("click", function () {
    var a = document.createElement("a");
    a.href = $hc.back;
    document.body.appendChild(a);
    a.click();
  });
});

// web service for chart
$hc.ws = function (ws, parm, done, fail) {
  var request = $.ajax({
    type: "post",
    url: "/portal/services/kendoUI.svc/" + ws,
    data: JSON.stringify(parm),
    contentType: "application/json; charset=utf-8"
  });
  request.done(function (data) {
    done(data.d);
  });
  request.fail(function (jqXHR, textStatus) {
    fail(jqXHR, textStatus);
  });
};

// create the chart
$hc.createChart = function () {
  $("#chart").kendoChart({
    seriesDefaults: { type: "bar" },
    seriesColors: ["#0178B9"],
    dataSource: { data: $hc.seriesData },
    valueAxis: {
      crosshair: {
        tooltip: {
          format: "(0)",
          border: {
            dashType: "dashDot",
            width: 2
          },
          visible: true
        },
        visible: true
      }
    },
    series: [{ field: "value", categoryField: "category" }]
  });
};

// develop the chart
$hc.fnChart = function () {
  var _done = function (data, result, xhr) {
    data = data.replace("&rsquo;", "'");    // kendo charts don't handle extended HTML properly
    $hc.seriesData = $.parseJSON(data);
    $hc.createChart();
    $("h3").html($hc.title.replace("#top", ""));
    var chart = $("#chart").data("kendoChart");
    chart.refresh();
  };
  var _fail = function (xhr, result, statusText) {
    alert(statusText);
  };
  return {
    getParms: function () {
      var parm;
      parm = $.getUrlVar("IntParm0"); if (parm !== undefined) $hc.parm.IntParm0 = unescape(parm);
      parm = $.getUrlVar("IntParm1"); if (parm !== undefined) $hc.parm.IntParm1 = unescape(parm);
      parm = $.getUrlVar("IntParm2"); if (parm !== undefined) $hc.parm.IntParm2 = unescape(parm);
      parm = $.getUrlVar("IntParm3"); if (parm !== undefined) $hc.parm.IntParm3 = unescape(parm);
      parm = $.getUrlVar("IntParm4"); if (parm !== undefined) $hc.parm.IntParm4 = unescape(parm);
      parm = $.getUrlVar("IntParm5"); if (parm !== undefined) $hc.parm.IntParm5 = unescape(parm);
      parm = $.getUrlVar("IntParm6"); if (parm !== undefined) $hc.parm.IntParm6 = unescape(parm);
      parm = $.getUrlVar("IntParm7"); if (parm !== undefined) $hc.parm.IntParm7 = unescape(parm);
      parm = $.getUrlVar("IntParm8"); if (parm !== undefined) $hc.parm.IntParm8 = unescape(parm);
      parm = $.getUrlVar("IntParm9"); if (parm !== undefined) $hc.parm.IntParm9 = unescape(parm);

      parm = $.getUrlVar("StrParm0"); if (parm !== undefined) $hc.parm.StrParm0 = unescape(parm);
      parm = $.getUrlVar("StrParm1"); if (parm !== undefined) $hc.parm.StrParm1 = unescape(parm);
      parm = $.getUrlVar("StrParm2"); if (parm !== undefined) $hc.parm.StrParm2 = unescape(parm);
      parm = $.getUrlVar("StrParm3"); if (parm !== undefined) $hc.parm.StrParm3 = unescape(parm);
      parm = $.getUrlVar("StrParm4"); if (parm !== undefined) $hc.parm.StrParm4 = unescape(parm);
      parm = $.getUrlVar("StrParm5"); if (parm !== undefined) $hc.parm.StrParm5 = unescape(parm);
      parm = $.getUrlVar("StrParm6"); if (parm !== undefined) $hc.parm.StrParm6 = unescape(parm);
      parm = $.getUrlVar("StrParm7"); if (parm !== undefined) $hc.parm.StrParm7 = unescape(parm);
      parm = $.getUrlVar("StrParm8"); if (parm !== undefined) $hc.parm.StrParm8 = unescape(parm);
      parm = $.getUrlVar("StrParm9"); if (parm !== undefined) $hc.parm.StrParm9 = unescape(parm);

      parm = $.getUrlVar("DatParm0"); if (parm !== undefined) $hc.parm.DatParm0 = unescape(parm);
      parm = $.getUrlVar("DatParm1"); if (parm !== undefined) $hc.parm.DatParm1 = unescape(parm);
      parm = $.getUrlVar("DatParm2"); if (parm !== undefined) $hc.parm.DatParm2 = unescape(parm);
      parm = $.getUrlVar("DatParm3"); if (parm !== undefined) $hc.parm.DatParm3 = unescape(parm);
      parm = $.getUrlVar("DatParm4"); if (parm !== undefined) $hc.parm.DatParm4 = unescape(parm);
      parm = $.getUrlVar("DatParm5"); if (parm !== undefined) $hc.parm.DatParm5 = unescape(parm);
      parm = $.getUrlVar("DatParm6"); if (parm !== undefined) $hc.parm.DatParm6 = unescape(parm);
      parm = $.getUrlVar("DatParm7"); if (parm !== undefined) $hc.parm.DatParm7 = unescape(parm);
      parm = $.getUrlVar("DatParm8"); if (parm !== undefined) $hc.parm.DatParm8 = unescape(parm);
      parm = $.getUrlVar("DatParm9"); if (parm !== undefined) $hc.parm.DatParm9 = unescape(parm);

      parm = $.getUrlVar("BitParm0"); if (parm !== undefined) $hc.parm.BitParm0 = unescape(parm);
      parm = $.getUrlVar("BitParm1"); if (parm !== undefined) $hc.parm.BitParm1 = unescape(parm);
      parm = $.getUrlVar("BitParm2"); if (parm !== undefined) $hc.parm.BitParm2 = unescape(parm);
      parm = $.getUrlVar("BitParm3"); if (parm !== undefined) $hc.parm.BitParm3 = unescape(parm);
      parm = $.getUrlVar("BitParm4"); if (parm !== undefined) $hc.parm.BitParm4 = unescape(parm);
      parm = $.getUrlVar("BitParm5"); if (parm !== undefined) $hc.parm.BitParm5 = unescape(parm);
      parm = $.getUrlVar("BitParm6"); if (parm !== undefined) $hc.parm.BitParm6 = unescape(parm);
      parm = $.getUrlVar("BitParm7"); if (parm !== undefined) $hc.parm.BitParm7 = unescape(parm);
      parm = $.getUrlVar("BitParm8"); if (parm !== undefined) $hc.parm.BitParm8 = unescape(parm);
      parm = $.getUrlVar("BitParm9"); if (parm !== undefined) $hc.parm.BitParm9 = unescape(parm);
    },
    launchChart: function () {
      $hc.ws($hc.sp, $hc.parm, _done, _fail);
    }
  };
}();
