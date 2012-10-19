$(document).ready(function(){
  $('#calendar').fullCalendar({
    editable: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'month',
    height: 600,
    width: 940,
    slotMinutes: 30,
    loading: function(bool){
      if (bool) 
        $('#loading').show();
      else 
        $('#loading').hide();
    },
    events: 'events/get_events',
    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5",
    eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
      moveEvent(event, dayDelta, minuteDelta, allDay);

 },
 
 eventResize: function(event,dayDelta,minuteDelta,revertFunc) {
    resizeEvent(event, dayDelta, minuteDelta);

},

eventClick: function(event, jsEvent, view){
  showEventDetails(event);
},  



});
  
});
