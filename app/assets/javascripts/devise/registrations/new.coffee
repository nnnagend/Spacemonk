class Datepicker
  constructor: () ->
    $( ".datepicker" ).datepicker
      dateFormat: 'dd-mm-yy',
      changeMonth: true,
      changeYear: true,
      yearRange:  '-90:-5'

$ ->
  new Datepicker()
