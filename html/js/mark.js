var context = document.querySelector(".yes-index");
var instance = new Mark(context);
let markUrl = new URL(window.location.href);
let urlParam = new URLSearchParams(markUrl.search);
let keyword = urlParam.get("mark");
if (keyword === null) {
  keyword = "default";
}
instance.mark(keyword);