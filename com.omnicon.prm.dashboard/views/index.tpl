<!DOCTYPE html>

<html>
<head>
	<title>PRM</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="shortcut icon" src="/static/img/favicon.ico">
	<link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">
  
	<script src="/static/js/JQuery/jquery.js"></script>
	<script src="/static/js/DataTables/datatables.min.js"></script>
	<script src="/static/js/DataTables/DataTables-1.10.15/js/dataTables.bootstrap.min.js"></script>
	<script src="/static/js/JQueryUI/jquery-ui.min.js"></script>
	<script src="/static/js/Bootstrap/js/popper.min.js"></script>
	<script src="/static/js/Bootstrap/js/bootstrap.min.js"></script>
	<script src="/static/js/moment-with-locales.js"></script>
	<script src="/static/js/Angular/angular.min.js"></script>
	<script src="/static/js/Angular/angular-sanitize.js"></script>
	<script src="/static/js/Utils.js"></script>
	<script src="/static/js/functions.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/static/css/JQueryUI/jquery-ui.min.css">
	
	<link rel="stylesheet" type="text/css" href="/static/js/DataTables/DataTables-1.10.15/css/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/static/js/Bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/static/js/Bootstrap/css/bootstrap-theme.min.css">
	<link rel="stylesheet" type="text/css" href="/static/css/font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/static/css/Site.css">

	<script>
		var app = angular.module('index', ['ngSanitize']);
		
		app.controller('indexCtrl', function($scope, $http, $compile){
			$scope.link = function(url){
				$("#content").html("<div>"+$("#imgLoading").html()+"</div>");
				data="";
				$http.post(url)
			    .then(function(response) {
					data=response.data;
					$("#content").html(data);
			    });				
			}		    
		});
		
		app.config(['$qProvider', function ($qProvider) {
		    $qProvider.errorOnUnhandledRejections(false);
		}]);	
	</script>
	<script>
		function toNav() {
			if (document.getElementById("mySidenav").style.width == '250px') {
				document.getElementById("mySidenav").style.width = "0";
			    document.getElementById("sidebar").style.marginLeft= "0";
				$("#mask").css("display","none");
			} else {
				document.getElementById("mySidenav").style.width = "250px";
			    document.getElementById("sidebar").style.marginLeft = "250px";
				$("#mask").css("display","block");
			}
		}
		
		function sendTitle(sectionName){
			$('#titlePag').html(sectionName)
		}
		
		reload = function(pPath, pData){
			var settings = {
				method: 'POST',
				url: pPath,
				headers: {
					'Content-Type': undefined
				},
				data: pData
			}
			$.ajax(settings).done(function (response) {
			  $("#content").html(response);
			});
		}
		
		validationError = function(response){
			$("#errorMessage").html(response);
		  	$("#errorMessage").show();
			setTimeout(function(){ $("#errorMessage").hide(); }, 10000);
		}
	</script>
	<script>
		$(document).ready(function(){
			$("#errorMessage").hide();
			getResourcesByProjectToday();
			$('#datePicker').css("display", "inline-block");
			$('#NavRight').css("display", "inline-block");
			$('#buttonOption').css("display", "none");
			
			$('#dateFrom').change(function(){
				$('#dateTo').attr("min", $("#dateFrom").val());
			});
			
			$('#projectID').val(null);
			$('#projectName').val(null);
			$('#projectStartDate').val(null);
			$('#projectEndDate').val(null);
			$('#projectActive').prop('checked', false);	
			$('#projectTypeSimulator').val(null);
		});
		
		getResourcesByProjectToday = function(){
			var time = new Date();
			var mm = time.getMonth() + 1; // getMonth() is zero-based
			var dd = time.getDate();
	        var date =  [time.getFullYear(),
		          (mm>9 ? '' : '0') + mm,
		          (dd>9 ? '' : '0') + dd
		         ].join('-');
		  	data = { 
					"StartDate": date,
					"EndDate": date
				}
			reload('/projects/resources/today', data);
			$('#dateFrom').val(date)
			$('#dateTo').val(date)
			$('#buttonOption').css("display", "none");
		}
		
		getResourcesByProjectAvail = function(){
			dateFrom = $('#projectStartDate').val();
			dateTo = $('#projectEndDate').val();
			var values = "";
			for (i =0; i<$('#projectTypeSimulator').val().length; i++){
				if (values != ""){
					values = values + ",";
				}	
				values = values + $('#projectTypeSimulator').val()[i];
			}

			var settings = {
				method: 'POST',
			url: '/projects/recommendation',
			headers: {
				'Content-Type': undefined
			},
		  	data : { 
		
					"StartDate": dateFrom,
					"EndDate": dateTo,
					"Types": values,
				}
			}
			$.ajax(settings).done(function (response) {
			  $("#content").html(response);		
			});
		}
		
		getTypes = function(){
			var settings = {
				method: 'POST',
			url: '/types',
			headers: {
				'Content-Type': undefined
			},		
		  	data : { 
					"Template": "types",
				}
			}
			$.ajax(settings).done(function (response) {
			  $('#projectTypeSimulator').html(response);		
			});
		}
		
		configureSimulatorModal = function(){		
			$("#projectID").val(null);
			$("#projectName").val(null);
			$("#projectStartDate").val(null);
			$("#projectEndDate").val(null);
			$("#projectActive").prop('checked', false);	
		}
	</script>

</head>

<body>
	<div id="HeaderPlaceHolder">
		<div id="NavLeft"  class="NavItem">
			<img src="/static/img/logo_omnicon_sa_blanco-01.svg" onclick="getResourcesByProjectToday();" width="200" height="50" style="cursor: pointer;">
			<!--div class="NavItem">
				<div class="dropdown">
					<button id="NavMenuButton" class="btn btn-primary btn-menu toggle" type="button"><span class="glyphicon glyphicon-th-list"></span></button>
				</div>
			</div-->
			<div class="NavItem">
			</div>
		</div>
		<div id="NavCenter" class="NavItem">
			<h1 class="title" style="padding-left: 170px;">Project Resource Management</h1>
		</div>
		<div id="NavRight" class="NavItem" style="padding-right: 3%;padding-top: 1%;">
			<a style="color: white;" itemprop="url" href='{{urlfor "LoginController.Logout"}}'>
                 <span class='glyphicon glyphicon-log-out'></span> Sign out
			</a>
		</div>
	</div>
	
	
	
	<div id="BodyPlaceHolder" ng-app="index" ng-controller='indexCtrl'>
			
		<div id="mySidenav" class="sidenav">
		  <a href="javascript:void(0)" class="closebtn" onclick="toNav()">&times;</a>
          <a onclick="toNav();sendTitle($(this).html());getResourcesByProjectToday();">Home</a>
		  <a class="accordion">Manage</a>
			<div class="panel-accordion">
				<a ng-click="link('resources')" onclick="toNav();sendTitle($(this).html())">Resources</a>
				<a ng-click="link('projects')" onclick="toNav();sendTitle($(this).html())">Projects</a>
				<a ng-click="link('skills')" onclick="toNav();sendTitle($(this).html())">Skills</a>
				<a ng-click="link('types')" onclick="toNav();sendTitle($(this).html())">Types</a>
			</div>		
		  <a  data-toggle="modal" data-target="#simulatorModal" onclick="toNav();configureSimulatorModal();getTypes();">Simulator</a>
		  <a  ng-click="link('about')" onclick="toNav();sendTitle($(this).html())">About</a>
		</div>
		<div id="sidebar">
			<span style="font-size:30px;cursor:pointer" onclick="toNav()">&#9776;</span>
		</div>
		<div class="content container-fluid">
			<h1>
				<div id="titlePag">Home</div>
				<button id="backButton" class="button button2" style="display: none;"></button>				
				<button id="refreshButton" class="buttonImg button2" style="display: inline-block;">
					<img src="/static/img/progress-arrows.png">
				</button>				
				
				<div id="datePicker" class="pull-right" style="padding-right: 0%;">
					<h5>
						<label for="dateFrom">Start Date:</label>
						<input id=dateFrom type=date style="border-radius:8px;inline-size: 24%;">
						<label for="dateTo">End Date:</label>
						<input id=dateTo type=date style="border-radius:8px;inline-size: 24%;">
						<button id="filterByDateRange" class="buttonHeader button2">Filter</button>
					</h5>
				</div>
				
				<button id="buttonOption" class="button button2" style="display: none;"></button>
			</h1>
			<div id="errorMessage">
			</div>
			<div  id="content" ng-bind-html="content">
			</div>
		</div>
		<div id="ImagesHidden">
			<div id="imgLoading"><img  class=".img-responsive" style="max-width: 200px; top: 0; right: 0; left: 0; bottom: 0; position: absolute; margin: auto;" src="/static/img/loading.gif"></div>
		</div>
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="simulatorModal" role="dialog">
	  <div class="modal-dialog">
	    <!-- Modal content-->
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 id="modalSimulatorTitle" class="modal-title">Simulator</h4>
	      </div>
	      <div class="modal-body">
	        <input type="hidden" id="projectID">
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
	              <div class="col-sm-8">
	              	<input type="text" id="projectName" style="border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
	              <div class="col-sm-8">
	              	<input type="date" id="projectStartDate" style="inline-size: 174px; border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
	              <div class="col-sm-8">
	              	<input type="date" id="projectEndDate" style="inline-size: 174px; border-radius: 8px;">
	        		</div>
	          </div>
	        </div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div id="divProjectType" class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Types"> Types </label> 
	             	<div class="col-sm-8">
		             	<select  id="projectTypeSimulator" multiple style="width: 174px; border-radius: 8px;">
						</select>
	              	</div>    
	          	</div>
	        </div>
	        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
	        	<div class="form-group form-group-sm">
	        		<label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
	              <div class="col-sm-8">
	              	<input type="checkbox" id="projectActive"><br/>
	              </div>    
	          </div>
	        </div>
	      </div>
	      <div class="modal-footer">
	        <button type="button" id="btnSimulate" class="btn btn-default" ng-click="link('/projects/recommendation')" onclick="getResourcesByProjectAvail();sendTitle($('#projectName').val());" data-dismiss="modal">Simulate</button>
	        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="configureCreateModal();">Cancel</button>
	      </div>
	    </div>
	    
	  </div>
	</div>
	
	<div id ="FooterPlaceHolder">
	</div>
	<div id="mask" onclick="toNav()">
    
	
</div>

	<script>
		var acc = document.getElementsByClassName("accordion");
		var i;
		
		for (i = 0; i < acc.length; i++) {
		  acc[i].onclick = function() {
		    this.classList.toggle("active");
		    var panel = this.nextElementSibling;
		    if (panel.style.maxHeight){
		      panel.style.maxHeight = null;
		    } else {
		      panel.style.maxHeight = panel.scrollHeight + "px";
		    } 
		  }
		}
	</script>
</body>
</html>
