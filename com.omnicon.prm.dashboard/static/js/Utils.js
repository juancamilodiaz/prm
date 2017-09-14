

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
    var minutesWorked = 480;

    // Validate input
    if (endDate < startDate) { return 0; }

    // Loop from your Start to End dates (by hour)
    var current = startDate;

    // Define work range
    var workHoursStart = 8;
    var workHoursEnd = 16;
    var includeWeekends = true;
	console.log(current.getDay()+ "-" + endDate.getDay())

    // Loop while currentDate is less than end Date (by minutes)
    while(current <= endDate){          
        // Is the current time within a work day (and if it 
        // occurs on a weekend or not)          
        if(current.getHours() >= workHoursStart && current.getHours() < workHoursEnd && 
			((includeWeekends ? current.getDay() !== 6 && current.getDay() !== 5 : true)//0-6
			&& (includeWeekends ? endDate.getDay() !== 6 && endDate.getDay() !== 5 : true))){
              minutesWorked++;
        }

        // Increment current time
        current.setTime(current.getTime() + 1000 * 60);
    }

    // Return the number of hours
    return minutesWorked / 60;
}
