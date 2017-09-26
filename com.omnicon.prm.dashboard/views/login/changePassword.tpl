<div class="container">
    <div class="row vertical-offset-50" style="margin-top:5%">
    	<div class="col-md-6 col-md-offset-3">
    		<div class="panel panel-default">
			  	<div class="panel-heading text-center">
			    	<h3 class="panel-title"><strong>Change Password</strong></h3>
			 	</div> 

			  	<div class="panel-body">
			    	<form accept-charset="utf-8" role="form" class="form-horizontal" method="POST" action='{{urlfor "LoginController.ChangePassword"}}'>
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
	                     <label for="inputOldPassword" class="col-sm-3 control-label">Password</label>
	                     <div class="col-sm-9">
	                        <input class="form-control" placeholder="Enter the password" name="OldPassword" type="password" value="" required 
	                           pattern=".{6,}" title="The password must be at least 6 characters" id="inputPassword"  />
	                     </div>
	                  </div>
                      <div class="form-group">
                        <label for="inputPassword" class="col-sm-3 control-label">New Password</label>
                        <div class="col-sm-9">
			    		  <input class="form-control" placeholder="Enter the new password" name="Password" type="password" value="" required 
                                    pattern=".{6,}" title="The password must be at least 6 characters" id="inputPassword"  />
                          <input class="form-control" placeholder="Confirm the new password" name="Repassword" type="password" required 
                                    pattern=".{6,}" title="The password must be at least 6 characters" />
                        </div>
                      </div>
                      <div class="form-group">
                        <div class="col-sm-12">
			    		    <input class="btn btn-lg btn-primary btn-block" type="submit" value="Change">
                        </div>
                      </div>
                    </form>
			    </div>

                <div class="panel-footer text-center clearfix">Back to the screen <a href='{{urlfor "LoginController.Login"}}'>Sign in »</a></div>

			</div>
		</div>
	</div>
</div>
