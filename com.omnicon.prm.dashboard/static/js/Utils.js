

function allowDrop(ev) {
  ev.preventDefault();
}

function drag(ev) {
  ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
  ev.preventDefault();
  var data = ev.dataTransfer.getData("text");
  ev.target.appendChild(document.getElementById(data));
}

function link(id){
	$.ajax({
	  	async: true,
	  	url: "resources",
	  	method: "GET",
	  	processData: true,
		data: {},
		dataType: "html"
	}).done(function( msg ) {
	  	$( "#content" ).html( msg );
	});
}

$(document).ready(
	function(){
		$('#sidebar').collapse();
		$("#NavMenuButton").click(function(e) {
		  	e.preventDefault();
		  	$('#sidebar').toggleClass('collapsed');
		});
	}
);

// Simple function that accepts two parameters and calculates
// the number of hours worked within that range
function workingHoursBetweenDates(startDate, endDate) {  
    // Store minutes worked
    var hoursWorked = 0;

    // Validate input
    if (endDate < startDate) { return 0; }

    // Loop from your Start to End dates (by hour)
    var current = startDate;

    // Define work hours
    var workHours = 8;
	if (endDate.getDate() == startDate.getDate()) { return workHours; }
	// Loop while currentDate is less than end Date (by minutes)
    while(current <= endDate){
		
		if (current.getDay() !== 6 && current.getDay() !== 5) {
			hoursWorked = hoursWorked + workHours;
		}
		current = addDays(current,1);
	}
	
    // Return the number of hours
    return hoursWorked;
}

function addDays(date, days) {
    var result = new Date(date);
    result.setDate(date.getDate() + days);
    return result;
}
