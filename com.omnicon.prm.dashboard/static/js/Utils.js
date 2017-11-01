

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

function setHeaderSize(){
	if ($(window).width() < 680){
		$("#NavCenter").hide();
		$("#NavLeft").removeClass('col-sm-3');
		$("#NavLeft").addClass('col-sm-2');
	}
	else if ($(window).width() < 1000) {
		$("#NavCenter").show();
		$("#NavLeft").addClass('col-sm-3');
		$("#NavLeft").removeClass('col-sm-2');
	}
	else {
		$("#NavCenter").show();
		$("#NavLeft").removeClass('col-sm-3');
		$("#NavLeft").addClass('col-sm-2');
	}
	
	if ($(window).height() < 450)
	{
		$('#FooterPlaceHolder').css('position', 'absolute');
		$('#FooterPlaceHolder').css('top', 450);
		$('#FooterPlaceHolder').css('bottom', '');
	}
	else
	{
		$('#FooterPlaceHolder').css('position', 'fixed');
		$('#FooterPlaceHolder').css('top', '');
		$('#FooterPlaceHolder').css('bottom', 0);
	}
}

$(document).ready(
	function(){
		setHeaderSize();
		$('#sidebar').collapse();
		$("#NavMenuButton").click(function(e) {
		  	e.preventDefault();
		  	$('#sidebar').toggleClass('collapsed');
		});
		$(window).resize(
			function(){
				setHeaderSize();
			}
		);
	}
);

// Simple function that accepts two parameters and calculates
// the number of hours worked within that range
function workingHoursBetweenDates(startDate, endDate, workHoursUpdate, isHoursPerDay) {  
    // Store minutes worked
    var hoursWorked = 0;

    // Validate input
    if (endDate < startDate) { return 0; }

    // Loop from your Start to End dates (by hour)
    var current = startDate;

    // Define work hours
    var workHours = 8;
	if (isHoursPerDay){
		workHours = parseFloat(workHoursUpdate);
	}
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

function substractDates(pStartDate, pEndDate){
	return Math.abs(pEndDate.getDate()-pStartDate.getDate())+1;
}

function getHoursRemaining(pDateFrom, pDateTo, pHoursAssign){
	var startDate = new Date(pDateFrom);
	var endDate = new Date(pDateTo);
	var totalHours = workingHoursBetweenDates(startDate, endDate, 0, false);
	return totalHours - pHoursAssign;
}

function getUnionNumberDays(pFirstDateTo, pSecondDateTo){
	if (pSecondDateTo < pFirstDateTo){
		return substractDates(pSecondDateTo, pFirstDateTo);
	} else if (pSecondDateTo == pFirstDateTo){
		return 1;
	}
	return 0;
}

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
}

function formatDate(valDate) {
  	var monthNames = [
	    "January", "February", "March",
	    "April", "May", "June", "July",
	    "August", "September", "October",
	    "November", "December"
	  ];
	
	var dateFrom = valDate.split("T");
	var from = dateFrom[0].split("-");
	var f = new Date(from[0], from[1] - 1, from[2]);

	var day = f.getDate();
	var monthIndex = f.getMonth();
	var year = f.getFullYear();
	
	return day + ' ' + monthNames[monthIndex] + ' ' + year;
}