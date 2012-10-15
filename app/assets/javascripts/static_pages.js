$(document).ready(function(){
  $('#calendar').fullCalendar({
    editable: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'month',
    height: 500,
    slotMinutes: 15,
    loading: function(bool){
      if (bool) 
        $('#loading').show();
      else 
        $('#loading').hide();
    },
    events: "/events/get_events",
    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5",
    eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
     if (confirm("Are you sure about this change?")) {
      moveEvent(event, dayDelta, minuteDelta, allDay);
    }
    else {
     revertFunc();
   }
 },
 
 eventResize: function(event,dayDelta,minuteDelta,revertFunc) {
   if (confirm("Are you sure about this change?")) {
    resizeEvent(event, dayDelta, minuteDelta);
  }
  else {
   revertFunc();
 }
},

eventClick: function(event, jsEvent, view){
  showEventDetails(event);
},  



});
  
});