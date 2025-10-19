// Global Search Functionality - Simple Form Submit
document.addEventListener("DOMContentLoaded", function () {
  initializeGlobalSearch();
});

function initializeGlobalSearch() {
  const searchInput = document.getElementById("globalSearchInput");

  if (!searchInput) {
    return;
  }

  // Handle Enter key to submit form
  searchInput.addEventListener("keypress", function (e) {
    if (e.key === "Enter") {
      const query = e.target.value.trim();
      if (query.length >= 2) {
        submitSearch(query);
      }
    }
  });
}

function submitSearch(query) {
  const contextPath =
    document
      .querySelector('meta[name="context-path"]')
      ?.getAttribute("content") || "";

  // Create form and submit
  const form = document.createElement("form");
  form.method = "GET";
  form.action = `${contextPath}/search`;

  const queryInput = document.createElement("input");
  queryInput.type = "hidden";
  queryInput.name = "q";
  queryInput.value = query;

  const typeInput = document.createElement("input");
  typeInput.type = "hidden";
  typeInput.name = "type";
  typeInput.value = "all";

  form.appendChild(queryInput);
  form.appendChild(typeInput);

  document.body.appendChild(form);
  form.submit();
}
