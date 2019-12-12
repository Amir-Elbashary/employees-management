jQuery ->
  nu = 2
  if $('.pagination').length != 0
    $(window).scroll ->
      url = '?page=' + nu
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 2
        if $('.pagination').length != 0
          $('#loading').removeClass('d-none')
          $.getScript(url)
          nu += 1
    $(window).scroll()
