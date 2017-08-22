const checkboxes = document.querySelectorAll(".checkbox-input");

if (checkboxes.length > 0) {
  checkboxes.forEach((checkbox) => {
    checkbox.addEventListener("change", function() {
      const form = document.getElementById('filter-form');
      form.submit();
    });
  })
}

