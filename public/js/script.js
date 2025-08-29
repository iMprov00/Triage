// Initialize tooltips
document.addEventListener('DOMContentLoaded', function() {
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
  
  // Auto-hide alerts after 5 seconds
  const alerts = document.querySelectorAll('.alert')
  alerts.forEach(alert => {
    setTimeout(() => {
      const bsAlert = new bootstrap.Alert(alert)
      bsAlert.close()
    }, 5000)
  })
  
  // Enhance form validation
  const forms = document.querySelectorAll('form')
  forms.forEach(form => {
    form.addEventListener('submit', function(e) {
      const requiredFields = form.querySelectorAll('[required]')
      let isValid = true
      
      requiredFields.forEach(field => {
        if (!field.value.trim()) {
          isValid = false
          field.classList.add('is-invalid')
        } else {
          field.classList.remove('is-invalid')
        }
      })
      
      if (!isValid) {
        e.preventDefault()
        // Scroll to first invalid field
        const firstInvalid = form.querySelector('.is-invalid')
        if (firstInvalid) {
          firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' })
          firstInvalid.focus()
        }
      }
    })
  })
  
  // Touch device enhancements
  if ('ontouchstart' in document.documentElement) {
    document.body.classList.add('touch-device')
    
    // Larger touch targets for mobile/tablet
    const buttons = document.querySelectorAll('.btn')
    buttons.forEach(btn => {
      btn.style.minHeight = '44px'
      btn.style.minWidth = '44px'
    })
  }
})

// Priority calculator helper
function calculatePriority(data) {
  // This would be implemented based on your triage rules
  // For now, it's a placeholder
  return 1
}

// Добавим в конец файла
// Автофокус на поле поиска
document.addEventListener('DOMContentLoaded', function() {
  const searchInput = document.querySelector('input[name="search"]');
  if (searchInput && !searchInput.value) {
    searchInput.focus();
  }
  
  // Подсветка результатов поиска
  if (window.location.search.includes('search=')) {
    const searchTerm = new URLSearchParams(window.location.search).get('search').toLowerCase();
    const tableCells = document.querySelectorAll('td');
    
    tableCells.forEach(cell => {
      if (cell.textContent.toLowerCase().includes(searchTerm)) {
        cell.classList.add('search-highlight');
      }
    });
  }
});