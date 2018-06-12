<html>
<head>
	<script src="/static/js/chartjs/Chart.min.js" > </script>


<script>
	getSkillsDropDown = function(){
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
		  $('#resourceNameSkillList').html(response);
		});
	}
	
	$(document).ready(function(){
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		$('#viewSkillsInResource').DataTable({
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
		$('#backButtonIcon').html("arrow_back");
		$('#backButtonTooltip').html("Back to resources");
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
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new skill to resource");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#resourceSkillModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
				
		var dialogConfirm = document.querySelector('#confirmDeleteSkillResourceModal');
		dialogConfirm.querySelector('#cancelConfirmButton')
		    .addEventListener('click', function() {
		      dialogConfirm.close();	
    	});
		
		var dialogConfirmCreate = document.querySelector('#resourceSkillModal');
		dialogConfirmCreate.querySelector('#cancelDialogButton')
		    .addEventListener('click', function() {
		      dialogConfirmCreate.close();	
    	});
		
		var dialogConfirmUpdate = document.querySelector('#updateResourceSkillModal');
		dialogConfirmUpdate.querySelector('#cancelDialogButton')
		    .addEventListener('click', function() {
		      dialogConfirmUpdate.close();	
    	});
		
		var dialogPDF = document.querySelector('#showDocument');
		dialogPDF.querySelector('#cancelPDFButton')
		    .addEventListener('click', function() {
		      dialogPDF.close();	
    	});
		
		{{if not .Skills}}
			$('#chartjs-wrapper').css("display", "none");
		{{end}}	
		getSkillsDropDown();
	});;	
	
	
	
	configureCreateModal = function(){
		
		$("#modalResourceSkillTitle").html("Create Skill to Resource");
		$("#resourceSkillCreate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		getmdlSelect.init(".getmdl-select");
		$('.mdl-textfield>input').each(function(param){if($(this).val() != ""){$(this).parent().addClass('is-dirty');$(this).parent().removeClass('is-invalid')}})
		
		var dialog = document.querySelector('#resourceSkillModal');
		dialog.showModal();
	}
	
	configureUpdateSkillResourceModal = function(pSkillId, pName, pValue){
		$("#updateResourceSkillId").val(pSkillId);
		$("#updateResourceNameSkill").val(pName);
		$("#updateResourceValueSkill").val(pValue);
		
		$("#modalUpdateResourceSkillTitle").html("Update Skill to Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
		
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-textfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-switch'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-checkbox'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-selectfield'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-tooltip'));
		componentHandler.upgradeElements(document.getElementsByClassName('mdl-dialog'));
		$('.mdl-textfield>input').each(function(param){if($(this).val() != ""){$(this).parent().addClass('is-dirty');$(this).parent().removeClass('is-invalid')}})
		
		var dialog = document.querySelector('#updateResourceSkillModal');
		dialog.showModal();
	}
	
	configureDeleteSkillResourceModal = function(pSkillId, pSkillName){
		$("#deleteResourceSkillId").val(pSkillId);
		$("#nameDelete").html(pSkillName);
		$("#skillID").val(pSkillId);
		
		$("#modalTitle").html("Delete Skill to Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
		
		var dialog = document.querySelector('#confirmDeleteSkillResourceModal');
		dialog.showModal();
	}

	
	setSkillToResource = function(resourceId, resourceName, value, mapTypesResource, isUpdate){
		var skillId;
		
		var isFormValid = false;
		if (isUpdate){
			skillId = resourceName
			if (document.getElementById("formUpdate").checkValidity()) {
				isFormValid = true;
			} 
		} else {
			$('#resourceNameSkillList').children().each(
			function(param){
				if(this.classList.length >1 && this.classList[1] == "selected"){
					skillId = this.getAttribute("data-val");
				}
			});
			if(document.getElementById("formCreate").checkValidity()) {
				isFormValid = true;
			}
		}
		if (isFormValid){
			var settings = {
				method: 'POST',
				url: '/resources/setskill',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					"ResourceId": resourceId,
					"SkillId": skillId,
					"Value": value
				}
			}
			$.ajax(settings).done(function (response) {
			  reload('/resources/skills', {"ID": {{.ResourceId}},"ResourceName": {{.Title}}, "MapTypesResource" : JSON.stringify(mapTypesResource)});
			});
		}		
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
		
		$('#objectPdf').attr('data', doc.output('datauristring'));
		var dialogPDF = document.querySelector('#showDocument');
		dialogPDF.showModal();
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

/* Slideshow container */
.slideshow-container {
  max-width: 1000px;
  position: relative;
  margin: auto;
}

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

.active, .dot:hover {
  background-color: #717171;
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
<div class="col-sm-12">
	<div class="col-sm-6">
		<table id="viewSkillsInResource" class="mdl-data-table mdl-js-data-table mdl-data-table--selectable mdl-shadow--2dp">
			<thead>
				<tr>
					<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Name</th>
					<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Value</th>
					<th class="mdl-data-table__cell--non-numeric" style="text-align:center;">Options</th>
				</tr>
			</thead>
			<tbody>
			 	{{range $key, $skill := .Skills}}
				<tr>
					<td class="mdl-data-table__cell--non-numeric" style="text-align:center;">{{$skill.Name}}</td>
					<td class="mdl-data-table__cell--non-numeric" style="text-align:center;">{{$skill.Value}}</td>
					<td class="mdl-data-table__cell--non-numeric" style="text-align:center;">
						<button id="editButton{{$skill.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="configureUpdateSkillResourceModal({{$skill.SkillId}},'{{$skill.Name}}',{{$skill.Value}})">
							<i class="material-icons" style="vertical-align: inherit;">mode_edit</i>
						</button>
						<div class="mdl-tooltip" for="editButton{{$skill.ID}}">
							Edit skill	
						</div>	
						<button id="deleteButton{{$skill.ID}}" class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" onclick="configureDeleteSkillResourceModal({{$skill.SkillId}}, '{{$skill.Name}}');">
							<i class="material-icons" style="vertical-align: inherit;">delete</i>
						</button>
						<div class="mdl-tooltip" for="deleteButton{{$skill.ID}}">
							Delete skill	
						</div>
					</td>
				</tr>
				{{end}}	
			</tbody>
		</table>
	</div>
	<div class="col-sm-6">
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
				        <div class="col-sm-5">
				        </div>
				        <div class="col-sm-2">
							<button class="mdl-button mdl-js-button mdl-js-ripple-effect mdl-button--blue" id="download-pdf" onclick="downloadPDF({{$indexTypes}})" >
								<i class="material-icons" style="vertical-align: inherit;">file_download</i>
							</button>
							<div class="mdl-tooltip" for="download-pdf">
								Download PDF	
							</div>	
				        </div>
				        <div class="col-sm-5">
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
			<div class="col-sm-5"></div>
		</div>
		</p>
	</div>
</div>
<!-- Modal -->
	<dialog class="mdl-dialog" id="resourceSkillModal">
		<h4 id="modalResourceSkillTitle" class="mdl-dialog__title"></h4>
		<form id="formCreate" action="#">
			<div class="mdl-dialog__content">	
				<input type="hidden" id="resourceIDSkills">	
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label getmdl-select">
			        <input type="text" value="" class="mdl-textfield__input" id="resourceNameSkill" readonly>
			        <input type="hidden" value="" name="resourceNameSkill" required>
			        <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
			        <label for="resourceNameSkill" class="mdl-textfield__label">Skill Name...</label>
			        <ul id="resourceNameSkillList" for="resourceNameSkill" class="mdl-menu mdl-menu--bottom-left mdl-js-menu">
			        </ul>
			    </div>	
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
					<input class="mdl-textfield__input" type="text" pattern="(100|([1-9][0-9])|[0-9])" id="resourceValueSkill" required>
					<label class="mdl-textfield__label" for="resourceValueSkill">Value...</label>
					<span class="mdl-textfield__error">Input is not a number or exceed the limit!</span>
				</div>				
			</div>
			<div class="mdl-dialog__actions">
				<button type="button" id="resourceSkillCreate" class="mdl-button" onclick="setSkillToResource({{.ResourceId}}, $('#resourceIDSkills').val(),$('#resourceValueSkill').val(), {{.MapTypesResource}}, false)">Set</button>
		      	<button type="button" id="cancelDialogButton" class="mdl-button close" data-dismiss="modal">Cancel</button>
		    </div>  
		</form>
	</dialog>
	<!-- Modal -->
	<dialog class="mdl-dialog" id="updateResourceSkillModal">
		<h4 id="modalUpdateResourceSkillTitle" class="mdl-dialog__title"></h4>
		<form id="formUpdate" action="#">
			<div class="mdl-dialog__content">			
			    <input type="hidden" id="updateResourceSkillId">
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
				  <input class="mdl-textfield__input" type="text" id="updateResourceNameSkill" required disabled>
				  <label class="mdl-textfield__label" for="updateResourceNameSkill">Skill Name...</label>
				</div>		
				<div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
					<input class="mdl-textfield__input" type="text" pattern="(100|([1-9][0-9])|[0-9])" id="updateResourceValueSkill" required>
					<label class="mdl-textfield__label" for="updateResourceValueSkill">Value...</label>
					<span class="mdl-textfield__error">Input is not a number or exceed the limit!</span>
				</div>				
			</div>
			<div class="mdl-dialog__actions">
				<button type="button" id="updateResourceSkill" class="mdl-button" onclick="setSkillToResource({{.ResourceId}}, $('#updateResourceSkillId').val(), $('#updateResourceValueSkill').val(), {{.MapTypesResource}}, true)">Set</button>
		      	<button type="button" id="cancelDialogButton" class="mdl-button close" data-dismiss="modal">Cancel</button>
		    </div>  
		</form> 
	</dialog>
	<dialog class="mdl-dialog" id="confirmDeleteSkillResourceModal">
		<h4 class="mdl-dialog__title">Delete Confirmation</h4>
		<div class="mdl-dialog__content">
			<input type="hidden" id="deleteResourceSkillId">
		    Are you sure you want to remove <b id="nameDelete"></b> from <b>{{.Title}}</b>?
		</div>
		<div class="mdl-dialog__actions">
			<button type="button" id="resourceSkillDelete" class="mdl-button" onclick="deleteSkillToResource({{.ResourceId}}, $('#deleteResourceSkillId').val(), {{.MapTypesResource}})" data-dismiss="modal">Yes</button>
		    <button id="cancelConfirmButton" type="button" class="mdl-button close" data-dismiss="modal">No</button>
	    </div> 
	</dialog>
	<!-- Modal -->
	<dialog class="mdl-dialog" id="showDocument" style="width: 95%;height: 90%;">
		<h4 class="mdl-dialog__title">Preview Skills</h4>
	    <!-- Modal content-->
		<div class="mdl-dialog__content" style="height: 85%">
			<object id="objectPdf" type="application/pdf" width="100%" height="100%">			   
			</object>
	    </div>
		<div class="mdl-dialog__actions">
			<button id="cancelPDFButton" type="button" class="mdl-button close" data-dismiss="modal">Close</button>
	    </div>
	</dialog>
</body>