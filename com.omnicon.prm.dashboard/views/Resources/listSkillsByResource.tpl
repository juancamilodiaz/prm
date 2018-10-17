<html>
<head>
	<script src="/static/js/chartjs/Chart.min.js" > </script>
<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#viewSkillsInResource').DataTable({		
			"iDisplayLength": 20,
			"bLengthChange": false,
			"lengthMenu": [[8, 16, 32, -1], [8, 16, 32, "All"]],
			"columns":[
				null,
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#titlePag').html("{{.Title}}");
		$('#backButton').css("display", "inline-block");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/resources',{});
		}); 
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/resources/skills',{
				"ID": {{.ResourceId}},
				"ResourceName": "{{.Title}}",
				"MapTypesResource" : JSON.stringify({{.MapTypesResource}})
			});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("href", "#resourceSkillModal");
		$('#buttonOption').attr("onclick","configureCreateModal();getSkills()");
		
		{{if not .Skills}}
			$('#chartjs-wrapper').css("display", "none");
		{{end}}	
	});
	
	configureUpdateSkillResourceModal = function(pSkillId, pName, pValue){
		$("#updateResourceSkillId").val(pSkillId);
		$("#updateResourceNameSkill").val(pName);
		$("#updateResourceValueSkill").val(pValue);
		$("#deleteResourceSkillId").val(pSkillId);
		
		$("#modalTitle").html("Update Skill to Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}
	
	configureDeleteSkillResourceModal = function(pSkillId){
		$("#deleteResourceSkillId").val(pSkillId);
		
		$("#modalTitle").html("Delete Skill to Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}

	
	setSkillToResource = function(resourceId, resourceName, value, mapTypesResource){
		var settings = {
			method: 'POST',
			url: '/resources/setskill',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ResourceId": resourceId,
				"SkillId": resourceName,
				"Value": value
			}
		}
		$.ajax(settings).done(function (response) {
		  reload('/resources/skills', {"ID": {{.ResourceId}},"ResourceName": {{.Title}}, "MapTypesResource" : JSON.stringify(mapTypesResource)});
		});
	}
	
	deleteSkillToResource = function(resourceId, skillId, mapTypesResource){
		var settings = {
			method: 'POST',
			url: '/resources/deleteskill',
			headers: {
				'Content-Type': undefined
			},
			data: {	  
				"ResourceId": resourceId,
				"SkillId": skillId
			}
		}
		$.ajax(settings).done(function (response) {
		  reload('/resources/skills', {"ID": {{.ResourceId}},"ResourceName": {{.Title}}, "MapTypesResource" : JSON.stringify(mapTypesResource)});
		});
	}
	
	getSkills = function(){
		var settings = {
			method: 'POST',
			url: '/skills',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Template": "select",				
			}
		}
		$.ajax(settings).done(function (response) {
		  $('#resourceNameSkill').html(response);
		  $('#resourceNameSkill').material_select();
		});
	}
	
	//donwload pdf from original canvas
	downloadPDF = function(index) {
		
	  var canvas = document.querySelector('#chartjs-'+ index);
		//creates image
		var canvasImg = canvas.toDataURL("image/jpg", 1.0);
	  
		//creates PDF from img
		var doc = new jsPDF('landscape', 'mm', 'letter');
		doc.setProperties({
			title: '{{.Title}}'
		});
		doc.setFontSize(20);
		doc.text("Summary {{.Title}}'s skills", 139.5, 20, 'center' );
		var listOfTypes = "";
		{{$title := .Title}};
		{{$listTypesName := .ListTypesName}}
		{{range $index, $type := $listTypesName}}
			{{if eq (index $listTypesName 0) $title}}
				{{if ne $title $type}}
					{{if eq $index 1}}
						listOfTypes += "{{$type}}"
					{{else}}
						listOfTypes += ", {{$type}}"
					{{end}}
				{{end}}
			{{else if ne $title $type}}
				{{if eq $index 0}}
					listOfTypes += "{{$type}}"
				{{else}}
					listOfTypes += ", {{$type}}"
				{{end}}
			{{end}}
		{{end}}
		doc.setFontSize(14);
		doc.text("Profiles: " + listOfTypes, 139.5, 30, 'center' );
		doc.addImage(canvasImg, 'JPEG', 99, 40, 100, 100);
		
		var columns = ["ID", "Name", "Value"];
		var rows = [
		{{range $key, $skill := .Skills}}
		    [{{$key}}, "{{$skill.Name}}", "{{$skill.Value}}"],
		{{end}}	
		];		
		
		doc.autoTable(columns, rows, {
			startY: 140
		});
		doc.save('datauristring')
		//$('#objectPdf').attr('data', doc.output('datauristring'));
		//$('#showDocument').modal('show');
	}
	
	var slideIndex = 1;
	showSlides(slideIndex);
	
	function plusSlides(n) {
	  showSlides(slideIndex += n);
	}
	
	function currentSlide(n) {
	  showSlides(slideIndex = n);
	}
	
	function showSlides(n) {
	  var i;
	  var slides = document.getElementsByClassName("mySlides");
	  var dots = document.getElementsByClassName("dot");
	  if (n > slides.length) {slideIndex = 1}    
	  if (n < 1) {slideIndex = slides.length}
	  for (i = 0; i < slides.length; i++) {
	      slides[i].style.display = "none";  
	  }
	  for (i = 0; i < dots.length; i++) {
	      dots[i].className = dots[i].className.replace(" active", "");
	  }
	  slides[slideIndex-1].style.display = "inline";  
	  dots[slideIndex-1].className += " active";
	}

</script>

<style>
* {box-sizing:border-box}
body {font-family: Verdana,sans-serif;margin:0}
.mySlides {display:none}

/* Next & previous buttons */
.prev-slide, .next-slide {
  cursor: pointer;
  position: absolute;
  top: 50%;
  width: auto;
  padding: 16px;
  margin-top: -22px;
  color: black;
  font-weight: bold;
  font-size: 18px;
  transition: 0.6s ease;
  border-radius: 0 3px 3px 0;
}

/* Position the "next button" to the right */
.next-slide {
  right: 0;
  border-radius: 3px 0 0 3px;
}

/* On hover, add a black background color with a little bit see-through */
.prev-slide:hover, .next-slide:hover {
  background-color: rgba(0,0,0,0.8);
  color: white;
}

/* Caption text */
.text {
  color: #f2f2f2;
  font-size: 15px;
  padding: 8px 12px;
  position: absolute;
  bottom: 8px;
  width: 100%;
  text-align: center;
}

/* Number text (1/3 etc) */
.numbertext {
  color: #f2f2f2;
  font-size: 12px;
  padding: 8px 12px;
  position: absolute;
  top: 0;
}

/* The dots/bullets/indicators */
.dot {
  cursor: pointer;
  height: 15px;
  width: 15px;
  margin: 0 2px;
  background-color: #bbb;
  border-radius: 50%;
  display: inline-block;
  transition: background-color 0.6s ease;
}


/* Fading animation */
.fade-slide {
  -webkit-animation-name: fade;
  -webkit-animation-duration: 1.5s;
  animation-name: fade;
  animation-duration: 1.5s;
}

@-webkit-keyframes fade-slide {
  from {opacity: .4} 
  to {opacity: 1}
}

@keyframes fade-slide {
  from {opacity: .4} 
  to {opacity: 1}
}

/* On smaller screens, decrease text size */
@media only screen and (max-width: 300px) {
  .prev-slide, .next-slide,.text {font-size: 11px}
}
</style>
</head>

<body>
<div class="container" style="padding:15px;">
	
	<div class="row">
		<div class="col s12   marginCard">
			<div id="pry_add">
				<h4 id="titlePag"></h4>
				<a id="backButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Back"  ><i class="mdi-navigation-arrow-back large"></i></a>
				<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>
				<a id="buttonOption" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Create Skill"><i class="mdi-action-note-add large"></i></a>
			</div>
		</div>
		<div class="col s12 m6">
		<table id="viewSkillsInResource" class="display" cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>Name</th>
					<th>Value</th>
					<th>Options</th>
				</tr>
			</thead>
			<tbody>
			 	{{range $key, $skill := .Skills}}
				<tr>
					<td>{{$skill.Name}}</td>
					<td>{{$skill.Value}}</td>
					<td>
						<!--<button class="buttonTable button2" data-toggle="modal" data-target="#updateResourceSkillModal" onclick="configureUpdateSkillResourceModal({{$skill.SkillId}},'{{$skill.Name}}',{{$skill.Value}})" data-dismiss="modal">Update</button>
						<button data-toggle="modal" data-target="#confirmDeleteSkillResourceModal" class="buttonTable button2" onclick="configureDeleteSkillResourceModal({{$skill.SkillId}});$('#nameDelete').html('{{$skill.Name}}');$('#skillID').val({{$skill.SkillId}});" data-dismiss="modal">Delete</button>-->
						<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Edit"  href="#updateResourceSkillModal"  onclick="configureUpdateSkillResourceModal({{$skill.SkillId}},'{{$skill.Name}}',{{$skill.Value}})" ><i class="mdi-editor-mode-edit"></i></a>
						<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Delete"  href='#confirmDeleteSkillResourceModal' onclick="configureDeleteSkillResourceModal({{$skill.SkillId}});$('#nameDelete').html('{{$skill.Name}}');$('#skillID').val({{$skill.SkillId}});"><i class="mdi-action-delete"></i></a>
				
					</td>
				</tr>
				{{end}}	
			</tbody>
		</table>
		</div>
		<div class="col s12 m6">
			<p>
			<div class="slideshow-container">
				{{$mapSkillsAndValues := .MapSkillsAndValues}}
				{{$listTypesName := .ListTypesName}}
				{{$listSkills := .ListSkills}}	
				{{$listValueSkills := .ListValues}}	
				{{$listColors := .ListColor}}
				{{$listColorsBkg := .ListColorBkg}}	
				{{range $indexTypes, $typesNames := $listTypesName}}
					{{if lt $indexTypes (minus (len $listTypesName) 1)}}
					<div class="mySlides fade-slide">
						<div class="chart-container" id="chartjs-wrapper">
							<canvas id="chartjs-{{$indexTypes}}" >
							</canvas>					
							<script>new Chart(document.getElementById("chartjs-{{$indexTypes}}"),
								{"type":"radar",
									"data": {			
										"labels": {{$listSkills}},
											"datasets":[
												{{range $index, $listValue := $listValueSkills}}
													{{if lt $index (minus (len $listValueSkills) 1)}}
														{{if eq $index $indexTypes}}										
														{"label":"{{index $listTypesName $indexTypes}}","data":{{$listValue}},"fill":true,"backgroundColor":"{{index $listColorsBkg $indexTypes}}","borderColor":"{{index $listColors $indexTypes}}","pointBackgroundColor":"{{index $listColors $indexTypes}}","pointBorderColor":"{{index $listColors $indexTypes}}","pointHoverBackgroundColor":"{{index $listColors $indexTypes}}","pointHoverBorderColor":"{{index $listColors $indexTypes}}"},								
														{{end}}
													{{end}}
												{{end}}
												{"label":"{{index $listTypesName (minus (len $listTypesName) 1)}}","data":{{index $listValueSkills (minus (len $listValueSkills) 1)}},"fill":true,"backgroundColor":"{{index $listColorsBkg (minus (len $listColorsBkg) 1)}}","borderColor":"{{index $listColors (minus (len $listColorsBkg) 1)}}","pointBackgroundColor":"{{index $listColors (minus (len $listColorsBkg) 1)}}","pointBorderColor":"{{index $listColors (minus (len $listColorsBkg) 1)}}","pointHoverBackgroundColor":"{{index $listColors (minus (len $listColorsBkg) 1)}}","pointHoverBorderColor":"{{index $listColors (minus (len $listColorsBkg) 1)}}"},								
											]
										},
									"options": {
										"elements": {
											"line":{"tension":0,"borderWidth":3}
										},
										"scale": {
											"display": true,
											"ticks": {
												"max": 100,
												"min": 0,
												"beginAtZero":true,
												"stepSize": 20	
											}				
										},
										legend: {
											display:true
										}
									}
								
								});
							</script>
						</div>
						<div class="row">
							<div class="col s5">
							</div>
							<div class="col s2">
								<a class='btn-floating btn-large waves-effect waves-light blue tooltipped' data-position="top" data-tooltip="Download PDF"  id="download-pdf" onclick="downloadPDF({{$indexTypes}})" ><i class="fas fa-file-pdf"></i></a>
							</div>
							<div class="col s5">
							</div>
						</div>
					</div>
					{{end}}
				{{end}}	
				<a class="prev-slide" onclick="plusSlides(-1)">&#10094;</a>
				<a class="next-slide" onclick="plusSlides(1)">&#10095;</a>
			</div>
			<div style="text-align:center">
				<div class="col-sm-5"></div>
				<div class="col-sm-2">
					{{range $index, $typeName := $listTypesName}}
						{{if lt $index (minus (len $listTypesName) 1)}}
						<span class="dot" onclick="currentSlide({{inc $index 1}})"></span> 
						{{end}}
					{{end}}
				</div>
				<div class="col s5"></div>
			</div>
			</p>
		</div>



<!-- Materialize Modal Update -->
	<div id="resourceSkillModal" class="modal " style = "overflow:visible" >
			<div class="modal-content">
				<h5 id="modalResourceSkillTitle" class="modal-title">Create Skill </h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="resourceIDSkills">
				<div class="input-field row">	
					<!-- Select -->
					<div class="input-field col s12 m5 l5">
						<label  class= "active">Skill Name</label>
						<select id="resourceNameSkill" ></select>	
					</div>
					<!-- Close Select -->
					<div class="col s12 m7 l7">
						<input id="resourceValueSkill" type="number"  min="1" max="100" value="1" class="validate">
						<label  for="resourceValueSkill"  class="active">Value</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<a id="addSkill" onclick="setSkillToResource({{.ResourceId}}, $('#resourceNameSkill').val(),$('#resourceValueSkill').val(), {{.MapTypesResource}})" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Set</a>
       		 	<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update -->

	

	<!-- Materialize Modal Update -->
	<div id="updateResourceSkillModal" class="modal " style = "overflow:visible" >
			<div class="modal-content">
				<h5 id="modalUpdateResourceSkillTitle" class="modal-title"> Update Skill </h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="updateResourceSkillId">
				<div class="input-field row">	
					<!-- input -->
					<div class="col s12 m7 l7">
						<input id="updateResourceNameSkill" type="text"  class="validate">
						<label  for="updateResourceNameSkill"  class="active">Skill Name</label>
					</div>
					<!-- Close Select -->
					<div class="col s12 m7 l5">
						<input id="updateResourceValueSkill" type="number"  min="1" max="100" value="1" class="validate">
						<label  for="updateResourceValueSkill"  class="active">Value</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<a id="addSkill" onclick="setSkillToResource({{.ResourceId}}, $('#updateResourceSkillId').val(), $('#updateResourceValueSkill').val(), {{.MapTypesResource}})" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Set</a>
       		 	<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update -->

<div id="confirmDeleteSkillResourceModal" class="modal" >
			<div class="modal-content">
				<h5  class="modal-title">Delete Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="deleteResourceSkillId">
				Are you sure you want to remove <b id="nameDelete"></b> from <b>{{.Title}}</b>?
			</div>
			<div class="modal-footer">
				<a onclick="deleteSkillToResource({{.ResourceId}}, $('#deleteResourceSkillId').val(), {{.MapTypesResource}})" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Yes</a>
        		<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">No</a>
			</div>
</div>



	<!-- Modal -->
	<div id="showDocument" class="modal fade" role="dialog">
	  <div class="modal-dialog" style="width: 95%;height: 90%;padding: 0;">
	
	    <!-- Modal content-->
	    <div class="modal-content" style="height: 100%;">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 class="modal-title">Preview Skills</h4>
	      </div>
	      <div class="modal-body" style="height: 80%">
			<object id="objectPdf" type="application/pdf" width="100%" height="100%">
			   
			</object>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	      </div>
	    </div>
	
	  </div>
	</div>
</div>
</div>
</body>