var context = document.querySelector(".yes-index");
var instance = new Mark(context);
let url = new URL(window.location.href);
let urlParam = new URLSearchParams(url.search);
let keyword = urlParam.get("mark");
if (keyword === null) {
  keyword = "default";
}
instance.mark(keyword);