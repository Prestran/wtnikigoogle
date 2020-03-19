$(document).ready ->
  $(document).on 'click', '.js-search-query', (e) ->
    e.preventDefault()
    _this = $(@)
    $.ajax
      url: _this.data('path')
      data: { searched: $('.js-searched-query').val() }
      dataType: 'json'
      method: 'POST'
      success: (xhr) ->
        alert(xhr.message)
        window.location = xhr.redirect_path
      error: (xhr) ->
        handleXhrErrors(xhr)

  $(document).on 'click', '.js-delete-query', (e) ->
    e.preventDefault()
    _this = $(@)
    if confirm('Are you sure?')
      $.ajax
        url: _this.attr('href')
        dataType: 'json'
        method: 'DELETE'
        success: (xhr) ->
          alert(xhr.message)
          window.location = xhr.redirect_path
        error: (xhr) ->
          alert(xhr.message)
