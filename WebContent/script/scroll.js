var scroll, TOP = document.getElementById("top")
window.onscroll = function () {
  if (document.documentElement.scrollTop > 20) {
    TOP.style.display = "block";
    scroll = true
  } else if (document.body.scrollTop > 20) {
    TOP.style.display = "block";
    scroll = false
  } else {
    TOP.style.display = "none";
  }
}
TOP.onclick = function () {
  var i = Math.floor(scroll ? document.documentElement.scrollTop : document.body.scrollTop);
  var scr = setInterval(function () {
    document.documentElement.scrollTop = i;
    document.body.scrollTop = i
    i -= 10;
    if (i <= 0) {
      clearInterval(scr)
    }
  }, 2)

}