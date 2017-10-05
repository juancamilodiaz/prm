<div class="container">
    <div class="row vertical-offset-50" style="margin-top:5%">
    	<div class="col-md-6 col-md-offset-3">
    		<div class="panel panel-default">
			  	<div class="panel-heading text-center">
			    	<h3 class="panel-title"><strong>Grant Access</strong></h3>
			 	</div> 

			  	<div class="panel-body">
			    	<form accept-charset="utf-8" role="form" class="form-horizontal" method="POST" action='{{urlfor "LoginController.GrantAccess"}}'>
                      {{ .xsrfdata }}

                      {{template "alert.tpl" .}}
					
	                  <div class="form-group">
	                     <label for="inputEmail" class="col-sm-3 control-label">Email Address</label>
	                     <div class="col-sm-9">
	                        <input class="form-control" placeholder="ex: firstname.lastname@omnicon.cc" name="Email" value='{{index .Params "Email"}}' type="email" required 
	                           id="inputEmail" />
	                     </div>
	                  </div>
	                  <div class="form-group">
	                     <label for="inputPassword" class="col-sm-3 control-label">Password</label>
	                     <div class="col-sm-9">
	                        <input class="form-control" placeholder="Enter the password" name="Password" type="password" value="" required 
	                           pattern=".{6,}" title="The password must be at least 6 characters" id="inputPassword"  />
	                     </div>
	                  </div>
					
                      <div class="form-group">
                        <label for="inputEmailEnable" class="col-sm-3 control-label">Email Address To Enable</label>
                        <div class="col-sm-9">
                          <input class="form-control" placeholder="ex: firstname.lastname@omnicon.cc" name="EmailEnable" value='{{index .Params "EmailEnable"}}' type="email" required 
                                    id="inputEmailEnable" />
                        </div>
                      </div>
					  <div class="form-group">
                        <div class="col-sm-12">
			    		    <input class="btn btn-lg btn-primary btn-block" type="submit" value="Grant Access">
                        </div>
                      </div>
                    </form>
			    </div>
				<div class="panel-footer text-center clearfix">Back to the screen <a href='{{urlfor "LoginController.Signup"}}'>Sign up »</a></div>
			</div>
		</div>
	</div>
</div>
