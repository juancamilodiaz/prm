<!DOCTYPE html>

<html>
<head>
	<title>PRM</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="shortcut icon" src="/static/img/favicon.ico">
  
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
			setTimeout(function(){ $("#errorMessage").hide(); }, 3000);
		}
	</script>
	
	
	<script>
		$(document).ready(function(){
			$("#errorMessage").hide();
			getResourcesByProjectToday();
			$('#datePicker').css("display", "inline-block");
			$('#NavRight').css("display", "none");
			
			$('#dateFrom').change(function(){
				$('#dateTo').val($("#dateFrom").val());
				$('#dateTo').attr("min", $("#dateFrom").val());
			});
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
		}
	</script>

</head>

<body>
	<div id="HeaderPlaceHolder">
		<div id="NavLeft"  class="NavItem">
			<!--div class="NavItem">
				<div class="dropdown">
					<button id="NavMenuButton" class="btn btn-primary btn-menu toggle" type="button"><span class="glyphicon glyphicon-th-list"></span></button>
				</div>
			</div-->
			<div class="NavItem">
			</div>
		</div>
		<div id="NavCenter" class="NavItem">
			<img src="/static/img/logo_omnicon_sa_blanco-01.svg" width="200" height="50">
		</div>
		<div id="NavRight" class="NavItem" style="padding-right: 3%;">
			<div id="login" class="NavItem">
				<label style="padding-right: inherit; padding-left: inherit;">User:</label><input type="text" id="LogUser" style="border-radius: 8px;padding: 0.5%;"><label style="padding-right: inherit; padding-left: inherit;">Password:</label> <input type="password" id="LogPassword" style="border-radius: 8px;padding: 0.5%;"> <button class="buttonTable button2" disabled>Login</button>
			</div>
		</div>
	</div>
	
	<div id="BodyPlaceHolder" ng-app="index" ng-controller='indexCtrl'>
		<div id="mySidenav" class="sidenav">
		  <a href="javascript:void(0)" class="closebtn" onclick="toNav()">&times;</a>
          <a onclick="toNav();sendTitle($(this).html());getResourcesByProjectToday();">Home</a>
		  <a ng-click="link('resources')" onclick="toNav();sendTitle($(this).html())">Resources</a>
		  <a ng-click="link('projects')" onclick="toNav();sendTitle($(this).html())">Projects</a>
		  <a ng-click="link('skills')" onclick="toNav();sendTitle($(this).html())">Skills</a>
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
	</div>
	<div id="mask" onclick="toNav()">
    
</div>
</body>
</html>
