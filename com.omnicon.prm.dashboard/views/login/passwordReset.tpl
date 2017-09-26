<div class="container">
    <div class="row vertical-offset-50">
    	<div class="col-md-6 col-md-offset-3">
    		<div class="panel panel-default">
			  	<div class="panel-heading text-center">
			    	<h3 class="panel-title"><strong>Password Reset</strong></h3>
			 	</div> 

			  	<div class="panel-body">
			    	<form accept-charset="utf-8" role="form" class="form-horizontal" method="POST" action='{{urlfor "LoginController.PasswordReset"}}'>
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
                        <div class="col-sm-12">
			    		    <input class="btn btn-lg btn-primary btn-block" type="submit" value="Remember password">
                        </div>
                      </div>
                    </form>
			    </div>
				<div class="panel-footer text-center clearfix">Back to the screen <a href='{{urlfor "LoginController.Login"}}'>Sign in »</a></div>
			</div>
		</div>
	</div>
</div>
