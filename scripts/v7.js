$(function () {
  // clicking on this symbol clears the previous (textbox)
  $(".clear").on("click", function () { $(this).prev().val(""); });
});


// used for selecting/checking/unchecking all check boxes from gridview header
// note there is a similiar one in content.asp which only works if element is enabled
function selectAll(ele, id) {
  if (ele.enabled) {
    if (ele.checked) {
      $("." + id + " input").prop('checked', true);
    } else {
      $("." + id + " input").prop('checked', false);
    }
  }
}


// currently unused
$(function () { });


// used to show/hide description (also uses css hoverUnderline) [used to use fadeIn/Out but changed to hide/show]
function fadeIn() {
  $(".thisTitle").toggle();
}



// next 3 functions are for divPage sizing which adds a scroll bar if divPage height excedes available height.  Else divPage rolls over the footing.

/* resize on load */
$(function () {
  resizeDivPage();
});

/* resize on resize */
$(window).on("resize", function () {
  var resizeTimer;
  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(resizeDivPage, 500);
});

function resizeDivPage() {
  $(".divPage").css("height", "auto");  // reset height as it might have been reset/shrunk previously
  var divHeight = $(".divPage").height();
  var winHeight = $(window).height();
  if (divHeight > 0 && winHeight < divHeight + 200) { $(".divPage").height($(window).height() - 200); }
}