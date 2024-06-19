var tsInput = document.querySelector("input[type='search']");
tsInput.addEventListener("input", updateHeaderUrl);

function listenToPagination() {
  setTimeout(() => {
    var tsPagination = document.querySelectorAll(".ais-Pagination-link");
    [].forEach.call(tsPagination, function (opt) {
      opt.removeEventListener("click", updateHeaderUrl);
      opt.addEventListener("click", updateHeaderUrl);
    });
  }, 100);
}
setTimeout(() => {
  listenToPagination();
}, 100);

function updateHeaderUrl() {
  setTimeout(() => {
    var urlToUpdate = document.querySelectorAll(".ais-Hits-item h5 a");
    var tsInputVal = tsInput.value;

    urlToUpdate.forEach((el) => {
      var urlToUpdateHref = el.getAttribute("href");
      var url = new URL(urlToUpdateHref, window.location.origin);
      var params = new URLSearchParams(url.search);
      // !hash has to be at the end of the URL
      // Remove hash (if any)
      var hash = url.hash;
      url.hash = '';

      // Update 'mark' parameter
      params.set('mark', tsInputVal);

      // Set the new search parameters
      url.search = params.toString();

      // Add the hash back to the end of the URL
      url.hash = hash;

      // Update the href attribute with the relative URL
      el.setAttribute("href", url.pathname + url.search + url.hash);
    });

    listenToPagination();
  }, 500);
}