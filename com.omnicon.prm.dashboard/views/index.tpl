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
</head>

<body>
	<div id="HeaderPlaceHolder">
		<div id="NavLeft"  class="NavItem">
			<div class="NavItem">
				<div class="dropdown">
					<button id="NavMenuButton" class="btn btn-primary btn-menu toggle" type="button"><span class="glyphicon glyphicon-th-list"></span></button>
				</div>
			</div>
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
	
	<div id="BodyPlaceHolder" ng-app="index" ng-controller='indexCtrl'>
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
			<div id="imgLoading"><img  class=".img-responsive" style="max-width: 400px;" src="/img/loading.gif"></div>
		</div>
	</div>
	
	<div id ="FooterPlaceHolder">
	</div>
</body>
</html>
