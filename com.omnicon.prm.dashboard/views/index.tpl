<!DOCTYPE html>

<html>
<head>
	<title>PRM</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  
	<script src="/js/JQuery/jquery.js"></script>
	<script src="/js/DataTables/datatables.min.js"></script>
	<script src="/js/DataTables/DataTables-1.10.15/js/dataTables.bootstrap.min.js"></script>
	<script src="/js/JQueryUI/jquery-ui.min.js"></script>
	<script src="/js/Bootstrap/js/popper.min.js"></script>
	<script src="/js/Bootstrap/js/bootstrap.min.js"></script>
	<script src="/js/moment-with-locales.js"></script>
	<script src="/js/Angular/angular.min.js"></script>
	<script src="/js/Angular/angular-sanitize.js"></script>
	<script src="/js/Utils.js"></script>
	
	<link rel="stylesheet" type="text/css" href="/css/JQueryUI/jquery-ui.min.css">
	
	<link rel="stylesheet" type="text/css" href="/js/DataTables/DataTables-1.10.15/css/dataTables.bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/js/Bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/js/Bootstrap/css/bootstrap-theme.min.css">
	<link rel="stylesheet" type="text/css" href="/css/font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="/css/Site.css">

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
		
		reload = function(path){
			var settings = {
				method: 'POST',
				url: path,
				headers: {
					'Content-Type': undefined
				},
				data: { 
				}
			}
			$.ajax(settings).done(function (response) {
			  $("#content").html(response);
			});
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
		</div>
		<div id="NavRight" class="NavItem">
			<div id="login" class="NavItem">
				<label>User:</label><input type="text" id="LogUser"><label>Password:</label> <input type="password" id="LogPassword"> <button class="BlueButton">Login</button>
			</div>
		</div>
	</div>
	
	<!--div id="BodyPlaceHolder" ng-app="index" ng-controller='indexCtrl'>
		<div class="sidebar collapsed" id="sidebar">
			<ul>
				<li><a ng-click="link('resources')">Resources</a></li>
			</ul>
			<ul>
				<li><a ng-click="link('projects')">Projects</a></li>
			</ul>			
			<ul>
				<li><a ng-click="link('skills')">Skills</a></li>
			</ul>
		</div>
		<div class="content container-fluid" id="content" ng-bind-html="content">
		</div>
		<div id="ImagesHidden">
			<div id="imgLoading"><img  class=".img-responsive" style="max-width: 200px;" src="/img/loading.gif"></div>
		</div>
	</div-->
	
	<div id="BodyPlaceHolder" ng-app="index" ng-controller='indexCtrl'>
		<div id="mySidenav" class="sidenav">
		  <a href="javascript:void(0)" class="closebtn" onclick="toNav()">&times;</a>
		  <a ng-click="link('resources')" onclick="toNav();sendTitle($(this).html())">Resources</a>
		  <a ng-click="link('projects')" onclick="toNav();sendTitle($(this).html())">Projects</a>
		  <a ng-click="link('skills')" onclick="toNav();sendTitle($(this).html())">Skills</a>
		  <a href="#">About</a>
		</div>
		<div id="sidebar">
			<span style="font-size:30px;cursor:pointer" onclick="toNav()">&#9776;</span>
		</div>
		<div class="content container-fluid">
			<h1 id="titlePag"></h1>
			<div  id="content" ng-bind-html="content">
			</div>
		</div>
		<div id="ImagesHidden">
			<div id="imgLoading"><img  class=".img-responsive" style="max-width: 200px;" src="/img/loading.gif"></div>
		</div>
	</div>
	
	<div id ="FooterPlaceHolder">
	</div>
	<div id="mask" onclick="toNav()">
    
</div>
</body>
</html>
