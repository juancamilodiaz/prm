<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="msapplication-tap-highlight" content="no">
    <meta name="keywords" content="prm,omnicon">
    <title>PRM</title>
    <!-- Favicons-->
    <link rel="icon" href="images/favicon/nosotros-favicon.ico" sizes="32x32">
    <!-- For iPhone -->
    <meta name="msapplication-TileColor" content="#00bcd4">
    <meta name="msapplication-TileImage" content="images/favicon/nosotros-favicon.ico">
    <!-- CORE CSS--> 
    
    <link href="/static/css/Materialize/materialize.css" type="text/css" rel="stylesheet" media="screen,projection">
    <link href="/static/css/Materialize/style.css" type="text/css" rel="stylesheet" media="screen,projection">
    <link href="http://cdn.datatables.net/1.10.6/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet" media="screen,projection">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">

    <!-- INCLUDED PLUGIN CSS ON THIS PAGE -->    
    <link href="/static/js/js/plugins/data-tables/css/jquery.dataTables.min.css" type="text/css" rel="stylesheet" media="screen,projection">
  
    <link href="/static/js/js/plugins/perfect-scrollbar/perfect-scrollbar.css" type="text/css" rel="stylesheet" media="screen,projection">
    <link href="/static/js/js/plugins/jvectormap/jquery-jvectormap.css" type="text/css" rel="stylesheet" media="screen,projection">
    <link href="/static/js/js/plugins/chartist-js/chartist.min.css" type="text/css" rel="stylesheet" media="screen,projection">
    

    <script src="/static/js/Angular/angular.min.js"></script>
    
    <!-- TEMPORAL  NEEDS TO BE MOVED  -->
    <script type="text/javascript" src="/static/js/js/jquery-1.11.2.min.js"></script>  
    <script src="/static/js/Angular/angular-sanitize.js"></script>
	<script src="/static/js/palette/palette.js"></script>
	<script src="/static/js/jquery.jeditable.js"></script>
	<script src="/static/js/jquery.jeditable.mini.js"></script>
    <script src="/static/js/moment-with-locales.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.4/jspdf.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/2.3.5/jspdf.plugin.autotable.js"></script>
  

	<script>
		var app = angular.module('index', ['ngSanitize']);
		
		app.controller('indexCtrl', function($scope, $http, $compile){
			$scope.link = function(url){
                $(".page-footer").hide();
				$("#content").html("<div>"+$("#imgLoading").html()+"</div>");
				data="";
				$http.post(url)
			    .then(function(response) {
					data=response.data;
					$("#content").html(data);
                    $(".page-footer").show();
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
		
        getProjectSummaries = function(){
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
        }

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
			//reload('/projects/resources/today', data);
			reload('/productivity');
            
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
<div id="BodyPlaceHolder" ng-app="index" ng-controller='indexCtrl'>
    <!-- Start Page Loading -->
    <div id="loader-wrapper">
        <div id="loader"></div>        
        <div class="loader-section section-left"></div>
        <div class="loader-section section-right"></div>
    </div>
    <!-- End Page Loading -->

    <!-- //////////////////////////////////////////////////////////////////////////// -->

    <!-- START HEADER -->
    <header id="header" class="page-topbar">
        <!-- start header nav-->
        <div class="navbar-fixed">
            <nav class="cyan">
                <div class="nav-wrapper">
                    <h1 class="logo-wrapper"><a href="index.html" class="brand-logo darken-1"><img class="svg" src="/static/img/logo2.svg" width="240" height="41" alt="" data-mu-svgfallback="images/logo_omnicon_poster_.png"></a> <span class="logo-text">Materialize</span></h1>
                    <div class="NavCenter" class="NavItem col-sm-8">
                        <img src="/static/img/prm.png" style="cursor: pointer;">
                    </div>
                    <ul class="right hide-on-med-and-down">
                        <li class="search-out">
                            <input type="text" class="search-out-text">
                        </li>
                        <li><a href='{{urlfor "LoginController.Logout"}}' class="waves-effect waves-block waves-light"><i class="mdi-action-exit-to-app"></i></a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
        <!-- end header nav-->
    </header>
    <!-- END HEADER -->

    <!-- //////////////////////////////////////////////////////////////////////////// -->

    <!-- START MAIN -->
    <div id="main">
        <!-- START WRAPPER -->
        <div class="wrapper">
            <!-- START LEFT SIDEBAR NAV-->
            <aside id="left-sidebar-nav">
                <ul id="slide-out" class="side-nav fixed leftside-navigation">
                    <li class="user-details cyan darken-2">
                        <div class="row">
                                <div class="col col s4 m4 l4">
                                <img src="" id="ItemPreview" alt="" class="circle responsive-img valign profile-image">
                                </div>                                
                            <div class="col col s8 m8 l8">
                                <a class="btn-flat dropdown-button waves-effect waves-light white-text profile-btn" href="#" data-activates="profile-dropdown"><i class="mdi-navigation-arrow-drop-down right"></i><span id="userName"></span><span id="lastName"></span></a>
                                <ul id="profile-dropdown" class="dropdown-content">
                                    <li><a href="#"><i class="mdi-action-face-unlock"></i> Profile</a>
                                    </li>
                                    <li><a href="" ng-click="link('settings')" onclick="sendTitle($(this).html())"><i class="mdi-action-settings"></i> Settings</a>
                                    </li>
                                    <li class="divider"></li>
                                    <li><a href='{{urlfor "LoginController.Logout"}}'><i class="mdi-hardware-keyboard-tab"></i> Logout</a>
                                    </li>
                                </ul>  
                                <div id="userRole" class="user-roal userRoleText"></div>
                            </div>
                        </div>
                    </li>
                    <li class="bold"><a href="" ng-click="link('productivity')"  class="waves-effect waves-cyan"><i class="mdi-action-home"></i> Home</a>
                    </li>
                    <li class="bold"><a href="" ng-click="link('projectsForecast')" class="waves-effect waves-cyan"><i class="mdi-action-trending-up"></i> Forecast Projects</a>
                    </li>                    
                    <li class="no-padding">
                        <ul class="collapsible collapsible-accordion">
                            <li class="bold"><a class="collapsible-header waves-effect waves-cyan"><i class="mdi-action-extension"></i> Manage<i class="mdi-navigation-arrow-drop-down right"></i></a>
                                <div class="collapsible-body">
                                    <ul>
                                        <li><a href="" ng-click="link('projects')" >Projects</a>
                                        </li>                                        
                                        <li><a href="" ng-click="link('resources')">Resources</a>
                                        </li>
                                        <li><a href="" ng-click="link('skills')">Skills</a>
                                        </li>
                                        <li><a href="" ng-click="link('types')">Types</a>
                                        </li>
                                        <li><a href="" ng-click="link('trainings')">Trainings</a>
                                        </li>
                                    </ul>
                                </div>
                            </li>          
                        </ul>
                    </li>                    
                    <li class="bold"><a href="" onclick="getTypes();" class="waves-effect waves-cyan"><i class="mdi-image-blur-on"></i>Simulator</a>
                    </li>
                    <li class="bold"><a href="" ng-click="link('reports')" onclick="sendTitle($(this).html())" class="waves-effect waves-cyan"><i class="mdi-action-assessment"></i>Reports</a>
                    </li>
                    <li class="bold"><a href="" ng-click="link('dashboard')" onclick="sendTitle($(this).html())" class="waves-effect waves-cyan"><i class="mdi-action-assignment-late"></i>Status</a>
                    </li>
                    <li class="bold"><a href="" ng-click="link('trainings/resources')" onclick="sendTitle($(this).html())" class="waves-effect waves-cyan"><i class="mdi-social-school"></i>Trainings</a>
                    </li>
                    <li class="bold"><a href=""  onclick="getProjectSummaries();"  class="waves-effect waves-cyan"><i class="mdi-editor-format-list-numbered"></i>Project Summaries</a>
                    </li>
                    <li class="bold"><a href="" ng-click="link('settings')" onclick="sendTitle($(this).html())" class="waves-effect waves-cyan"><i class="mdi-action-settings"></i>Settings</a>
                    </li>

                </ul>
                <a href="#" data-activates="slide-out" class="sidebar-collapse btn-floating btn-medium waves-effect waves-light hide-on-large-only darken-2"><i class="mdi-navigation-menu" ></i></a>
            </aside>
            <!-- END LEFT SIDEBAR NAV-->
            <!-- START CONTENT -->
            <section id="content2">
                <!--start container-->
                <div  id="content" ng-bind-html="content">
                </div>
                <div id="ImagesHidden">
                    <div id="imgLoading"><img  class=".img-responsive" style="max-width: 200px; top: 0; right: 0; left: 0; bottom: 0; position: absolute; margin: auto;" src="/static/img/loading.gif"></div>
                </div>

                <!--end container-->
            </section>
            <!-- END CONTENT -->
        </div>
        <!-- END WRAPPER -->

    </div>
    </div>
    <!-- END MAIN -->

    <!-- START FOOTER -->
    
               
    <footer class="page-footer">
        <div class="footer-copyright">
            <div class="container">               
                Copyright © <a class="grey-text text-lighten-4" href="http://www.omnicon.cc/" target="_blank"> Omnicon 2018</a>Todos los derechos reservados.
                <span class="right"> Project Resource Management</span>
            </div>
        </div>
    </footer>
    <!-- END FOOTER -->


    <!-- ================================================
    Scripts
    ================================================ -->
    
    <!--materialize js-->
    <script type="text/javascript" src="/static/js/js/materialize.min.js"></script>
    <!--scrollbar-->
    <script type="text/javascript" src="/static/js/js/plugins/perfect-scrollbar/perfect-scrollbar.min.js"></script>
       

    <!-- chartist -->
    <script type="text/javascript" src="/static/js/js/plugins/chartist-js/chartist.min.js"></script>   
    <script type="text/javascript" src="/static/js/js/plugins/data-tables/js/jquery.dataTables.min.js"></script>
    
    
    <!--plugins.js - Some Specific JS codes for Plugin Settings-->
    <script type="text/javascript" src="/static/js/Utils.js"></script>
    <script type="text/javascript" src="/static/js/js/plugins.js"></script>
    <script type="text/javascript" src="/static/js/functions.js"></script>


 <script>                                   
    ProfilePicture = JSON.parse({{ .ProfilePicture}});
    PersonalInformation = JSON.parse({{ .PersonalInformation}});
    var JobTitleSplitted = PersonalInformation.JobTitle.split(",");
    var SurnameSplitted = PersonalInformation.Surname.split(" ");
    var nameSplitted = PersonalInformation.GivenName.split(" ");
    $("#userName").text(nameSplitted[0]);
    $("#lastName").text(" "+SurnameSplitted[0][0]+".");
    $("#userRole").text(JobTitleSplitted[0]);
    document.getElementById("ItemPreview").src = "data:image/png;base64," + ProfilePicture.Picture;
  
  </script> 
</body>

</html>