<!DOCTYPE html>

<html>
<head>
	<!--link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:300,400,500,700" type="text/css"-->
	<title>PRM</title>
	<!--script src="https://code.getmdl.io/1.3.0/material.min.js"></script-->
    
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="shortcut icon" src="/static/img/favicon.ico">
	<link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">
  
	<script src="/static/js/JQuery/jquery.js"></script>
	<script src="/static/js/DataTables/datatables.min.js"></script>
	<script src="/static/js/DataTables/DataTables-1.10.16/js/dataTables.bootstrap4.min.js"></script>
	<script src="/static/js/DataTables/DataTables-1.10.16/js/jquery.dataTables.min.js"></script>
	<script src="/static/js/JQueryUI/jquery-ui.min.js"></script>
	<script src="/static/js/Bootstrap/js/popper.min.js"></script>
	<script src="/static/js/Bootstrap/js/bootstrap.min.js"></script>
	<script src="/static/js/moment-with-locales.js"></script>
	<script src="/static/js/Angular/angular.min.js"></script>
	<script src="/static/js/Angular/angular-sanitize.js"></script>
	<script src="/static/js/Utils.js"></script>
	<script src="/static/js/functions.js"></script>
	<script src="/static/js/palette/palette.js"></script>
	<!--script src="/static/js/jquery.jeditable.js"></script>
	<script src="/static/js/jquery.jeditable.mini.js"></script-->
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.5/jspdf.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/2.3.2/jspdf.plugin.autotable.js"></script>	
	
	<script src="/static/js/code.getmdl.io/1.0.2/material.min.js"></script>
	<!--script src="/static/js/kybarg/mdl-selectfield/mdl-menu-implementation/mdl-selectfield.min.js"></script-->
	<script src="/static/js/getmdl-select/getmdl-select.js"></script>
	
	<!---->
	<!--link rel="stylesheet" href="//fonts.googleapis.com/icon?family=Material+Icons"-->
	<!--link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css"-->
	<link rel="stylesheet" type="text/css" href="/static/css/code.getmdl.io/1.0.2/material.teal-red.min.css" />
	<!--link rel="stylesheet" href="https://cdn.rawgit.com/kybarg/mdl-selectfield/mdl-menu-implementation/mdl-selectfield.min.css" /-->
	<link rel="stylesheet" type="text/css" href="/static/css/getmdl-select/getmdl-select.min.css" />
	<!--link rel="stylesheet" href="https://code.getmdl.io/1.0.2/material.indigo-pink.min.css" /-->
	<!--script src="//storage.googleapis.com/code.getmdl.io/1.0.1/material.min.js"></script-->
	<!---->
	<link rel="stylesheet" type="text/css" href="/static/css/JQueryUI/jquery-ui.min.css">
	
	<link rel="stylesheet" type="text/css" href="/static/js/DataTables/DataTables-1.10.16/css/jquery.dataTables.min.css">
	
	<link rel="stylesheet" type="text/css" href="/static/js/DataTables/DataTables-1.10.16/css/dataTables.bootstrap4.min.css">
	<link rel="stylesheet" type="text/css" href="/static/js/Bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/static/js/Bootstrap/css/bootstrap-theme.min.css">
	<link rel="stylesheet" type="text/css" href="/static/css/font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/static/css/Site.css">
	
	<link rel="stylesheet" type="text/css" href="/static/css/Custom/custom.css">
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
			   // document.getElementById("sidebar").style.marginLeft= "0";
				$("#mask").css("display","none");
			} else {
				document.getElementById("mySidenav").style.width = "250px";
			    //document.getElementById("sidebar").style.marginLeft = "250px";
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
			  $('.modal-backdrop').remove();
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
			$('#backButton').css("display", "none");
			
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
		
		getTypes = function() {
			var settings = {
				method: 'POST',
			url: '/types',
			headers: {
				'Content-Type': undefined
			},		
		  	data : { 
					"Template": "types"
				}
			}
			$.ajax(settings).done(function (response) {
			  $('#content').html(response);		
			  $('.modal-backdrop').remove();
			});
		}
	</script>

</head>

<body>
	<div id="HeaderPlaceHolder">
		<div id="NavLeft" class="NavItem col-sm-2">
			<a href="http://www.omnicon.cc/" target="_blank"> 
				<img src="/static/img/logo_omnicon_sa_blanco-01.svg" style="cursor: pointer;height: 100%;">
			</a>
			<!--div class="NavItem">
				<div class="dropdown">
					<button id="NavMenuButton" class="btn btn-primary btn-menu toggle" type="button"><span class="glyphicon glyphicon-th-list"></span></button>
				</div>
			</div-->
		</div>
		<div id="NavCenter" class="NavItem col-sm-8">
			<img src="/static/img/PRM-LOGO-BETA.svg" onclick="getResourcesByProjectToday();" style="cursor: pointer;height:100%;">
		</div>
		<div id="NavRight" class="NavItem col-sm-2" style="padding-right: 3%;padding-top: 20px;text-align: right;">
			<a id="exit_session" class="mdl-js-button mdl-js-ripple-effect" style="color: white;" itemprop="url" href='{{urlfor "LoginController.Logout"}}'>
               <i class="material-icons">exit_to_app</i>
			</a>
			<div class="mdl-tooltip mdl-tooltip--large" for="exit_session">
				Sign out your session
			</div>
		</div>
	</div>
	
	
	
	<div id="BodyPlaceHolder" ng-app="index" ng-controller='indexCtrl'>
			
		<!--- <div id="mySidenav" class="sidenav">
		  <a href="javascript:void(0)" class="closebtn" onclick="toNav()">&times;</a>
          <a onclick="toNav();sendTitle($(this).html());getResourcesByProjectToday();">Home</a>
		  <a ng-click="link('projectsForecast')" onclick="toNav();sendTitle($(this).html());" style="width: 250px;">Forecast Projects</a>
		  <a class="accordion">Manage</a>
			<div class="panel-accordion">
				<a ng-click="link('projects')" onclick="toNav();sendTitle($(this).html())">Projects</a>
				<a ng-click="link('resources')" onclick="toNav();sendTitle($(this).html())">Resources</a>
				<a ng-click="link('skills')" onclick="toNav();sendTitle($(this).html())">Skills</a>
				<a ng-click="link('types')" onclick="toNav();sendTitle($(this).html())">Types</a>
				<a ng-click="link('trainings')" onclick="toNav();sendTitle($(this).html())">Trainings</a>
			</div>		
		  <a  onclick="toNav();getTypes();">Simulator</a>
		  <a  ng-click="link('reports')" onclick="toNav();sendTitle($(this).html())">Reports</a>
		  <a  ng-click="link('dashboard')" onclick="toNav();sendTitle($(this).html())">Status</a>
		  <a  ng-click="link('trainings/resources')" onclick="toNav();sendTitle($(this).html())">Trainings</a>
		  <a  ng-click="link('productivity')" onclick="toNav();sendTitle($(this).html())">Productivity Report</a>
		  <a  ng-click="link('settings')" onclick="toNav();sendTitle($(this).html())">Settings</a>
		  <!- a  ng-click="link('about')" onclick="toNav();sendTitle($(this).html())">About</a
		</div> --->
		<!--- BootstrapSidenav -->
		<div id="sidebar">
			<span style="font-size:30px;cursor:pointer" onclick="toNav()">&#9776;</span>
		</div> 
		<div class="nav-side-menu" id="mySidenav">
			
		    <i class="fa fa-bars fa-2x toggle-btn" data-toggle="collapse" data-target="#menu-content"></i>
		  
		        <div class="menu-list">
		  
		            <ul id="menu-content" class="menu-content collapse out">
		                <li>
		                  <a onclick="toNav();sendTitle($(this).html());getResourcesByProjectToday();">
		                  <i class="fa fa-home fa-lg"></i> Home
		                  </a>
		                </li>
						
						<li>
		                  <a ng-click="link('projectsForecast')" onclick="toNav();sendTitle($(this).html());">
		                  <i class="fa fa-line-chart fa-lg"></i> Forecast Projects
		                  </a>
		                </li>		
		
		                <li data-toggle="collapse" data-target="#manage" class="collapsed">
		                  <a href="#"><i class="fa fa-cog fa-lg"></i> Manage <span class="arrow"></span></a>
		                </li>  
		                <ul class="sub-menu collapse" id="manage">
		                  <li>
							<a ng-click="link('projects')" onclick="toNav();sendTitle($(this).html())">Projects</a>
						  </li>
		                  <li><a ng-click="link('resources')" onclick="toNav();sendTitle($(this).html())">Resources</a></li>
		                  <li><a ng-click="link('skills')" onclick="toNav();sendTitle($(this).html())">Skills</a></li>
						  <li><a ng-click="link('types')" onclick="toNav();sendTitle($(this).html())">Types</a></li>
		                  <li><a ng-click="link('trainings')" onclick="toNav();sendTitle($(this).html())">Trainings</a></li>
		                </ul>
						
						<li>
		                  <a onclick="toNav();getTypes();">
		                  <i class="fa fa-rocket fa-lg"></i> Simulator
		                  </a>
		                </li>
		
						<li>
		                  <a ng-click="link('reports')" onclick="toNav();sendTitle($(this).html())">
		                  <i class="fa fa-file-text fa-lg"></i> Reports
		                  </a>
		                </li>
						
						<li>
		                  <a ng-click="link('dashboard')" onclick="toNav();sendTitle($(this).html())">
		                  <i class="fa fa-check-circle fa-lg"></i> Status
		                  </a>
		                </li>
						
						<li>
		                  <a ng-click="link('trainings/resources')" onclick="toNav();sendTitle($(this).html())">
		                  <i class="fa fa-graduation-cap fa-lg"></i> Trainings
		                  </a>
		                </li>
						
						<li>
		                  <a ng-click="link('productivity')" onclick="toNav();sendTitle($(this).html())">
		                  <i class="fa fa-bar-chart fa-lg"></i> Productivity Report
		                  </a>
		                </li>
						
						<li>
		                  <a  ng-click="link('settings')" onclick="toNav();sendTitle($(this).html())">
		                  <i class="fa fa-cogs fa-lg"></i> Settings
		                  </a>
		                </li>
		     </div>
		</div>
		
		<!--- /BootstrapSidenav ---> 
		
		<div class="content container-fluid">
			<h1><!--form action="#">		
			<div class="mdl-selectfield mdl-js-selectfield mdl-selectfield--floating-label">
				<select  id="leaderID" class="mdl-selectfield__select">
					<option value="0"></option>
					<option value="1">yo</option>
				</select>
			  <label class="mdl-selectfield__label" for="leaderID">Leader...</label>
			</div>
		</form-->
				<div id="titlePag">Home</div>
				<button id="backButton" class="mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--blue" style="display: none;">
					<i id="backButtonIcon" class="material-icons"></i>
				</button>	
				<div id="backButtonTooltip" class="mdl-tooltip mdl-tooltip--large" for="backButton">
				</div>				
				<button id="refreshButton" class="mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--blue" style="display: inline-block;">
					<i class="material-icons">refresh</i>
					<!--img src="/static/img/progress-arrows.png"-->
				</button>
				<div class="mdl-tooltip mdl-tooltip--large" for="refreshButton">
					Refresh data
				</div>				
				
				<div id="datePicker" class="pull-right" style="padding-right: 0%;">
					<h5>
						<!--label class="mdl-textfield__label" for="dateFrom">Start Date:</label-->
						<input class="mdl-textfield__input" id=dateFrom type=date style="inline-size: 35%;">
						<!--label class="mdl-textfield__label" for="dateTo">End Date:</label-->
						<input class="mdl-textfield__input" id=dateTo type=date style="inline-size: 35%;">
						<button id="filterByDateRange" class="mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--blue">
							<i class="material-icons">search</i>
						</button>
						<div class="mdl-tooltip mdl-tooltip--large" for="filterByDateRange">
							Filter by date range	
						</div>		
					</h5>
				</div>
				
				<button id="buttonOption" class="mdl-button mdl-js-button mdl-button--fab mdl-js-ripple-effect mdl-button--blue" style="display: none;">
					<i id="buttonOptionIcon" class="material-icons"></i>
				</button>
				<div id="buttonOptionTooltip" class="mdl-tooltip mdl-tooltip--large" for="buttonOption">
				</div>
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
	
	<div id ="FooterPlaceHolder">
		<div id="NavCenter" class="NavItem col-sm-12" style="text-align: center;">
			<img src="/static/img/PRM_WORD.svg" style="width: 100%;max-height: 100%;"/>
		</div>
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
